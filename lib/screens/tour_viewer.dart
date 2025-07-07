import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tour_model.dart';
import '../providers/deepgram_provider.dart';
import '../ref/instance_provider.dart';
import '../ref/values_provider.dart';
import '../utils/connection/ssh.dart';
import '../utils/kml/balloon_entity.dart';
import '../utils/kml/kml_entity.dart';
import '../utils/orbit_controller.dart';

class TourViewer extends ConsumerStatefulWidget {
  final String name;
  final TourModel model;
  final OverlayEntry? entry;
  final bool voiceGuide;
  const TourViewer({super.key, required this.model, required this.entry, required this.voiceGuide, required this.name});

  @override
  ConsumerState<TourViewer> createState() => _TourViewerState();
}

class _TourViewerState extends ConsumerState<TourViewer> {
  int currentIndex = 0;
  late bool isPlaying;

  final CarouselSliderController _controller = CarouselSliderController();
  final provider = DeepgramProvider();

  late Ssh ssh;
  late List<IndividualTour> locations;

  @override
  void initState() {
    super.initState();
    ssh = ref.read(sshProvider);
    locations = widget.model.locations;
    ref.read(isOrbitPlayingProvider.notifier).state = false;
  }

  @override
  void dispose() {
    provider.disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    isPlaying = ref.watch(isOrbitPlayingProvider);

    return PopScope(
      onPopInvoked: (didPop) {
        ref.read(isOrbitPlayingProvider.notifier).state = false;
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () { widget.entry?.remove(); },
              icon: Icon(Icons.close,color: Colors.white,),
            ),
          ),
          backgroundColor: Colors.black.withOpacity(0.75),
          body: Center(
              child: PageStorage(
                bucket: PageStorageBucket(),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CarouselSlider(
                          items: locations.map((e)=>
                              Container(
                                  padding: EdgeInsets.all(Constants.cardPadding(context)),
                                  // height: height!,
                                  width: Constants.totalWidth(context)*0.75,
                                  decoration: BoxDecoration(
                                    color: Color(0xffE4E3A4),
                                    borderRadius: BorderRadius.all(Radius.circular(Constants.cardRadius(context))),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(e.name,style: Fonts.bold.copyWith(fontSize: Constants.totalHeight(context)*0.0275,color: Themes.cardBg),),
                                        SizedBox(height: 0.5*Constants.cardMargin(context),),
                                        Container(
                                          height: 1,
                                          width: Constants.totalWidth(context)*0.6,
                                          color: Themes.cardBg,
                                        ),
                                        SizedBox(height: 0.5*Constants.cardMargin(context),),
                                        Text(e.desc,style: Fonts.regular.copyWith(fontSize: Constants.totalHeight(context)*0.015,color: Themes.cardBg),),
                                      ],
                                    ),
                                  )
                              )
                          ).toList(),
                          options: CarouselOptions(
                              height: Constants.totalHeight(context)*0.5,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason){
                                setState(() {
                                  currentIndex = index;
                                });
                              }
                          ),
                        ),
                        SizedBox(height: 0.5*Constants.cardMargin(context),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: locations.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => _controller.animateToPage(entry.key),
                              child: Container(
                                width: Constants.totalHeight(context)*0.01,
                                height: Constants.totalHeight(context)*0.01,
                                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(currentIndex == entry.key ? 0.9 : 0.4)),
                              ),
                            );
                          }).toList(),
                        ),
                      ]),
                ),
              )
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if(!isPlaying){
                await startTour();
              }
              else{
                await stopTour();
              }
            },
            backgroundColor: Themes.secondaryButtonBg,
            shape: CircleBorder(),
            child: Icon(isPlaying?Icons.stop:Icons.play_arrow,
              color: Themes.secondaryButtonFill,),
          )
      ),
    );
  }

  Future<void> startTour() async {
    try {
      // File? file;
      // String filename = 'Orbit.kml';
      final forest = ref.read(forestProvider.notifier).state!;
      if(!ssh.isConnected) return;

      ref.read(isOrbitPlayingProvider.notifier).state = true;

      // String kmlContent = KmlEntity.buildForestTour(widget.model, widget.voiceGuide ? 20 : 5);
      // print(kmlContent);
      //
      // file = await ssh.makeFile(filename, kmlContent);
      //
      // if (file == null) throw Exception('KML creation failed');
      //
      // await ssh.kmlFileUpload(file!, filename);
      // if(!mounted) return;
      // await ssh.sendKml(context, filename);
      // if(!mounted) return;
      // await ssh.startOrbit(context);

      if (widget.voiceGuide) {
        await provider.speakFromText('Welcome to ${forest.name}', context);
      }

      for(IndividualTour tour in locations){
        if(!ref.read(isOrbitPlayingProvider)) break;
        await ssh.sendKmltoSlave(context, BalloonEntity.orbitBalloon(ref.read(forestProvider.notifier).state!, tour.name, Constants.orbitScale, 0, 0), Constants.rightRig(ssh.rigCount()));

        if (widget.voiceGuide) {
          await provider.speakFromText('${tour.name}. ${tour.desc}', context);
        }

        await OrbitController().startOrbit(context, ref, ssh, tour.lat, tour.lon, Constants.tourAltitude);
      }

    } catch (e) {
      print('Error starting tour: ${e.toString()}');
    } finally {
      if (mounted && ref.read(isOrbitPlayingProvider)) {
        await stopTour();
      }
    }
  }


  Future<void> stopTour() async {
    try {
      if(!ssh.isConnected) return;

      ref.read(isOrbitPlayingProvider.notifier).state = false;
      final forest = ref.read(forestProvider.notifier).state!;
      // await ssh.stopOrbit(context);
      await OrbitController().stopOrbit(context, ssh, forest.lat, forest.lon,Constants.forestAltitude);
      await provider.stopSpeaking();
    } catch (e) {
      print('Error stopping tour: $e');
    }
  }
}
