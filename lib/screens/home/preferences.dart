import 'dart:convert';
import 'dart:io';

import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/ref/values_provider.dart';
import 'package:eco_explorer/widgets/primary_button.dart';
import 'package:eco_explorer/widgets/snackbar.dart';
import 'package:eco_explorer/widgets/text_box.dart';
import 'package:eco_explorer/widgets/theme_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ref/instance_provider.dart';
import '../../utils/connection/ssh.dart';
import '../../utils/kml/kml_entity.dart';
import '../qr_code_scanner.dart';

class Preferences extends ConsumerStatefulWidget {
  const Preferences({super.key});

  @override
  ConsumerState<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends ConsumerState<Preferences> with TickerProviderStateMixin{

  late TabController _tabController;

  BuildContext? innerContext;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
                onTap: () async{

                },
                child: Container(
                  // width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: Constants.cardPadding(context), vertical: Constants.cardPadding(context)*0.5),
                  decoration: BoxDecoration(
                    color: Themes.secondaryButtonFill,
                    borderRadius: BorderRadius.all(Radius.circular(Constants.buttonRadius(context))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Download 3D Data', style: Fonts.semiBold.copyWith(color: Themes.secondaryButtonBg, fontSize: Constants.totalHeight(context)*0.015),),
                      SizedBox(width: Constants.totalWidth(context)*0.02,),
                      Icon(Icons.download,color: Themes.secondaryButtonBg,size: Constants.totalHeight(context)*0.02,)
                    ],
                  ),
                )
            ),
            GestureDetector(
                onTap: (){},
                child: Container(
                  // width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: Constants.cardPadding(context), vertical: Constants.cardPadding(context)*0.5),
                  decoration: BoxDecoration(
                    color: Themes.error,
                    borderRadius: BorderRadius.all(Radius.circular(Constants.buttonRadius(context))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Delete 3D Data', style: Fonts.semiBold.copyWith(color: Colors.white, fontSize: Constants.totalHeight(context)*0.015),),
                      SizedBox(width: Constants.totalWidth(context)*0.02,),
                      Icon(Icons.delete_forever,color: Colors.white,size: Constants.totalHeight(context)*0.02,)
                    ],
                  ),
                )
            ),
          ],
        ),
        SizedBox(height: Constants.cardMargin(context),),
        TabBar(
            controller: _tabController,
            labelStyle: Fonts.bold.copyWith(fontSize: Constants.totalWidth(context) * 0.04,color: Themes.cardText),
            indicatorColor: Themes.cardText,
            tabs: [
              Tab(text: "LG Connection"),
              Tab(text: "LG Commands")
            ]),
        SizedBox(height: Constants.cardMargin(context),),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              LgConnection(), LgCommands()
            ],
          ),
        )
      ],
    );
  }
}

class LgConnection extends ConsumerStatefulWidget {
  const LgConnection({super.key});

  @override
  ConsumerState<LgConnection> createState() => _LgConnectionState();
}

