import 'package:get_it/get_it.dart';
import 'module/modules.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await initCoreModule(sl);

  await initNetworkModule(sl);

  await initFundsModule(sl);
}
