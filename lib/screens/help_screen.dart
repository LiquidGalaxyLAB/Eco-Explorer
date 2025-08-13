import 'package:eco_explorer/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/fonts.dart';
import '../constants/strings.dart';
import '../widgets/theme_card.dart';

class HelpScreen extends StatefulWidget {
  final OverlayEntry? entry;
  const HelpScreen({super.key, this.entry});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> desc = [Constants.groqDesc,Constants.deepgramDesc,Constants.openWeatherDesc,Constants.firmsDesc];
    List<String> subtitles = [Constants.subtitle1,Constants.subtitle2,Constants.subtitle3,Constants.subtitle4,];
    List<List<Widget>> row = [[
      Hyperlink(text: Constants.hyperlink1, url: 'https://console.groq.com/docs/overview'),
      SizedBox(width: 0.025*Constants.totalWidth(context),),
      Hyperlink(text: Constants.hyperlink2, url: 'https://console.groq.com/keys')
    ],
      [
        Hyperlink(text: Constants.hyperlink3, url: 'https://developers.deepgram.com/home'),
        SizedBox(width: 0.025*Constants.totalWidth(context),),
        Hyperlink(text: Constants.hyperlink4, url: 'https://console.deepgram.com/')
      ],
      [
        Hyperlink(text: Constants.hyperlink5, url: 'https://openweathermap.org/api/air-pollution'),
        SizedBox(width: 0.025*Constants.totalWidth(context),),
        Hyperlink(text: Constants.hyperlink6, url: 'https://docs.openweather.co.uk/our-initiatives/student-initiative')
      ],
      [
        Hyperlink(text: Constants.hyperlink7, url: 'https://firms.modaps.eosdis.nasa.gov/api/map_key/'),
      ]
    ];

