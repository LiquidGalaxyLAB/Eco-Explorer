import 'dart:io';

import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/widgets/theme_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/fonts.dart';
import '../../models/forests_model.dart';
import '../../ref/instance_provider.dart';
import '../../ref/values_provider.dart';
import '../../utils/connection/ssh.dart';
import '../../utils/kml/balloon_entity.dart';
import '../../widgets/snackbar.dart';
import '../../widgets/theme_dialog_box.dart';

class BiodivScreen extends ConsumerStatefulWidget {
  const BiodivScreen({super.key});

  @override
  ConsumerState<BiodivScreen> createState() => _BiodivScreenState();
}

class _BiodivScreenState extends ConsumerState<BiodivScreen> {

  late Ssh ssh;
  late Forest forest;
  BuildContext? innerContext;

  @override
  void initState() {
    super.initState();
    forest = ref.read(forestProvider.notifier).state!;
    ssh = ref.read(sshProvider);
  }

  @override
  Widget build(BuildContext context) {

    double imgSize = Constants.totalHeight(context)*0.1;

    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Click on each card to visualize on the rig.',
            style: Fonts.medium.copyWith(fontSize: Constants.totalWidth(context)*0.03,color: Themes.cardText),
            textHeightBehavior: const TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
          ),
          SizedBox(height: Constants.cardMargin(context),),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: Constants.totalHeight(context)*0.6,
            ),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              mainAxisSpacing: Constants.cardMargin(context),
              crossAxisSpacing: Constants.cardMargin(context),
              children: forest.biodiv.map((species){
                return GestureDetector(
                  onTap: () async{
                    if (ref.watch(isDownloadedProvider) == true) {
                      final filename = '${species.img_link}.kmz';
                      final localPath = await getApplicationDocumentsDirectory();

                      final file = File('$localPath/3D_models/${forest.path}/$filename');

                      print("File created");
                      await ssh.kmlFileUpload(file,filename);
                      print("Uploaded");
                      await ssh.sendKml(context, filename);
                      await ssh.sendKmltoSlave(context, BalloonEntity.speciesBalloon(species, forest, Constants.speciesImage(forest.path, species.img_link), Constants.defaultScale, 0, 0), Constants.rightRig(ssh.rigCount()));
                      print("Kml sent ");
                      await ssh.flyToWithoutSaving(context, ref, forest.lat-0.001, forest.lon, Constants.biodivAltitude, Constants.defaultScale, 30, 0);

                    }
                    else{
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.grey[900],
                            title: Text('Data not downloaded', style: TextStyle(color: Colors.white)),
                            content: Text('Do you want to download all the 3D models (73 MB)?',
                                style: TextStyle(color: Colors.white)),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();

                                  Future.microtask(() async {
                                    try {
                                      print('Download started');
                                      // await DataDownloader().downloadData(ref, context);

                                      if (innerContext != null && Navigator.of(innerContext!).canPop()) {
                                        ref.read(isDownloadedProvider.notifier).state = true;
                                        showSnackBar(context, 'Downloaded Successfully', Colors.green);
                                        Navigator.of(innerContext!).pop();
                                      }
                                    } catch (e) {
                                      print(e.toString());
                                      if (innerContext != null && Navigator.of(innerContext!).canPop()) {
                                        showSnackBar(innerContext!, e.toString(), Themes.error);
                                        Navigator.of(innerContext!).pop();
                                      } else if (Navigator.of(context).canPop()) {
                                        showSnackBar(context, 'Failed to Download', Themes.error);
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  });

                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (ctx) {
                                      innerContext = ctx;
                                      return Dialog(
                                        child: ThemeDialogBox(
                                          child: StatefulBuilder(
                                            builder: (context, setModalState) {
                                              return SingleChildScrollView(
                                                child: Center(
                                                  child: Column(
                                                    children: [
                                                      CircularProgressIndicator(
                                                        color: Themes.cardText,
                                                        value: ref.watch(downloadingProvider),
                                                      ),
                                                      SizedBox(height: 0.5 * Constants.cardMargin(context)),
                                                      Text(
                                                        ref.watch(downloadingTextProvider),
                                                        style: Fonts.medium.copyWith(
                                                          fontSize: Constants.totalHeight(context) * 0.015,
                                                          color: Themes.cardText,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text('Yes', style: TextStyle(color: Colors.white)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Just close the alert
                                },
                                child: Text('No', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: ThemeCard(
                      width: 0,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: imgSize),
                                child: Image.asset('${Constants.biodiv}/${forest.path}/${species.img_link}.png',)
                            ),
                            SizedBox(height: 0.3*Constants.cardMargin(context),),
                            Text(
                              species.sci_name,style: Fonts.semiBold.copyWith(color: Themes.cardText,
                                fontSize: Constants.totalHeight(context)*0.018),textAlign: TextAlign.center,
                            )
                          ]
                      )
                  ),
                );
              }).toList(),
            ),
          ),
        ]
    );
  }
}
