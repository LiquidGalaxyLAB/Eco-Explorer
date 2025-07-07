
import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/models/fire/fire_model.dart';
import 'package:eco_explorer/ref/values_provider.dart';
import 'package:eco_explorer/utils/kml/balloon_entity.dart';
import 'package:eco_explorer/utils/kml/kml_entity.dart';
import 'package:eco_explorer/screens/map_view.dart';
import 'package:eco_explorer/widgets/primary_button.dart';
import 'package:eco_explorer/widgets/snackbar.dart';
import 'package:eco_explorer/widgets/theme_card.dart';
import 'package:eco_explorer/widgets/theme_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/forests_model.dart';
import '../../ref/api_provider.dart';
import '../../ref/instance_provider.dart';
import '../../states/api_state.dart';
import '../../utils/connection/ssh.dart';
import '../../widgets/timelapse.dart';
import '../map_view.dart';
import '../../widgets/error_dialog_box.dart';
import '../../widgets/error_dialog_box.dart';

class CataScreen extends ConsumerStatefulWidget {
  const CataScreen({super.key});

  @override
  ConsumerState<CataScreen> createState() => _CataScreenState();
}

class _CataScreenState extends ConsumerState<CataScreen> {
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
    int range = 1;
    bool isLoading = false;

    String filename = '${forest.name}_fires.kml';

    return Column(
      children: [
        ThemeCard(
          onTap: () {
            final outerContext = context;
            showDialog(
              context: outerContext,
              builder: (context) {
                return Dialog(
                  child: Consumer(
                      builder: (context,ref,_) {
                        return ThemeDialogBox(
                          child: StatefulBuilder(
                            builder: (context, setModalState) {
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 0.05 * Constants.totalWidth(context)),
                                  child: Column(
                                    children: [
                                      Text('SHOW FOREST FIRES', style: Fonts.bold.copyWith(fontSize: Constants.totalHeight(context) * 0.025, color: Themes.cardText)),
                                      SizedBox(height: 0.5 * Constants.cardMargin(context)),
                                      DropdownButton(
                                        value: range,
                                        dropdownColor: Themes.bg,
                                        icon: Icon(Icons.arrow_drop_down_outlined, color: Themes.cardText),
                                        items: [
                                          DropdownMenuItem(value: 1, child: Text('Last 24 Hrs', style: Fonts.semiBold.copyWith(fontSize: Constants.totalWidth(context) * 0.05, color: Themes.cardText))),
                                          DropdownMenuItem(value: 2, child: Text('Last 48 Hrs', style: Fonts.semiBold.copyWith(fontSize: Constants.totalWidth(context) * 0.05, color: Themes.cardText))),
                                          DropdownMenuItem(value: 7, child: Text('Last 1 Week', style: Fonts.semiBold.copyWith(fontSize: Constants.totalWidth(context) * 0.05, color: Themes.cardText))),
                                        ],
                                        onChanged: (v) => setModalState(() => range = v!),
                                      ),
                                      SizedBox(height: Constants.cardMargin(context)),
                                      isLoading
                                          ? Center(child: CircularProgressIndicator(color: Themes.cardText))
                                          : PrimaryButton(
                                          label: 'VISUALIZE',
                                          onPressed: () async {
                                            setModalState(() => isLoading = true);

                                            await ref.read(fireNotifierProvider.notifier).fetchActiveFires(ref, forest.name, range);
                                            final fireState = ref.watch(fireNotifierProvider);
                                            fireState.when(
                                              data: (state) async{
                                                if (state is ApiSuccess<FireModel>) {
                                                  try{
                                                    final data = state.model;
                                                    List<FireInfo> fires = data.fires;

                                                    final forestFires = fires.where((fire) =>
                                                    fire.lat >= forest.min_lat &&
                                                        fire.lat <= forest.max_lat &&
                                                        fire.lon >= forest.min_lon &&
                                                        fire.lon <= forest.max_lon
                                                    ).toList();

                                                    if(forestFires.isEmpty){
                                                      showSnackBar(context, 'No fires found in this area', Themes.error);
                                                    }else{
                                                      showSnackBar(
                                                          context, 'Visualizing..', Colors.green);

                                                      final file = await ssh.makeFile(filename, KmlEntity.getFireKml(forestFires));

                                                      await ssh.kmlFileUpload(file!, filename);
                                                      await ssh.sendKml(context, filename);
                                                      await ssh.sendKmltoSlave(context, BalloonEntity.fireBalloon(forest, forestFires, Constants.fireImage, Constants.defaultScale, 0, 0), Constants.rightRig(ssh.rigCount()));

                                                    }
                                                    await ssh.flyToWithoutSaving(context, ref, forest.lat, forest.lon, Constants.forestAltitude, Constants.defaultScale, 0, 0);

                                                    setState(() => isLoading = false);
                                                    Navigator.pop(context);
                                                    Navigator.push(context, MaterialPageRoute(builder: (_)=>MapView(lat: forest.lat, lon: forest.lon, fires: forestFires)));
                                                  }catch(e){
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    showDialog(
                                                        context: outerContext,
                                                        builder: (context)=>ErrorDialogBox(error: e.toString(),)
                                                    );
                                                  }
                                                }

                                                if (state is ApiFailure) {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                  showDialog(
                                                      context: outerContext,
                                                      builder: (context)=>ErrorDialogBox(error: state.error.toString(),)
                                                  );
                                                  // showSnackBar(context, 'Failed to fetch fires',
                                                  //     Themes.error);
                                                }
                                              },
                                              loading: () => Center(child: CircularProgressIndicator()),
                                              error: (err, _) {
                                                Navigator.pop(context);
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                // showSnackBar(context, 'Failed to fetch fires',Themes.error);
                                                showDialog(
                                                    context: context,
                                                    builder: (context)=>ErrorDialogBox(error: err.toString(),)
                                                );
                                              },
                                            );
                                          }
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                  ),
                );
              },
            ).then((_){
              if(isLoading){
                setState(() {
                  isLoading = false;
                });
              }
            });
          },
          width: Constants.totalWidth(context),
          child: Column(
            children: [
              Image.asset(Constants.fire, height: 0.175 * Constants.totalHeight(context)),
              SizedBox(height: 0.5 * Constants.cardMargin(context)),
              Text('Recent Forest Fires', style: Fonts.semiBold.copyWith(fontSize: Constants.totalHeight(context) * 0.0275, color: Themes.cardText)),
            ],
          ),
        ),
        SizedBox(height: Constants.cardMargin(context),),
        ThemeCard(
            onTap: (){
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      // backgroundColor: Colors.transparent,
                      child: ThemeDialogBox(
                          child: StatefulBuilder(
                              builder: (context, setModalState) {
                                return SingleChildScrollView(
                                  child: Timelapse(forest: forest),
                                );
                              }
                          )
                      ),
                    );
                  }
              );
            },
            width: Constants.totalWidth(context),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(0.02*Constants.totalHeight(context)),
                  child: Image.asset(Constants.leaf,height: 0.15*Constants.totalHeight(context)),
                ),
                SizedBox(height: 0.8*Constants.cardMargin(context),),
                Text('Deforestation Timelapse', style: Fonts.semiBold.copyWith(fontSize: Constants.totalHeight(context)*0.0275,color: Themes.cardText),),
              ],
            )
        ),
      ],
    );
  }


}
