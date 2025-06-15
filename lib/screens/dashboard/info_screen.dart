import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/models/forests_model.dart';
import 'package:eco_explorer/widgets/secondary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/strings.dart';
import '../../ref/instance_provider.dart';
import '../../ref/values_provider.dart';
import '../../utils/connection/ssh.dart';
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
  bool light = true;
  double value = 0;
  String loadingText = 'Generating Tour';

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
              //on tapping start
            },
            icon: CupertinoIcons.airplane
        ),
      ],
    );
  }
}
