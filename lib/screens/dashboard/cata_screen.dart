
import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/models/fire/fire_model.dart';
import 'package:eco_explorer/ref/values_provider.dart';
import 'package:eco_explorer/utils/kml/balloon_entity.dart';
import 'package:eco_explorer/utils/kml/kml_entity.dart';
import 'package:eco_explorer/widgets/custom_page_route.dart';
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

    String filename = '${forest.name}_fires';

    return Column(
      children: [
        ThemeCard(
          onTap: () {
            final outerContext = context;
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
