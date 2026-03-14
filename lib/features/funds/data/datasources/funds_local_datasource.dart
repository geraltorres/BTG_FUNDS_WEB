import 'package:btg_funds_web/core/network/base_datasource.dart';
import 'package:btg_funds_web/features/funds/data/models/fund_model.dart';
import 'package:dio/dio.dart';

abstract class FundsRemoteDatasource {
  Future<List<FundModel>> getFunds();
}

class FundsRemoteDatasourceImpl extends BaseDatasource
    implements FundsRemoteDatasource {
  final Dio dio;

  FundsRemoteDatasourceImpl(this.dio);

  @override
  Future<List<FundModel>> getFunds() {
    return safeCall(() async {
      final response = await dio.get("/funds");

      final List data = response.data["funds"];

      return data.map((e) => FundModel.fromJson(e)).toList();
    });
  }
}
