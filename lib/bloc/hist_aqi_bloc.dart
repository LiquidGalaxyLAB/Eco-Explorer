import 'package:eco_explorer/events/hist_aqi_event.dart';
import 'package:eco_explorer/models/historical_aqi/hist_aqi_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/aqi_repository.dart';
import '../states/api_state.dart';

class HistAqiBloc extends Bloc<HistAqiEvent, ApiState>{
  final AqiRepository<HistAqiModel> aqiRepository;
  HistAqiBloc(this.aqiRepository) : super(ApiInitial()){
    on<HistAqiFetched>((event,emit) async{
      emit(ApiLoading());
      try{
        final weather = await aqiRepository.getPollutionData(event.lat, event.lon);
        emit(ApiSuccess<HistAqiModel>(model: weather));
      }catch(e){
        emit(ApiFailure(error: e.toString()));
      }
    });
  }
}