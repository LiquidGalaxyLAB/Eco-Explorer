import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/widgets/primary_button.dart';
import 'package:eco_explorer/widgets/text_box.dart';
import 'package:eco_explorer/widgets/theme_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/connection/ssh.dart';

class Preferences extends StatefulWidget {
  final Ssh ssh;
  const Preferences({super.key, required this.ssh});

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> with TickerProviderStateMixin{

  late TabController _tabController;

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
        LgConnection(ssh: widget.ssh,), LgCommands(ssh: widget.ssh,)
      ],
    ),
          )
    ],
    );
  }
}

class LgConnection extends StatefulWidget {
  final Ssh ssh;
  const LgConnection({super.key, required this.ssh});

  @override
  State<LgConnection> createState() => _LgConnectionState();
}

class _LgConnectionState extends State<LgConnection> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _sshPortController = TextEditingController();
  final TextEditingController _rigsController = TextEditingController();

  late Ssh ssh;

  @override
  void initState() {
    super.initState();
    ssh = widget.ssh;
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
                    onTap: () {},
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
                    label: 'CONNECT TO LG',
                    onPressed: () async {
                      print('object');
                      await _saveSettings();
                      // if(context.mounted) {
                        await ssh.connectToLG(context);
                      // }
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
}

class LgCommands extends StatefulWidget {
  final Ssh ssh;
  const LgCommands({super.key, required this.ssh});

  @override
  State<LgCommands> createState() => _LgCommandsState();
}

class _LgCommandsState extends State<LgCommands> {

  late Ssh ssh;

  @override
  void initState() {
    super.initState();
    ssh = widget.ssh;
  }

  @override
  Widget build(BuildContext context) {
    List<String> commands = ['Set Slaves Refresh','Reset Slaves Refresh','Relaunch','Reboot','Clear KML + Logos','Power Off'];
    List<IconData> icons = [Icons.timer_outlined,Icons.timer_off_outlined,Icons.login_outlined,Icons.refresh,Icons.cleaning_services_sharp,Icons.power_settings_new];
    List<Future<void> Function()> functions = [
          () => ssh.setRefresh(context),
          () => ssh.resetRefresh(context),
          () => ssh.relaunchLG(context),
          () => ssh.rebootLG(context),
          () => ssh.clearKml(context),
          () => ssh.powerOff(context),
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
                  (i!=commands.length)?SizedBox(height: Constants.cardMargin(context),):SizedBox(),
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
