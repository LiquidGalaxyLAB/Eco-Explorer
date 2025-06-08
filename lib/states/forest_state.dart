
import '../models/forests_model.dart';

sealed class ForestState{}

final class ForestLoading extends ForestState{}

final class ForestSuccess extends ForestState{
  final ForestsModel allForests;
  final ForestsModel visibleForests;

  ForestSuccess({required this.allForests, required this.visibleForests,});
}