import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/widgets/primary_button.dart';
import 'package:eco_explorer/widgets/text_box.dart';
import 'package:eco_explorer/widgets/theme_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/snackbar.dart';

class ApiAuthScreen extends StatefulWidget {
  const ApiAuthScreen({super.key});

  @override
  State<ApiAuthScreen> createState() => _ApiAuthScreenState();
}

class _ApiAuthScreenState extends State<ApiAuthScreen> {
  final TextEditingController _groqController = TextEditingController();
  final TextEditingController _deepgramController = TextEditingController();
  final TextEditingController _nasaFirmsController = TextEditingController();
  final TextEditingController _openWeatherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _groqController.dispose();
    _deepgramController.dispose();
    _nasaFirmsController.dispose();
    _openWeatherController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _groqController.text = prefs.getString('groqApiKey') ?? '';
      _deepgramController.text = prefs.getString('deepgramApiKey') ?? '';
      _nasaFirmsController.text = prefs.getString('nasaFirmsApiKey') ?? '';
      _openWeatherController.text = prefs.getString('openWeatherApiKey') ?? '';
    });
  }

  Future<void> _saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_groqController.text.isNotEmpty) {
      await prefs.setString('groqApiKey', _groqController.text);
    }
    if (_deepgramController.text.isNotEmpty) {
      await prefs.setString('deepgramApiKey', _deepgramController.text);
    }
    if (_nasaFirmsController.text.isNotEmpty) {
      await prefs.setString('nasaFirmsApiKey', _nasaFirmsController.text);
    }
    if (_openWeatherController.text.isNotEmpty) {
      await prefs.setString('openWeatherApiKey', _openWeatherController.text);
    }

    print(prefs.getString('groqApiKey'));
    print(prefs.getString('deepgramApiKey'));
    print(prefs.getString('nasaFirmsApiKey'));
    print(prefs.getString('openWeatherApiKey'));

    showSnackBar(context, 'Settings saved', Colors.grey[800]!);
  }
  @override
  Widget build(BuildContext context) {
    String hint = 'Enter your key here';

    List<String> labels = ['Groq API Key','Deepgram API Key','NASA FIRMS API Key','Open Weather API Key'];
    List<TextEditingController> controllers = [_groqController,_deepgramController,_nasaFirmsController,_openWeatherController];

    return SingleChildScrollView(
      child: Column(
        children: [
          ThemeCard(
              width: Constants.totalWidth(context),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  for (int i = 0; i < labels.length; i++) ...[
                    Text(labels[i],
                      style: Fonts.bold.copyWith(fontSize: Constants.totalHeight(context)*0.025,color: Themes.cardText,
                          decoration: TextDecoration.underline,decorationColor: Themes.cardText
                      ),
                    ),
                    SizedBox(height: 0.75*Constants.cardMargin(context),),
                    TextInputField(label: labels[i], hint: hint, controller: controllers[i], i: 2,),
                    SizedBox(height: 1.5*Constants.cardMargin(context),),
                  ],
                  PrimaryButton(label: 'UPDATE', onPressed: ()=>_saveSettings())
                ],
              )
          ),
          SizedBox(height: Constants.bottomGap(context),)
        ],
      ),
    );
  }
}

