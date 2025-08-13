import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/models/forests_model.dart';
import 'package:eco_explorer/screens/tour_viewer.dart';
import 'package:eco_explorer/models/tour_model.dart';
import 'package:eco_explorer/widgets/secondary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/strings.dart';
import '../../providers/groq_tour_provider.dart';
import '../../ref/instance_provider.dart';
import '../../ref/values_provider.dart';
import '../../utils/connection/ssh.dart';
import '../../widgets/error_dialog_box.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/snackbar.dart';
import '../../widgets/theme_card.dart';
import '../../widgets/theme_dialog_box.dart';

class InfoScreen extends ConsumerStatefulWidget {
  const InfoScreen({super.key});

  @override
  ConsumerState<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends ConsumerState<InfoScreen> {
  String mode = 'Story';
  bool light = false;
  double value = 0;
  String loadingText = 'Beware of AI hallucinations';

  OverlayEntry? entry;
  late Ssh ssh;
  late Forest forest;

  @override
  void initState() {
    super.initState();
    ssh = ref.read(sshProvider);
    forest = ref.read(forestProvider.notifier).state!;
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;

    return Column(
      children: [
        ThemeCard(
          width: Constants.totalWidth(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Area',style: Fonts.semiBold.copyWith(fontSize: Constants.totalHeight(context)*0.0275,color: Themes.cardText),),
              Text('${forest.area} km.sq.',style: Fonts.regular.copyWith(fontSize: Constants.totalHeight(context)*0.027,color: Themes.cardText),),
            ],
          ),
        ),
        SizedBox(height: Constants.cardMargin(context),),
        ThemeCard(
          width: Constants.totalWidth(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ecosystem',style: Fonts.semiBold.copyWith(fontSize: Constants.totalHeight(context)*0.0275,color: Themes.cardText),),
              Text(forest.ecosystem,style: Fonts.regular.copyWith(fontSize: Constants.totalHeight(context)*0.027,color: Themes.cardText),),
            ],
          ),
        ),
        SizedBox(height: Constants.cardMargin(context),),
        ThemeCard(
          width: Constants.totalWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('About',style: Fonts.semiBold.copyWith(fontSize: Constants.totalHeight(context)*0.0275,color: Themes.cardText),),
              SizedBox(height: 0.5*Constants.cardMargin(context),),
              Text(forest.desc,style: Fonts.regular.copyWith(fontSize: Constants.totalHeight(context)*0.015,color: Themes.cardText),),
            ],
          ),
        ),
        SizedBox(height: Constants.cardMargin(context),),
        SecondaryButton(
            label: 'Take a Tour',
            onTap: (){
              final outerContext = context;

              showDialog(context: outerContext,
                  builder: (context) {
                    return Dialog(
                      // backgroundColor: Colors.transparent,
                      child: ThemeDialogBox(
                          child: StatefulBuilder(
                              builder: (context, setModalState) {

                                return SingleChildScrollView(
                                  child: isLoading?
                                  Center(
                                    child: Column(
                                      children: [
                                        CircularProgressIndicator(
                                          color: Themes.cardText,
                                        value: value,
                                        ),
                                        SizedBox(height: 0.5*Constants.cardMargin(context),),
                                        Text(loadingText,style: Fonts.medium.copyWith(fontSize: Constants.totalHeight(context)*0.015,color: Themes.cardText),)
                                      ],
                                    ),)
                                      : Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ConstrainedBox(
                                              constraints: BoxConstraints(maxWidth: 0.4*Constants.totalWidth(context)),
                                              child: Text('Do you want a virtual Tour Guide?',
                                                style: Fonts.bold.copyWith(fontSize: Constants.totalHeight(context)*0.0175,color: Themes.cardText),
                                                maxLines: 2,),
                                            ),
                                            Switch(
                                              value: light,
                                              activeColor: Themes.cardText,
                                              inactiveThumbColor: Themes.cardText,
                                              inactiveTrackColor: Colors.transparent,
                                              onChanged: (bool value) {
                                                setModalState(() {
                                                  light = value;
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                        SizedBox(height: Constants.cardMargin(context),),
                                        DropdownButton(
                                            value: mode,
                                            dropdownColor: Themes.bg,
                                            icon: Icon(Icons.arrow_drop_down_outlined,color: Themes.cardText,),
                                            items: [
                                              DropdownMenuItem(
                                                  value: 'Story',
                                                  child: Text('Story Mode',
                                                      style: Fonts.semiBold.copyWith(fontSize: Constants.totalWidth(context)*0.05,color: Themes.cardText))
                                              ),
                                              DropdownMenuItem(
                                                  value: 'Educational',
                                                  child: Text('Education Mode',
                                                      style: Fonts.semiBold.copyWith(fontSize: Constants.totalWidth(context)*0.05,color: Themes.cardText))
                                              ),
                                            ],
                                            onChanged: (v){
                                              setModalState(() {
                                                mode = v!;
                                              });
                                            }
                                        ),
                                        SizedBox(height: Constants.cardMargin(context),),
                                        PrimaryButton(
                                            label: 'START',
                                            onPressed: () async{
                                              setModalState(() {
                                                isLoading = true;
                                              });
                                              await Future.delayed(Duration(milliseconds: 500));
                                              setModalState(() {
                                                value=0.33;
                                              });

                                              try{
                                                final GroqTourProvider provider = GroqTourProvider();

                                                final json = await provider.getTour(forest.name, mode,context);
                                                print(json);

                                                await Future.delayed(Duration(milliseconds: 500));
                                                setModalState(() {
                                                  loadingText = 'Generating Tour';
                                                  value=0.67;
                                                });
                                                await Future.delayed(Duration(milliseconds: 500));
                                                TourModel model = TourModel.fromJson(json!);
                                                setModalState(() {
                                                  loadingText = 'Taking you there';
                                                  value=1;
                                                });
                                                await Future.delayed(Duration(milliseconds: 500));
                                                setModalState(() {
                                                  isLoading = false;
                                                });
                                                Navigator.of(context).pop();

                                                showOverlay(model, forest.path);
                                                setModalState(() {
                                                  loadingText = 'Beware of AI hallucinations';
                                                  value=0;
                                                });
                                              }catch(e){
                                                setModalState(() {
                                                  isLoading = false;
                                                });
                                                Navigator.of(context).pop();
                                                showDialog(
                                                    context: outerContext,
                                                    builder: (context)=>ErrorDialogBox(error: e.toString(),)
                                                );
                                              }
                                            }
                                        )
                                      ]
                                  ),
                                );
                              }
                          )
                      ),
                    );
                  }
              );
              //on tapping start
            },
            icon: CupertinoIcons.airplane
        ),
      ],
    );
  }

  void showOverlay(TourModel model, String name){
    entry = OverlayEntry(
        builder: (context) =>
            ProviderScope(
                overrides: [
                  isOrbitPlayingProvider.overrideWith((ref) => false),
                ],
                child: TourViewer(model: model, entry: entry, voiceGuide:light, name: name,)
            )
    );
    final overlay = Overlay.of(context);
    overlay.insert(entry!);
  }
}