class _LgConnectionState extends ConsumerState<LgConnection> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _sshPortController = TextEditingController();
  final TextEditingController _rigsController = TextEditingController();

  late Ssh ssh;

  @override
  void initState() {
    super.initState();
    ssh = ref.read(sshProvider);
    _loadSettings();
  }

  @override
  void dispose() {
    _ipController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _sshPortController.dispose();
    _rigsController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _ipController.text = prefs.getString('ipAddress') ?? '';
      _usernameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _sshPortController.text = prefs.getString('sshPort') ?? '';
      _rigsController.text = prefs.getString('numberOfRigs') ?? '';
    });
  }

  Future<void> _saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_ipController.text.isNotEmpty) {
      await prefs.setString('ipAddress', _ipController.text);
    }
    if (_usernameController.text.isNotEmpty) {
      await prefs.setString('username', _usernameController.text);
    }
    if (_passwordController.text.isNotEmpty) {
      await prefs.setString('password', _passwordController.text);
    }
    if (_sshPortController.text.isNotEmpty) {
      await prefs.setString('sshPort', _sshPortController.text);
    }
    if (_rigsController.text.isNotEmpty) {
      await prefs.setString('numberOfRigs', _rigsController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> labels = ['IP Address','LG Username','LG Password','SSH Port','No. of Rigs'];
    List<String> hints = ['Enter Master IP','Enter your username','Enter your password','Enter the SSH Port','Enter the number of rigs'];
    List<TextEditingController> controllers = [_ipController,_usernameController,_passwordController,_sshPortController,_rigsController];
    List<IconData> icons = [Icons.computer,Icons.person,Icons.lock, Icons.settings_ethernet, Icons.memory, ];

    return SingleChildScrollView(
      child: Column(
        children: [
          ThemeCard(
            width: Constants.totalWidth(context),
            child: Column(
              children: [
                GestureDetector(
                    onTap: () async{
                      await qrCodeScanned();
                    },
                    child: Container(
                      padding: EdgeInsets.all(Constants.cardPadding(context)),
                      decoration: BoxDecoration(
                        color: Themes.primaryButtonBg,
                        borderRadius: BorderRadius.all(Radius.circular(Constants.buttonRadius(context))),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.qr_code_scanner,size: Constants.totalWidth(context) * 0.075,color: Themes.primaryButtonFill,),
                          SizedBox(width: Constants.totalWidth(context) * 0.025,),
                          Text('SCAN QR CODE TO CONNECT',
                            style: Fonts.bold.copyWith(color: Themes.primaryButtonFill, fontSize: Constants.totalWidth(context) * 0.0375,),)
                        ],
                      ),
                    )
                ),
                SizedBox(height: Constants.cardMargin(context),),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: Constants.totalWidth(context),
                      height: 1,
                      decoration: BoxDecoration(
                          color: Themes.primaryButtonBg
                      ),
                    ),
                    Container(
                        color: Themes.cardBg,
                        padding: EdgeInsets.symmetric(horizontal: Constants.cardPadding(context)),
                        child: Text('OR',style: Fonts.bold.copyWith(fontSize:  Constants.totalWidth(context) * 0.04,color: Themes.cardText),)
                    )
                  ],
                ),
                SizedBox(height: Constants.cardMargin(context),),
                Column(
                  children: [
                    for (int i = 0; i < labels.length; i++) ...[
                      TextInputField(
                        label: labels[i], hint: hints[i], controller: controllers[i], i: i, prefixIcon: icons[i],
                      ),
                      SizedBox(height: Constants.cardMargin(context),)
                    ]
                  ],
                ),
                SizedBox(height: Constants.cardMargin(context),),
                PrimaryButton(
                    label: !(ref.watch(sshProvider).connected)?'CONNECT TO LG':'DISCONNECT',
                    onPressed: () async {

                      if (!ref.watch(sshProvider).connected) {
                        await _saveSettings();
                        await connect();
                      } else {
                        await ssh.disconnect(context);
                      }
                    }
                ),
              ],
            ),
          ),
          SizedBox(height: Constants.bottomGap(context),)
        ],
      ),
    );
  }

  Future<void> qrCodeScanned() async {
    try {
      final result = await Navigator.push(context, MaterialPageRoute(builder: (context)=>QrCodeScanner()));
      print(result);

      if (result is Map) {
        final json = result['result'];
        print(json);
        Map jsonDecoded = jsonDecode(json);

        const requiredKeys = ['ip', 'username', 'port', 'password', 'screens'];

        for (final key in requiredKeys) {
          if (!jsonDecoded.containsKey(key)) {
            throw FormatException('Missing required key: $key');
          }
        }

        print(jsonDecoded['server'].toString());
        print(jsonDecoded['ip'].toString());
        print(jsonDecoded['username'].toString());
        print(jsonDecoded['port'].toString());
        print(jsonDecoded['password'].toString());
        print(jsonDecoded['screens'].toString());

        setState(() {
          _ipController.text = jsonDecoded['ip']!.toString();
          _usernameController.text = jsonDecoded['username']!.toString();
          _passwordController.text = jsonDecoded['password']!.toString();
          _sshPortController.text = jsonDecoded['port']!.toString();
          _rigsController.text = jsonDecoded['screens']!.toString();
        });

        await _saveSettings();
        await connect();

      }
    }catch (e) {
      showSnackBar(context, e.toString(), Themes.error);
    }
  }

  connect() async{
    await ssh.connectToLG(context);
    if(ref.read(sshProvider).connected){
      await ssh.cleanBalloon(context);
      await ssh.sendKmltoSlave(context,
          KmlEntity.screenOverlayImage(Constants.overlay, 500/554), Constants.leftRig(ssh.rigCount()));
    }
  }
}

class LgCommands extends ConsumerStatefulWidget {
  const LgCommands({super.key});

  @override
  ConsumerState<LgCommands> createState() => _LgCommandsState();
}

class _LgCommandsState extends ConsumerState<LgCommands> {

  late Ssh ssh;

  @override
  void initState() {
    super.initState();
    ssh = ref.read(sshProvider);
  }

  @override
  Widget build(BuildContext context) {
    List<String> commands = ['Set Slaves Refresh','Reset Slaves Refresh','Relaunch','Reboot','Clear KML + Logos','Power Off'];
    List<IconData> icons = [Icons.timer_outlined,Icons.timer_off_outlined,Icons.login_outlined,Icons.refresh,Icons.cleaning_services_sharp,Icons.power_settings_new];
    List<Future<void> Function()> functions = [
          () async => await ssh.setRefresh(context),
          () async => await ssh.resetRefresh(context),
          () async => await ssh.relaunchLG(context),
          () async => await ssh.rebootLG(context),
          () async {
        await ssh.cleanBalloon(context);
        await ssh.clearKml(context);
      },
          () async => await ssh.powerOff(context)
    ];
    return SingleChildScrollView(
      child: Column(
        children: [
          ThemeCard(
            width: Constants.totalWidth(context),
            child: Column(
              children: [
                for (int i = 0; i < commands.length; i++) ...[
                  GestureDetector(
                      onTap: () async {
                        print('Executing: ${commands[i]}');
                        await functions[i]();
                        print('Done');
                      },
                      child: Container(
                        padding: EdgeInsets.all(Constants.cardPadding(context)),
                        decoration: BoxDecoration(
                          color: Themes.primaryButtonBg,
                          borderRadius: BorderRadius.all(Radius.circular(Constants.buttonRadius(context))),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(commands[i],
                              style: Fonts.bold.copyWith(color: Themes.primaryButtonFill, fontSize: Constants.totalWidth(context) * 0.045),),
                            Icon(icons[i],size: Constants.totalWidth(context) * 0.075,color: Themes.primaryButtonFill,weight: 300,)
                          ],
                        ),
                      )
                  ),
                  (i!=commands.length-1)?SizedBox(height: Constants.cardMargin(context),):SizedBox(),
                ]
              ],
            ),
          ),
          SizedBox(height: Constants.bottomGap(context),)
        ],
      ),
    );
  }
}

