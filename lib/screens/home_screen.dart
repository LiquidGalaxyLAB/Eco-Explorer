import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/screens/help_screen.dart';
import 'package:eco_explorer/widgets/connection_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
// import 'package:lottie/lottie.dart';

import '../bloc/forest_bloc.dart';
import '../providers/forest_data_provider.dart';
import '../repositories/forest_repository.dart';
import '../utils/connection/ssh.dart';
import 'home/about_screen.dart';
import 'home/api_auth_screen.dart';
import 'home/preferences.dart';
import 'home/start_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  late final List<Widget> pages;
  final title = ['Eco Explorer','API Authentication','Preferences','About'];

  late Ssh ssh;

  // late StateMachineController _controller;
  // SMITrigger? startRecord;
  // SMITrigger? startProcess;
  // SMITrigger? endRecord;

  @override
  void initState() {
    super.initState();
    ssh = Ssh();
    pages = [StartScreen(ssh: ssh,),ApiAuthScreen(),Preferences(ssh: ssh,),AboutScreen()];
    _connectToLG();
  }

  Future<void> _connectToLG() async {
    await ssh.connectToLG(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => ForestRepository(ForestDataProvider())),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ForestBloc(context.read<ForestRepository>())),
        ],
        child: Scaffold(
          backgroundColor: Themes.bg,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Themes.bg,
            title: Text(
              title[index],
              style: Fonts.extraBold.copyWith(
                fontSize: Constants.totalWidth(context) * 0.05,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen()));
                },
                icon: const Icon(Icons.help_outline),
                color: Themes.logoInactive,
                focusColor: Themes.logoActive,
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(left: Constants.cardPadding(context),right: Constants.cardPadding(context),bottom: Constants.cardPadding(context)),
            child: Column(
              children: [
                ConnectionBar(connectionStatus: ssh.isConnected),
                SizedBox(height: Constants.cardPadding(context)),
                Expanded(
                  child: pages[index],
                ),
                // SizedBox(height: Constants.bottomGap(context)),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.transparent,
            onPressed: () {},
            // child: Image.asset(
            //   'assets/voice/voice.png',
            //   width: Constants.totalHeight(context) * 0.2,
            //   height: Constants.totalHeight(context) * 0.2,
            // ),
            // child: Lottie.asset(
            //     'assets/voice/anim.json',
            //     width: Constants.totalHeight(context) * 0.2,
            //     height: Constants.totalHeight(context) * 0.2,
            //   fit: BoxFit.contain,
            //   animate: true,
            // ),
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
            padding: EdgeInsets.symmetric(horizontal: Constants.totalWidth(context) * 0.05),
            height: Constants.totalWidth(context) * 0.15,
            color: Colors.black,
            notchMargin: 6,
            shape: const CircularNotchedRectangle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildTabItem(index: 0, icon: Icons.dashboard_outlined),
                buildTabItem(index: 1, icon: Icons.vpn_key_outlined),
                 SizedBox(width: Constants.totalWidth(context)*0.05),
                buildTabItem(index: 2, icon: Icons.settings_outlined),
                buildTabItem(index: 3, icon: Icons.info_outline),
              ],
            ),
          ),
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
}
