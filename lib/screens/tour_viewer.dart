import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tour_model.dart';
import '../ref/instance_provider.dart';
import '../ref/values_provider.dart';
import '../utils/connection/ssh.dart';
import '../utils/kml/kml_entity.dart';

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
  bool isPlaying = false;

  final CarouselSliderController _controller = CarouselSliderController();

  late Ssh ssh;
  late List<IndividualTour> locations;

  @override
  void initState() {
    super.initState();
    ssh = ref.read(sshProvider);
    locations = widget.model.locations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        onPressed: () {
          if(!isPlaying){
            startTour();
          }
          else{
            stopTour();
          }
      },
        backgroundColor: Themes.secondaryButtonBg,
        shape: CircleBorder(),
        child: Icon(isPlaying?Icons.stop:Icons.play_arrow,
          color: Themes.secondaryButtonFill,),
      )
    );
  }

  Future<void> startTour() async {
    try {
      File? file;
      String filename = '${widget.name}_tour.kml';

      setState(() {
        isPlaying = true;
      });

      String desc = '';
      for (IndividualTour tour in locations) {
        desc += '${tour.name} - ${tour.desc}\n';
      }

    } catch (e) {
      print('Error starting tour: $e');
    } finally {
      setState(() {
        isPlaying = false;
      });
    }
  }

  Future<void> stopTour() async {
    try {
      await ssh.stopOrbit(context);
    } catch (e) {
      print('Error stopping tour: $e');
    } finally {
      setState(() {
        isPlaying = false;
      });
    }
  }
}
