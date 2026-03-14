import '../errors/failures.dart';

class FailureMapper {
  FailureMapper._(); // constructor privado

  static String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure _:
        return "No internet connection";

      case ServerFailure _:
        return "Server error";

      case CacheFailure _:
        return "Cache error";

      default:
        return "Unexpected error occurred";
    }
  }
}
