import 'dart:io';

import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/models/fire/fire_model.dart';
import 'package:eco_explorer/screens/rig_controller.dart';
import 'package:eco_explorer/utils/orbit_controller.dart';
import 'package:eco_explorer/widgets/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../ref/instance_provider.dart';
import '../ref/values_provider.dart';
import '../utils/connection/ssh.dart';
import '../utils/kml/balloon_entity.dart';
import '../utils/kml/kml_entity.dart';
import '../widgets/loading.dart';

class MapView extends ConsumerStatefulWidget {
  final double lat;
  final double lon;
  final List<FireInfo>? fires;
  const MapView({super.key, required this.lat, required this.lon, this.fires});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {

  late CameraPosition mapPosition;
  late CameraPosition initialPosition;
  GoogleMapController? mapController;

  bool isLoading = false;
  Set<Marker> activeFires= {};
  late Ssh ssh;
  FireInfo? selectedFire;

  final List<MapType> maps = [MapType.satellite, MapType.terrain, MapType.hybrid];

  bool isOrbitPlaying = false;

  @override
  void initState() {
    super.initState();
    ssh = ref.read(sshProvider);
    // print(widget.fires!.length);

    initialPosition=CameraPosition(target: LatLng(widget.lat, widget.lon),
        zoom: Constants.mapScale);

    () async => await ssh.flyToWithoutSaving(context, ref, widget.lat, widget.lon, Constants.forestAltitude, Constants.defaultScale,0, 0);

    if(widget.fires != null){
      for(int i=0; i<widget.fires!.length;i++){
        FireInfo fire = widget.fires![i];

        final ti4 = fire.bright_ti4;
        final ti5 = fire.bright_ti5;
        final delta = ti4 - ti5;
        final style =
        (delta >= 100 || ti4 >= 360) ? BitmapDescriptor.hueRed : (delta >= 50 || ti4 >= 330) ? BitmapDescriptor.hueOrange : BitmapDescriptor.hueYellow;

        activeFires.add(
            Marker(
              markerId: MarkerId('$i'),
              position: LatLng(fire.lat, fire.lon),
              icon: BitmapDescriptor.defaultMarkerWithHue(style),
              onTap: ()=> onFireTapped(fire),
                consumeTapEvents: true
            )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final mapIndex = ref.watch(mapIndexProvider);
    final selectedMapType = maps[mapIndex];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () { Navigator.pop(context); },
          icon: Icon(Icons.arrow_back,color: (widget.fires !=null)?Colors.white:Colors.transparent,),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: (widget.fires !=null)?Constants.totalHeight(context):Constants.totalHeight(context)*0.4,
            width: Constants.totalWidth(context),
            child: GoogleMap(
              key: ValueKey(selectedMapType),
              mapType: selectedMapType,
              initialCameraPosition: initialPosition,
              markers: activeFires,
              onMapCreated: (controller){
                mapController = controller;
              },
              onTap: (position) => onTap(position),
              onCameraMove: (pos)=>
                setState(() {
                  mapPosition = pos;
                })
              ,
              onCameraIdle: () async{
                await stopOrbit();
                await ssh.flyTo(ref, context, mapPosition.target.latitude, mapPosition.target.longitude,
                     mapPosition.zoom, mapPosition.tilt, mapPosition.bearing);
              },
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                ),
              },
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
            ),
          ),
          if(isLoading)
          Loading()
        ],
      ),
      floatingActionButton: (widget.fires !=null)?FloatingActionButton.extended(
        onPressed: () async{
          isOrbitPlaying? await stopOrbit(): await playOrbit();
          // showOverlay(context,ssh);
        },
        backgroundColor: Colors.white,
        label: Text(isOrbitPlaying?'Stop Orbit':'Play Orbit',style: Fonts.bold.copyWith(color: Colors.black)),
        icon: Icon(isOrbitPlaying?Icons.stop:Icons.play_arrow,color: Colors.black,),
      ):null
    );
  }

  onTap(LatLng position) async{
    if (widget.fires !=null) {
      setState(() => isLoading = true);

      await Future.delayed(const Duration(milliseconds: 500));

      const double tolerance = 0.1;

      for (FireInfo fire in widget.fires!) {
        if ((fire.lat - position.latitude).abs() <= tolerance &&
            (fire.lon - position.longitude).abs() <= tolerance) {
          onFireTapped(fire);
          return;
        }
      }

      setState(() => isLoading = false);
      showSnackBar(context, 'No active fire found at this location', Themes.error);
    }
  }

  void onFireTapped(FireInfo fire) async{
    setState(() {
      selectedFire = fire;
    });
    print('Fire tapped: ${fire.bright_ti5}');
    if(!ssh.isConnected) return;
    String filename = '${fire.lat}_${fire.lon}_Fire.kml';
    String logoname = 'Logo.kml';
    print(filename);
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    print(KmlEntity.getZoomedFireKml(fire));

    File? file = await ssh.makeFile(Constants.filename, KmlEntity.getZoomedFireKml(fire));
    await ssh.kmlFileUpload(file!,filename);
    await ssh.sendKml(context, filename);

    File? logoFile = await ssh.makeFile(Constants.filename, KmlEntity.getLogoKml(fire));
    await ssh.kmlFileUpload(logoFile!,logoname);
    await ssh.appendKml(context, logoname);

    await ssh.sendKmltoSlave(context, BalloonEntity.zoomedFireBalloon(fire, Constants.defaultScale, 0, 0), Constants.rightRig(ssh.rigCount()));

    // ref.read(isOrbitPlayingProvider.notifier).state = true;

    if (mapController != null) {
      await mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(fire.lat, fire.lon),
          Constants.fireScale,
        ),
      );
    }

    setState(() => isLoading = false);
    showSnackBar(context, 'Zooming in..', Colors.grey[800]!);
  }

  playOrbit() async{
    if (selectedFire!=null) {

      setState(() {
        isOrbitPlaying=true;
      });

      File? orbitFile;
      String orbitFilename = 'Orbit.kml';

      String kmlContent = KmlEntity.buildOrbit(selectedFire!.lat, selectedFire!.lon);
      orbitFile = await ssh.makeFile(Constants.filename, kmlContent);

      if (orbitFile == null) {
        showSnackBar(context, 'KML creation failed', Themes.error);
        return;
      }

      await ssh.kmlFileUpload(orbitFile, orbitFilename);
      await ssh.appendKml(context, orbitFilename);
      await ssh.startOrbit(context);


      kmlContent = KmlEntity.buildOrbit(selectedFire!.lat, selectedFire!.lon);
      orbitFile = await ssh.makeFile(Constants.filename, kmlContent);

      if (orbitFile == null) {
        showSnackBar(context, 'KML creation failed', Themes.error);
        return;
      }

      await ssh.kmlFileUpload(orbitFile, orbitFilename);
      await ssh.appendKml(context, orbitFilename);
      await ssh.startOrbit(context);

      await Future.delayed(Duration(seconds: 45),() async {
        await stopOrbit();
      });

    } else{
      showSnackBar(context, 'No fire selected', Themes.error);
    }
  }

  stopOrbit() async{
    setState(() {
      isOrbitPlaying=false;
    });
    await ssh.flyTo(ref, context, mapPosition.target.latitude, mapPosition.target.longitude, mapPosition.zoom, 0, 0);
  }
}