    return Scaffold(
      backgroundColor: Themes.bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Themes.bg,
        title: Text(
          'Help Screen',
          style: Fonts.extraBold.copyWith(
            fontSize: Constants.totalWidth(context) * 0.05,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            if(widget.entry != null){
              widget.entry?.remove();
            }
            else {
              Navigator.pop(context);
            }
            },
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Constants.cardPadding(context)),
          child: Column(
            children: [
              ThemeCard(
                  width: Constants.totalWidth(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Constants.title1,style: Fonts.semiBold.copyWith(fontSize: Constants.totalHeight(context)*0.0275,color: Themes.cardText),),
                      SizedBox(height: 0.5*Constants.cardMargin(context),),
                      for(int i=0;i<desc.length;i++)...[
                        Text(subtitles[i],style: Fonts.medium.copyWith(fontSize: Constants.totalHeight(context)*0.02,color: Themes.cardText),),
                        Row(
                          children: row[i],
                        ),
                        Text(desc[i],style: Fonts.regular.copyWith(fontSize: Constants.totalHeight(context)*0.015,color: Themes.cardText),),
                        SizedBox(height: 0.5*Constants.cardMargin(context),),
                      ]
                    ],
                  )
              ),
              SizedBox(height: Constants.cardMargin(context),),
              ThemeCard(
                  width: Constants.totalWidth(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Constants.title2,style: Fonts.semiBold.copyWith(fontSize: Constants.totalHeight(context)*0.0275,color: Themes.cardText),),
                      SizedBox(height: Constants.cardMargin(context),),
                      Image.asset('assets/home/help/rig.png',width: Constants.totalWidth(context),),
                      SizedBox(height: 0.5*Constants.cardMargin(context),),
                      Row(
                        children: [
                          Icon(Icons.mic_none, color: Themes.cardText,),
                          SizedBox(width: 0.025*Constants.totalWidth(context),),
                          Icon(Icons.mic_off_outlined, color: Themes.cardText,),
                          SizedBox(width: 0.025*Constants.totalWidth(context),),
                          Text(Constants.voice,style: Fonts.regular.copyWith(fontSize: Constants.totalHeight(context)*0.0125,color: Themes.cardText),),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.play_arrow_outlined, color: Themes.cardText,),
                          SizedBox(width: 0.025*Constants.totalWidth(context),),
                          Icon(Icons.stop, color: Themes.cardText,),
                          SizedBox(width: 0.025*Constants.totalWidth(context),),
                          Text(Constants.orbit,style: Fonts.regular.copyWith(fontSize: Constants.totalHeight(context)*0.0125,color: Themes.cardText),),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.zoom_in, color: Themes.cardText,),
                          SizedBox(width: 0.025*Constants.totalWidth(context),),
                          Icon(Icons.zoom_out, color: Themes.cardText,),
                          SizedBox(width: 0.025*Constants.totalWidth(context),),
                          Text(Constants.zoom,style: Fonts.regular.copyWith(fontSize: Constants.totalHeight(context)*0.0125,color: Themes.cardText),),
                        ],
                      ),
                      SizedBox(height: 0.25*Constants.cardMargin(context),),
                      Text(Constants.subtitle5,style: Fonts.medium.copyWith(fontSize: Constants.totalHeight(context)*0.02,color: Themes.cardText),),
                      SizedBox(height: 0.25*Constants.cardMargin(context),),
                      Text(Constants.commands,style: Fonts.regular.copyWith(fontSize: Constants.totalHeight(context)*0.015,color: Themes.cardText),),
                    ],
                  )
              ),
              SizedBox(height: Constants.cardMargin(context),),
              ThemeCard(
                  width: Constants.totalWidth(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Constants.title3,style: Fonts.semiBold.copyWith(fontSize: Constants.totalHeight(context)*0.0275,color: Themes.cardText),),
                      SizedBox(height: Constants.cardMargin(context),),
                      Text(Constants.subtitle6,style: Fonts.medium.copyWith(fontSize: Constants.totalHeight(context)*0.02,color: Themes.cardText),),
                      SizedBox(height: 0.25*Constants.cardMargin(context),),
                      Text(Constants.appCommands,style: Fonts.regular.copyWith(fontSize: Constants.totalHeight(context)*0.015,color: Themes.cardText),),
                      SizedBox(height: 0.5*Constants.cardMargin(context),),
                      Text(Constants.subtitle7,style: Fonts.medium.copyWith(fontSize: Constants.totalHeight(context)*0.02,color: Themes.cardText),),
                      SizedBox(height: 0.25*Constants.cardMargin(context),),
                      Text(Constants.dashboardCommands,style: Fonts.regular.copyWith(fontSize: Constants.totalHeight(context)*0.015,color: Themes.cardText),),
                      SizedBox(height: 0.5*Constants.cardMargin(context),),
                      Text(Constants.subtitle8,style: Fonts.medium.copyWith(fontSize: Constants.totalHeight(context)*0.02,color: Themes.cardText),),
                      SizedBox(height: 0.25*Constants.cardMargin(context),),
                      Text(Constants.commonCommands,style: Fonts.regular.copyWith(fontSize: Constants.totalHeight(context)*0.015,color: Themes.cardText),),
                    ],
                  )
              ),
              SizedBox(height: Constants.bottomGap(context),),
            ],
          ),
        ),
      ),
    );
  }
}

class Hyperlink extends StatelessWidget {
  final String text;
  final String url;
  const Hyperlink({super.key, required this.text, required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Text(text,
          style: Fonts.regular.copyWith(fontSize: Constants.totalHeight(context)*0.015,color: Themes.hyperlink,
              decoration: TextDecoration.underline,decorationColor: Themes.hyperlink
          ),
        ),
        onTap: () => launchUrlFromLink(Uri.parse(url))
    );
  }

  Future<void> launchUrlFromLink(Uri url) async {
    print("reached here $url");
    try {
      if (!await launchUrl(url)) {
      }
    } catch (e) {
      print("$url:  $e");
    }
  }
}
