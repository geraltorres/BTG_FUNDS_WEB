import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'exceptions.dart';

class AppExceptionGuard {
  AppExceptionGuard._();

  static Future<T> guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException {
      throw ServerException();
    } on PlatformException {
      /// error load assets
      throw CacheException();
    } on FormatException {
      /// JSON bad format
      throw CacheException();
    } catch (_) {
      throw ServerException();
    }
  }
}
