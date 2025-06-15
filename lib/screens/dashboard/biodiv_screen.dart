import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/widgets/theme_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/fonts.dart';
import '../../models/forests_model.dart';
import '../../ref/instance_provider.dart';
import '../../ref/values_provider.dart';
import '../../utils/connection/ssh.dart';

class BiodivScreen extends ConsumerStatefulWidget {
  const BiodivScreen({super.key});

  @override
  ConsumerState<BiodivScreen> createState() => _BiodivScreenState();
}

class _BiodivScreenState extends ConsumerState<BiodivScreen> {

  late Ssh ssh;
  late Forest forest;

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
                  onTap: (){},
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
