import 'package:eco_explorer/models/fire/fire_model.dart';
import 'package:eco_explorer/repositories/fire_repository.dart';
import 'package:eco_explorer/states/api_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../events/fire_event.dart';

class FireBloc extends Bloc<FireEvent, ApiState>{
  final FireRepository fireRepository;
  FireBloc(this.fireRepository) : super(ApiInitial()){
    on<FirmsApiFetched>((event, emit) async{
      emit(ApiLoading());
      try {
        FireModel fireModel = FireModel(fires: []);
        for (String country in forestToCountry[event.forest]!) {
          // print('Fetching fire data for $country...');
          final model = await fireRepository.getFireData(country, event.range);
          fireModel.fires.addAll(model.fires);
        }
        emit(ApiSuccess<FireModel>(model: fireModel));
      } catch (e, stack) {
        print('BLoC issue: $e');
        print(stack); 
        emit(ApiFailure(error: e.toString()));
      }

    });
  }
}

Map<String, List<String>> forestToCountry = {
  'Amazon Rainforest': ['BRA', 'PER', 'COL', 'VEN', 'ECU', 'BOL', 'GUY', 'SUR', 'GUF'],
  'Congolian Rainforest': ['COD', 'COG', 'CAF', 'CMR', 'GAB', 'GNQ'],
  'New Guinea Rainforest': ['IDN', 'PNG'],
  'East Siberian Taiga': ['RUS'],
  'The Sundarbans': ['BGD', 'IND'],
  'Appalachian Rainforest': ['USA'],
  'Valdivian Temperate Forest': ['CHL', 'ARG'],
  'Daintree Rainforest': ['AUS'],
};
