import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message = "Unexpected error";

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout";
        break;

      case DioExceptionType.receiveTimeout:
        message = "Server took too long to respond";
        break;

      case DioExceptionType.badResponse:
        message = "Server error: ${err.response?.statusCode}";
        break;

      case DioExceptionType.connectionError:
        message = "No internet connection";
        break;

      default:
        message = err.message ?? message;
    }

    handler.reject(
      DioException(requestOptions: err.requestOptions, error: message),
    );
  }
}
