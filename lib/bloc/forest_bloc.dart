import 'package:eco_explorer/repositories/forest_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../events/forest_event.dart';
import '../models/forests_model.dart';
import '../states/forest_state.dart';

class ForestBloc extends Bloc<ForestEvent, ForestState>{
  final ForestRepository startRepository;
  ForestBloc(this.startRepository) : super(ForestLoading()) {
    on<ForestFetched>((event, emit) async {
      final forests = await startRepository.getForests();
      emit(ForestSuccess(allForests: forests, visibleForests: forests));
    });

    on<ForestSearchQueryChanged>((event, emit) async {
      if(state is ForestSuccess){
        final currentState = state as ForestSuccess;
        final filtered = currentState.allForests.forests.where((forest) {
          return forest.name.toLowerCase().contains(event.query.toLowerCase());
        }).toList();
        emit(ForestSuccess(
          allForests: currentState.allForests,
          visibleForests: ForestsModel(forests: filtered),
        ));
      }
    });
  }


}