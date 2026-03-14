import 'package:btg_funds_web/features/funds/presentation/pages/cancel_subcription_page.dart';
import 'package:btg_funds_web/features/funds/presentation/pages/history_page.dart';
import 'package:btg_funds_web/features/funds/presentation/pages/home_page.dart';
import 'package:btg_funds_web/features/funds/presentation/pages/subscribe_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: "/",

  routes: [
    GoRoute(path: "/", builder: (context, state) => const HomePage()),

    GoRoute(
      path: "/subscribe",
      builder: (context, state) {
        final args = state.extra as List<dynamic>;
        final fund = args[0];
        final balance = args[1];
        return SubscribePage(fund: fund, balance: balance);
      },
    ),

    GoRoute(path: "/history", builder: (context, state) => const HistoryPage()),

    GoRoute(
      path: "/cancel",
      builder: (context, state) => const CancelSubscriptionPage(),
    ),
  ],
);
