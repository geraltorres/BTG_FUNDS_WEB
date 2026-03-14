import 'package:btg_funds_web/core/router/app_router.dart';
import 'package:btg_funds_web/core/theme/app_theme.dart';
import 'package:btg_funds_web/core/theme/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'features/funds/presentation/bloc/fund_bloc.dart';
import 'features/funds/presentation/bloc/fund_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (_) => sl<FundBloc>()..add(LoadFunds()),
      child: ValueListenableBuilder(
        valueListenable: ThemeNotifier.themeMode,
        builder: (_, ThemeMode mode, __) {
          return MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            title: "BTG Funds",
            theme: MaterialTheme(textTheme).light(),
            darkTheme: MaterialTheme(textTheme).dark(),
            themeMode: mode,
            //home: const HomePage(),
          );
        },
      ),
    );
  }
}
