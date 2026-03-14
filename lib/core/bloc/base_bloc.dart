import 'package:btg_funds_web/core/bloc/base_state.dart';
import 'package:btg_funds_web/core/errors/failures.dart';
import 'package:btg_funds_web/core/utils/failure_mapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

abstract class BaseBloc<Event, State extends BaseState>
    extends Bloc<Event, State> {
  BaseBloc(super.initialState);

  Future<void> executeUseCase<T>(
    Future<Either<Failure, T>> Function() action,
    Emitter<State> emit,
    State Function() loading,
    State Function(String message) error,
    State Function(T data) success,
  ) async {
    emit(loading());

    final result = await action();

    result.fold(
      (failure) {
        emit(error(FailureMapper.mapFailureToMessage(failure)));
      },

      (data) {
        emit(success(data));
      },
    );
  }
}
