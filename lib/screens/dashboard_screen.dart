import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/screens/dashboard/biodiv_screen.dart';
import 'package:eco_explorer/screens/dashboard/cata_screen.dart';
import 'package:eco_explorer/screens/dashboard/enviro_screen.dart';
import 'package:eco_explorer/screens/dashboard/info_screen.dart';
import 'package:eco_explorer/utils/kml/balloon_entity.dart';
import 'package:eco_explorer/widgets/connection_bar.dart';
import 'package:eco_explorer/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import '../constants/strings.dart';
import '../constants/theme.dart';
import '../models/forests_model.dart';
import '../ref/instance_provider.dart';
import '../ref/values_provider.dart';
import '../utils/connection/ssh.dart';
import '../utils/orbit_controller.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> with TickerProviderStateMixin{
  late int index;
  final title = ['Information','Biodiversity','Environment','Catastrophes'];
  final pages = [InfoScreen(), BiodivScreen(), EnviroScreen(), CataScreen()];

  final List<MapType> maps = [MapType.satellite, MapType.terrain, MapType.hybrid];

  late Ssh ssh;
  late Forest forest;

  late bool isOrbitPlaying;
  bool connectionStatus = false;

  // GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    ssh = ref.read(sshProvider);
    forest = ref.read(forestProvider.notifier).state!;
    Future.microtask((){
      ref.read(isOrbitPlayingProvider.notifier).state = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    double lat = forest.lat;
    double lon = forest.lon;

    index = ref.watch(dashboardIndexProvider);
    final mapIndex = ref.watch(mapIndexProvider);
    final selectedMapType = maps[mapIndex];

    isOrbitPlaying = ref.watch(isOrbitPlayingProvider);

    Color textColour = (mapIndex!=1)?Colors.white:Colors.black;

    return PopScope(
      onPopInvoked: (didPop) {
        ref.read(dashboardIndexProvider.notifier).state = 0;
        ref.read(mapIndexProvider.notifier).state = 0;
        ref.read(isOrbitPlayingProvider.notifier).state = false;
      },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Themes.bg,
            extendBodyBehindAppBar: true,
            body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: (mapIndex!=1)?Color(0xff364935):Color(0xffCEF1DC),
                    leading: IconButton(
                      onPressed: () { Navigator.pop(context); },
                      icon: Icon(Icons.arrow_back,color: textColour,),
                    ),
                    expandedHeight: Constants.totalHeight(context)*0.3,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.zero,
                      background: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          GoogleMap(
                            key: ValueKey(selectedMapType),
                            mapType: selectedMapType,
                            // onMapCreated: (GoogleMapController controller) {
                            //   mapController = controller;
                            // },
                            initialCameraPosition: CameraPosition(
                                target: LatLng(lat,lon),
                                zoom: Constants.mapScale
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: Constants.totalHeight(context)*0.01),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(height: Constants.totalWidth(context)*0.15,),
                                Column(
                                  children: [
                                    Text('Latitude',style: Fonts.bold.copyWith(fontSize: Constants.totalHeight(context)*0.02,color: textColour),),
                                    SizedBox(height: Constants.totalHeight(context)*0.01,),
                                    Text(lat.toString(),style: Fonts.bold.copyWith(fontSize: Constants.totalHeight(context)*0.02,color:textColour),),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Longitude',style: Fonts.bold.copyWith(fontSize: Constants.totalHeight(context)*0.02,color: textColour),),
                                    SizedBox(height: Constants.totalHeight(context)*0.01,),
                                    Text(lon.toString(),style: Fonts.bold.copyWith(fontSize: Constants.totalHeight(context)*0.02,color: textColour),),
                                  ],
                                ),
                                SizedBox(width: Constants.totalHeight(context)*0.005,)
                              ],
                            ),
                          ),
                        ],
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(width: Constants.totalWidth(context)*0.01,),
                          SizedBox(
                            width: Constants.totalWidth(context)*0.45,
                            child: Text(
                              forest.name,
                              style: Fonts.bold.copyWith(
                                  fontSize: Constants.totalWidth(context)*0.04,
                                  color: textColour),
                              maxLines: 2,
                              // strokeColor: Colors.black,strokeWidth: 2,
                            ),
                          ),
                          // SizedBox(width: Constants.totalWidth(context)*0.1,),
                          TextButton(
                            onPressed: () async {
                              if(ssh.isConnected == false){
                                showSnackBar(context, 'Not connected to the rig', Themes.error);
                                return;
                              }
                              isOrbitPlaying?await stopOrbit(lat, lon): await playOrbit(lat, lon);
                            },
                            child: Tooltip(
                              message: isOrbitPlaying?'Stop Orbit':'Play Orbit',
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(Constants.totalWidth(context)*0.05)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 5
                                      )]
                                ),
                                child: CircleAvatar(
                                    radius: Constants.totalWidth(context)*0.035,
                                    backgroundColor: Colors.white,
                                    child: Center(child: Icon(isOrbitPlaying?Icons.stop:Icons.play_arrow,
                                      color: Colors.black,size: Constants.totalWidth(context)*0.05,),
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Stack(
                        //   alignment: AlignmentDirectional.bottomCenter,
                        //   children: [
                        //   ],
                        // ),
                        SizedBox(height: Constants.cardMargin(context),),
                        Container(
                          decoration: BoxDecoration(
                            color: Themes.mapInactiveBg,
                            borderRadius: BorderRadius.circular(Constants.totalWidth(context)*0.075),
                          ),
                          padding: EdgeInsets.zero,
                          child: ToggleButtons(
                            borderRadius: BorderRadius.circular(Constants.totalWidth(context)*0.075),
                            isSelected: List.generate(labels.length, (i) => i == mapIndex),
                            onPressed: (index) {
                              setState(() {
                                ref.read(mapIndexProvider.notifier).state = index;
                                // selectedMapType = maps[index];
                                print('Selected: $selectedMapType');
                              });
                            },
                            selectedColor: Themes.mapActiveText,
                            selectedBorderColor: Themes.mapActiveBg,
                            borderColor: Themes.mapActiveBg,
                            color: Themes.mapInactiveText,
                            fillColor: Themes.mapActiveBg,
                            splashColor: Colors.transparent,
                            constraints: BoxConstraints(minHeight: Constants.totalWidth(context)*0.1, minWidth: Constants.totalWidth(context)*0.25),
                            children: labels
                                .map((label) => Text(
                              label,
                              style: Fonts.semiBold,
                            ))
                                .toList(),
                          ),
                        ),
                        SizedBox(height: Constants.cardMargin(context),),
                        Padding(padding: EdgeInsets.symmetric(horizontal: Constants.cardPadding(context)),
                          child: Column(
                            children: [
                              ConnectionBar(ref: ref,),
                              SizedBox(height: 0.5*Constants.cardMargin(context),),
                              Row(
                                children: [
                                  Text(title[index], style: Fonts.bold.copyWith(fontSize: Constants.totalHeight(context)*0.03,color: Themes.secondaryText),),
                                ],
                              ),
                              SizedBox(height: Constants.cardMargin(context),),
                              pages[index],
                              SizedBox(height: Constants.bottomGap(context)),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ]
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: 'Voice Assistant',
              shape: CircleBorder(),
              backgroundColor: Colors.transparent,
              onPressed: () {
              },
              // child: Image.asset(
              //   'assets/voice/voice.png',
              //   width: Constants.totalHeight(context) * 0.2,
              //   height: Constants.totalHeight(context) * 0.2,
              // ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(Constants.totalHeight(context) * 0.2)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 5,
                          spreadRadius: 2
                      )
                    ]
                ),
                child: Lottie.asset(
                    'assets/voice/anim.json',
                    width: Constants.totalHeight(context) * 0.2,
                    height: Constants.totalHeight(context) * 0.2,
                    fit: BoxFit.contain,
                    animate: false,
                    repeat: false
                ),
              ),
              // child: RiveAnimation.asset(
              //     fit: BoxFit.contain,
              //   'assets/voice/mic.riv',
              //   artboard: 'frame_01',
              //   stateMachines: ['sm_01'],
              //     onInit: (artboard) {
              //       StateMachineController? controller=
              //       StateMachineController.fromArtboard(artboard,'sm_01');
              //
              //       artboard.addController(controller!);
              //
              //       _controller = controller;
              //
              //       startRecord = _controller.findSMI<SMITrigger>('start record');
              //       startProcess = _controller.findSMI<SMITrigger>('start process');
              //       endRecord = _controller.findSMI<SMITrigger>('end record');
              //     }
              // ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            extendBody: true,
            bottomNavigationBar: BottomAppBar(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              color: Colors.black,
              notchMargin: 6,
              shape: const CircularNotchedRectangle(),
              child: Row(
                // mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildTabItem(index: 0, icon: Icons.info),
                  buildTabItem(index: 1, icon: Icons.pets),
                  SizedBox(width: 50,),
                  buildTabItem(index: 2, icon: Icons.air),
                  buildTabItem(index: 3, icon: Icons.local_fire_department),
                ],
              ),
            )
        ),
      ),
    );
  }

  // void onChangedTab(int newIndex) {
  //   setState(() {
  //     index = newIndex;
  //   });
  // }

  Widget buildTabItem({required int index, required IconData icon}){
    final isSelected = index == this.index;
    return IconButton(
        onPressed: ()=>onChangedTab(ref, dashboardIndexProvider, index),
        tooltip: title[index],
        icon: Icon(icon, color: isSelected?Themes.logoActive:Themes.logoInactive,weight: 400,)
    );
  }

  playOrbit(lat, lon) async{
    if(ssh.isConnected == false){
      showSnackBar(context, 'Not connected to the rig', Themes.error);
      return;
    }

    await ssh.sendKmltoSlave(context, BalloonEntity.orbitBalloon(ref.read(forestProvider.notifier).state!, Constants.forestImage(forest.path), Constants.orbitScale, 0, 0), Constants.rightRig(ssh.rigCount()));
    ref.read(isOrbitPlayingProvider.notifier).state = true;
    await OrbitController().startOrbit(context, ref, ssh, lat, lon, Constants.orbitAltitude);
    if (!mounted) {
      return;
    }
    await stopOrbit(lat, lon);
  }

  stopOrbit(lat, lon) async{
    ref.read(isOrbitPlayingProvider.notifier).state = false;
    await OrbitController().stopOrbit(context, ssh, lat, lon,Constants.forestAltitude);
  }
}