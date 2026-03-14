import 'package:btg_funds_web/core/network/dio_client.dart';
import 'package:btg_funds_web/core/network/mock_api.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

Future<void> initNetworkModule(GetIt sl) async {
  final dioClient = DioClient();

  await MockApi.setup(dioClient.dio);

  sl.registerLazySingleton<Dio>(() => dioClient.dio);
}
