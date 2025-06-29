import 'dart:io';

import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/models/fire/fire_model.dart';
import 'package:eco_explorer/screens/rig_controller.dart';
import 'package:eco_explorer/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../ref/instance_provider.dart';
import '../utils/connection/ssh.dart';
import '../utils/kml/balloon_entity.dart';
import '../utils/kml/kml_entity.dart';
import '../widgets/loading.dart';

class MapView extends ConsumerStatefulWidget {
  final double lat;
  final double lon;
  final List<FireInfo> fires;
  const MapView({super.key, required this.lat, required this.lon, required this.fires});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {

  bool isLoading = false;
  Set<Marker> activeFires= {};
  late Ssh ssh;

  @override
  void initState() {
    super.initState();
    ssh = ref.read(sshProvider);
    print(widget.fires.length);
    for(int i=0; i<widget.fires.length;i++){
      FireInfo fire = widget.fires[i];
      activeFires.add(
          Marker(
              markerId: MarkerId('$i'),
              position: LatLng(fire.lat, fire.lon),
            onTap: ()=> onFireTapped(fire),
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () { Navigator.pop(context); },
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: Constants.totalHeight(context),
            width: Constants.totalWidth(context),
            child: GoogleMap(
              mapType: MapType.satellite,
                initialCameraPosition:
                CameraPosition(target: LatLng(widget.lat, widget.lon),zoom: 3),
              markers: activeFires,
<<<<<<< Updated upstream
<<<<<<< Updated upstream
              onTap: onTap,
=======
              // onTap: onTap,
>>>>>>> Stashed changes
=======
              // onTap: onTap,
>>>>>>> Stashed changes
            ),
          ),
          if(isLoading)
          Loading()
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
          showOverlay(context);
=======
          showOverlay(context,ssh);
>>>>>>> Stashed changes
=======
          showOverlay(context,ssh);
>>>>>>> Stashed changes
        },
        backgroundColor: Colors.white,
        label: Text('Open Controller',style: Fonts.bold.copyWith(color: Colors.black)),
        icon: Icon(Icons.control_camera,color: Colors.black,),
      )
    );
  }
<<<<<<< Updated upstream
<<<<<<< Updated upstream

  onTap(LatLng position) async{
    setState(() => isLoading = true);

    await Future.delayed(const Duration(milliseconds: 500));

    const double tolerance = 0.1;

    for (FireInfo fire in widget.fires) {
      if ((fire.lat - position.latitude).abs() <= tolerance &&
          (fire.lon - position.longitude).abs() <= tolerance) {
        onFireTapped(fire);
        return;
      }
    }

    setState(() => isLoading = false);
    showSnackBar(context, 'No active fire found at this location', Themes.error);
  }

  void onFireTapped(FireInfo fire) async{
    String filename = '${fire.lat}_${fire.lon}_Fire.kml';
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    print('Fire tapped: ${fire.bright_ti5}');
    setState(() => isLoading = false);
    showSnackBar(context, 'Zooming in..', Colors.grey[800]!);
=======
=======
>>>>>>> Stashed changes
  //
  // onTap(LatLng position) async{
  //   setState(() => isLoading = true);
  //
  //   await Future.delayed(const Duration(milliseconds: 500));
  //
  //   const double tolerance = 0.1;
  //
  //   for (FireInfo fire in widget.fires) {
  //     if ((fire.lat - position.latitude).abs() <= tolerance &&
  //         (fire.lon - position.longitude).abs() <= tolerance) {
  //       onFireTapped(fire);
  //       return;
  //     }
  //   }
  //
  //   setState(() => isLoading = false);
  //   showSnackBar(context, 'No active fire found at this location', Themes.error);
  // }

  void onFireTapped(FireInfo fire) async{
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
  }
}
