import 'package:flutter/cupertino.dart';

@immutable
sealed class ApiState{}

final class ApiInitial extends ApiState{}

final class ApiSuccess<T> extends ApiState{
  final T model;

  ApiSuccess({required this.model});
}

final class ApiFailure extends ApiState{
  final String error;
  ApiFailure({required this.error});
}

final class ApiLoading extends ApiState{}