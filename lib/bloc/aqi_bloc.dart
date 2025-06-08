import 'package:eco_explorer/models/aqi/aqi_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../events/aqi_event.dart';
import '../repositories/aqi_repository.dart';
import '../states/api_state.dart';

class AqiBloc extends Bloc<AqiEvent, ApiState>{
  final AqiRepository<AqiModel> aqiRepository;
  AqiBloc(this.aqiRepository) : super(ApiInitial()){
    on<AqiFetched>((event,emit) async{
      emit(ApiLoading());
      try{
        final weather = await aqiRepository.getPollutionData(event.lat, event.lon);
        emit(ApiSuccess<AqiModel>(model: weather));
      }catch(e){
        emit(ApiFailure(error: e.toString()));
      }
    });
  }
}