import 'package:dio/dio.dart';
import 'dart:developer';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log("➡️ REQUEST");
    log("${options.method} ${options.uri}");
    log("Headers: ${options.headers}");
    log("Body: ${options.data}");

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("✅ RESPONSE");
    log("${response.requestOptions.uri}");
    log("Status: ${response.statusCode}");
    log("Data: ${response.data}");

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("❌ ERROR");
    log("${err.requestOptions.uri}");
    log(err.message ?? "Unknown error");

    super.onError(err, handler);
  }
}
