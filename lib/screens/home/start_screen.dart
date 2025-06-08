import 'package:eco_explorer/events/forest_event.dart';
import 'package:eco_explorer/models/forests_model.dart';
import 'package:eco_explorer/widgets/forest_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/forest_bloc.dart';
import '../../constants/fonts.dart';
import '../../constants/strings.dart';
import '../../constants/theme.dart';
import '../../states/forest_state.dart';
import '../../utils/connection/ssh.dart';

class StartScreen extends StatefulWidget {
  final Ssh ssh;
  const StartScreen({super.key, required this.ssh});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ForestBloc>().add(ForestFetched());
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
  Widget build(BuildContext context) {
    return BlocBuilder<ForestBloc, ForestState>(
        builder: (context,state){
          if(state is ForestLoading){
            return Center(child: CircularProgressIndicator(color: Themes.cardText),);
          }
          if(state is ForestSuccess){
            List<Forest> forests = state.visibleForests.forests;

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
                    final bloc = context.read<ForestBloc>();
                    if (query.isEmpty) {
                      bloc.add(ForestFetched());
                    } else {
                      bloc.add(ForestSearchQueryChanged(query));
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
                            forest: forests[i], ssh: widget.ssh,
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
        }
    );
  }
}
