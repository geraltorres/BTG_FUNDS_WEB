import 'package:btg_funds_web/core/errors/app_exception_guard.dart';

abstract class BaseDatasource {
  Future<T> safeCall<T>(Future<T> Function() action) {
    return AppExceptionGuard.guard(action);
  }
}
