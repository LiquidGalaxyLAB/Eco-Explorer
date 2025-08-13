import 'package:eco_explorer/models/forests_model.dart';
import 'package:eco_explorer/ref/values_provider.dart';
import 'package:eco_explorer/widgets/forest_element.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/fonts.dart';
import '../../constants/strings.dart';
import '../../constants/theme.dart';
import '../../ref/api_provider.dart';
import '../../states/forest_state.dart';

class StartScreen extends ConsumerStatefulWidget {
  const StartScreen({super.key});

  @override
  ConsumerState<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends ConsumerState<StartScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(forestNotifierProvider.notifier).fetchForests();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context,) {
    final forestState = ref.watch(forestNotifierProvider);

    return forestState.when(
        data: (state){
          if(state is ForestLoading){
            return Center(child: CircularProgressIndicator(color: Themes.cardText),);
          }
          if(state is ForestSuccess){

            final forests = state.visibleForests.forests;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(forestListProvider.notifier).state = forests;
            });
            // final currentForests = ref.read(forestListProvider);

            // if (!listEquals(currentForests, forests)) {
            //   ref.read(forestListProvider.notifier).state = forests;
            // }

            return Column(
              children: [
                TextField(
                  controller: searchController,
                  style:  TextStyle(color: Themes.cardText),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Themes.textboxLabel),
                    hintText: 'Search',
                    hintStyle: Fonts.medium.copyWith(color: Themes.textboxHint),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Constants.cardRadius(context)),
                      borderSide: BorderSide(color: Themes.textboxOutline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Constants.cardRadius(context)),
                      borderSide: BorderSide(color: Themes.textboxOutline),
                    ),
                  ),
                  onChanged: (query) {
                    if (query.isEmpty) {
                      ref.read(forestNotifierProvider.notifier).fetchForests();
                    } else {
                      ref.read(forestNotifierProvider.notifier).searchForests(query);
                    }
                  },
                ),

                SizedBox(height: Constants.totalHeight(context) * 0.02),

                (forests.isNotEmpty)?Expanded(
                    child: ListView.builder(
                      itemCount: forests.length,
                      itemBuilder: (context, i) {
                        return Column(
                          children: [
                            ForestElement(
                              index: i,
                              forest: forests[i],
                            ),
                            SizedBox(
                              height:
                              // i == forests.length - 1 ? Constants.bottomGap(context) :
                              Constants.homeCardMargin(context),
                            ),
                          ],
                        );
                      },
                    )
                ):Center(child: Text('No data found', style: Fonts.bold.copyWith(fontSize: Constants.totalHeight(context) * 0.02,color: Themes.cardText),)),
              ],
            );
          }

          return Center();
        },
        error: (error,_)=> Center(child: Text(error.toString(), style: Fonts.bold.copyWith(fontSize: Constants.totalHeight(context) * 0.02,color: Themes.cardText),)),
        loading: ()=> Center(child: CircularProgressIndicator(color: Themes.cardText),)
    );
  }
}
