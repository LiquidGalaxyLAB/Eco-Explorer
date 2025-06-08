import 'package:eco_explorer/bloc/aqi_bloc.dart';
import 'package:eco_explorer/bloc/fire_bloc.dart';
import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/models/aqi/aqi_model.dart';
import 'package:eco_explorer/models/fire/fire_model.dart';
import 'package:eco_explorer/models/historical_aqi/hist_aqi_model.dart';
import 'package:eco_explorer/providers/nasa_firms_data_provider.dart';
import 'package:eco_explorer/repositories/fire_repository.dart';
import 'package:eco_explorer/screens/dashboard/biodiv_screen.dart';
import 'package:eco_explorer/screens/dashboard/cata_screen.dart';
import 'package:eco_explorer/screens/dashboard/enviro_screen.dart';
import 'package:eco_explorer/screens/dashboard/info_screen.dart';
import 'package:eco_explorer/widgets/connection_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stroke_text/stroke_text.dart';

import '../bloc/hist_aqi_bloc.dart';
import '../constants/strings.dart';
import '../constants/theme.dart';
import '../models/forests_model.dart';
import '../providers/aqi_data_provider.dart';
import '../providers/local/db_provider.dart';
import '../providers/local/db_service.dart';
import '../repositories/aqi_repository.dart';
import '../utils/connection/ssh.dart';

class DashboardScreen extends StatefulWidget {
  final Forest forest;
  final Ssh ssh;
  const DashboardScreen({super.key, required this.forest, required this.ssh});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int index = 0;
  final title = ['Information','Biodiversity','Environment','Catastrophes'];

  late Ssh ssh;

  final List<String> labels = ['Satellite', 'Terrain', 'Hybrid'];
  final List<MapType> maps = [MapType.satellite, MapType.terrain, MapType.hybrid];
  int selectedIndex = 0;
  MapType selectedMapType = MapType.satellite;

  bool isOrbitPlaying = false;
  bool connectionStatus = false;

  // GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    ssh = widget.ssh;
  }

  @override
  Widget build(BuildContext context) {
    double horizontalPadding = Constants.cardPadding(context);

    Forest forest = widget.forest;

    double lat = forest.lat;
    double lon = forest.lon;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) =>
            AqiRepository(AqiDataProvider(),
                DbProvider<AqiModel>(dbService: DbService(key: Constants.aqiDb,
                    adapter: AqiModelAdapter())),AqiModel.fromMap)),
        RepositoryProvider(create: (context) =>
            AqiRepository(HistAqiDataProvider(),
                DbProvider<HistAqiModel>(dbService: DbService(key: Constants.histAqiDb,
                    adapter: HistAqiModelAdapter())),HistAqiModel.fromMap)),
        RepositoryProvider(create: (context) =>
            FireRepository(NasaFirmsDataProvider(),
                DbProvider(dbService: DbService(key: Constants.fireDb, adapter: FireModelAdapter())))
        ),

      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AqiBloc(context.read<AqiRepository<AqiModel>>())),
          BlocProvider(create: (context) => HistAqiBloc(context.read<AqiRepository<HistAqiModel>>())),
          BlocProvider(create: (context) => FireBloc(context.read<FireRepository>())),
        ],
        child: Builder(
          builder: (context) {

            final pages = [
              InfoScreen(forest: forest,ssh:ssh),
              BiodivScreen(forest: forest,ssh:ssh),
              EnviroScreen(forest: forest,ssh:ssh),
              CataScreen(forest: forest,ssh:ssh)
            ];

            return Scaffold(
              backgroundColor: Themes.bg,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () { Navigator.pop(context); },
                  icon: Icon(Icons.arrow_back,color: Colors.white,),
                ),
                title: Padding(
                  padding: EdgeInsets.only(top: Constants.totalHeight(context)*0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text('Latitude',style: Fonts.bold.copyWith(fontSize: Constants.totalHeight(context)*0.02,color: Colors.white),),
                          SizedBox(height: Constants.totalHeight(context)*0.01,),
                          Text(lat.toString(),style: Fonts.bold.copyWith(fontSize: Constants.totalHeight(context)*0.02,color: Colors.white),),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Longitude',style: Fonts.bold.copyWith(fontSize: Constants.totalHeight(context)*0.02,color: Colors.white),),
                          SizedBox(height: Constants.totalHeight(context)*0.01,),
                          Text(lon.toString(),style: Fonts.bold.copyWith(fontSize: Constants.totalHeight(context)*0.02,color: Colors.white),),
                        ],
                      ),
                      SizedBox(width: Constants.totalHeight(context)*0.005,)
                    ],
                  ),
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
              ),
                floatingActionButton: FloatingActionButton(
                  // shape: CircleBorder(),
                  backgroundColor: Colors.transparent,
                  onPressed: () {
            
                  },
                  // child: Image.asset(
                  //   'assets/voice/voice.png',
                  //   width: Constants.totalHeight(context) * 0.2,
                  //   height: Constants.totalHeight(context) * 0.2,
                  // ),
                  // child: RiveAnimation.asset(''),
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
            );
          }
        ),
      ),
    );
  }

  void onChangedTab(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  Widget buildTabItem({required int index, required IconData icon}){
    final isSelected = index == this.index;
    return IconButton(
        onPressed: ()=>onChangedTab(index),
        tooltip: title[index],
        icon: Icon(icon, color: isSelected?Themes.logoActive:Themes.logoInactive,weight: 400,)
    );
  }

  playOrbit(lat, lon) async{
    setState(() {
      isOrbitPlaying = true;
    });
    ssh.flyToOrbit(context, lat, lon, Constants.orbitScale, 0, 0);
    await Future.delayed(Duration(seconds: 2));
    for (int i = 0; i <= 360; i += 10) {
      if (!mounted) {
        return;
      }
      if (!isOrbitPlaying) {
        break;
      }
      ssh.flyToOrbit(context, lat, lon, Constants.orbitScale, 60, i.toDouble());
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    if (!mounted) {
      return;
    }
    setState(() {
      isOrbitPlaying = false;
    });
  }

  stopOrbit(lat, lon) async{
    setState(() {
      isOrbitPlaying = false;
    });
    ssh.flyToOrbit(context, lat, lon, Constants.orbitScale, 0, 0);
  }
}
