import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/screens/help_screen.dart';
import 'package:eco_explorer/widgets/connection_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../ref/instance_provider.dart';
import '../ref/values_provider.dart';
import '../utils/connection/ssh.dart';
import 'home/about_screen.dart';
import 'home/api_auth_screen.dart';
import 'home/preferences.dart';
import 'home/start_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin{
  late int index;
  late final List<Widget> pages;
  final title = ['Eco Explorer','API Authentication','Preferences','About'];

  late Ssh ssh;

  @override
  void initState() {
    super.initState();
    ssh = ref.read(sshProvider);
    pages = [StartScreen(),ApiAuthScreen(),Preferences(),AboutScreen()];
    _connectToLG();
  }

  Future<void> _connectToLG() async {
    await ssh.connectToLG(context);

    if(ssh.isConnected){
      await ssh.cleanBalloon(context);
      await ssh.clearKml(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    index = ref.watch(homeIndexProvider);

    return Scaffold(
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
              Navigator.push(context, MaterialPageRoute(builder: (_)=>HelpScreen()));
            },
            icon: const Icon(Icons.help_outline),
            color: Colors.white,
            focusColor: Themes.logoActive,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: Constants.cardPadding(context),right: Constants.cardPadding(context),bottom: Constants.cardPadding(context)),
        child: Column(
          children: [
            ConnectionBar(ref: ref,),
            SizedBox(height: Constants.cardPadding(context)),
            Expanded(
              child: pages[index],
            ),
            // SizedBox(height: Constants.bottomGap(context)),
          ],
        ),
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
              animate: true,
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
        onPressed: ()=> onChangedTab(ref, homeIndexProvider, index),
        tooltip: title[index],
        icon: Icon(icon, color: isSelected?Themes.logoActive:Themes.logoInactive,weight: 400,)
    );
  }
}
