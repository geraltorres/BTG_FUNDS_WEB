import 'dart:convert';

import 'package:btg_funds_web/core/errors/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

class MockApi {
  static Future<void> setup(Dio dio) async {
    final adapter = DioAdapter(dio: dio);

    dio.httpClientAdapter = adapter;
    try {
      /// Load data from JSON
      final jsonString = await rootBundle.loadString('assets/mock/funds.json');

      final Map<String, dynamic> data = json.decode(jsonString);

      /// Endpoint mock
      adapter.onGet(
        "/funds",
        (server) =>
            server.reply(200, data, delay: const Duration(milliseconds: 700)),
      );
    } catch (e) {
      /// if the file doesn't exist or parse error
      throw CacheException();
    }
  }
}
