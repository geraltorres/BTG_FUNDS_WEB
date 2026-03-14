import 'package:btg_funds_web/features/funds/data/datasources/funds_local_datasource.dart';
import 'package:btg_funds_web/features/funds/data/repositories/fund_repository_imp.dart';
import 'package:btg_funds_web/features/funds/domain/repositories/fund_repository.dart';
import 'package:btg_funds_web/features/funds/domain/usescases/get_funds.dart';
import 'package:btg_funds_web/features/funds/presentation/bloc/fund_bloc.dart';
import 'package:get_it/get_it.dart';

Future<void> initFundsModule(GetIt sl) async {
  /// DATASOURCE
  sl.registerLazySingleton<FundsRemoteDatasource>(
    () => FundsRemoteDatasourceImpl(sl()),
  );

  /// REPOSITORY
  sl.registerLazySingleton<FundRepository>(
    () => FundRepositoryImpl(sl(), sl()),
  );

  /// USECASE
  sl.registerLazySingleton(() => GetFunds(sl()));

  /// BLOC
  sl.registerFactory<FundBloc>(() => FundBloc(sl()));
}
