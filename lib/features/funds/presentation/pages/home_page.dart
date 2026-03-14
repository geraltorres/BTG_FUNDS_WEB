import 'package:btg_funds_web/core/router/app_routes.dart';
import 'package:btg_funds_web/core/theme/theme_notifier.dart';
import 'package:btg_funds_web/core/utils/currency_formatter.dart';
import 'package:btg_funds_web/features/funds/domain/entities/fund.dart';
import 'package:btg_funds_web/features/funds/domain/entities/transaction.dart';
import 'package:btg_funds_web/features/funds/presentation/widgets/widgets.dart';
import 'package:btg_funds_web/shared/widgets/page_state_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btg_funds_web/features/funds/presentation/bloc/index.dart';
import 'package:go_router/go_router.dart';
import 'history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    context.read<FundBloc>().add(LoadFunds());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BTG Fondos"),
        actions: [
          ValueListenableBuilder(
            valueListenable: ThemeNotifier.themeMode,

            builder: (_, ThemeMode mode, __) {
              return IconButton(
                icon: Icon(
                  mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                ),

                onPressed: () {
                  ThemeNotifier.toggleTheme();
                },
              );
            },
          ),
        ],
      ),

      body: BlocBuilder<FundBloc, FundState>(
        builder: (context, state) {
          return BlocListener<FundBloc, FundState>(
            listener: (context, state) {
              if (state.error == null &&
                  !state.loading &&
                  state.successMessage != null) {
                showScaffoldMessage(context, state.successMessage!);
              }
            },
            child: PageStateBuilder(
              loading: state.loading,
              error: state.error,
              isEmpty: state.portfolio.funds.isEmpty,

              onRetry: () {
                context.read<FundBloc>().add(LoadFunds());
              },

              child: Column(
                children: [
                  _buildBalanceCard(state),
                  _buildPortfolioStats(state),
                  const SizedBox(height: 10),
                  _buildQuickActions(),
                  const SizedBox(height: 10),
                  Expanded(child: _buildFundsList(state)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBalanceCard(FundState state) {
    final balance = state.portfolio.balance;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: scheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Saldo disponible",
                style: TextStyle(
                  color: scheme.onPrimaryContainer,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                CurrencyFormatter.getCurrencyFormated(balance),
                style: TextStyle(
                  color: scheme.onPrimaryContainer,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortfolioStats(FundState state) {
    final portfolio = state.portfolio;

    final activeSubscriptions = getActiveSubscriptions(portfolio.transactions);

    final activeFunds = activeSubscriptions.length;

    final invested = activeSubscriptions.fold<int>(
      0,
      (sum, tx) => sum + tx.amount,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          _statCard(
            "Invertido",
            CurrencyFormatter.getCurrencyFormated(invested),
          ),

          _statCard("Fondos", activeFunds.toString()),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 6),

        child: Padding(
          padding: const EdgeInsets.all(12),

          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 4),

              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  List<Transaction> getActiveSubscriptions(List<Transaction> txs) {
    final Map<int, Transaction> active = {};

    for (final tx in txs) {
      if (tx.type == "SUBSCRIPTION") {
        active[tx.fundId] = tx;
      }

      if (tx.type == "CANCEL") {
        active.remove(tx.fundId);
      }
    }

    return active.values.toList();
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,

        children: [
          _actionButton(
            icon: Icons.history,
            label: "Historial",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
    );
  }

  Widget _buildFundsList(FundState state) {
    final funds = state.portfolio.funds;

    return ListView.builder(
      padding: const EdgeInsets.all(16),

      itemCount: funds.length,

      itemBuilder: (context, index) {
        final fund = funds[index];
        final canInvest = state.portfolio.balance >= fund.minAmount;

        return FundCard(
          fund: fund,
          onSubscribe: canInvest
              ? () {
                  onOpenSubscribe(fund, state.portfolio.balance);
                }
              : null,
        );
      },
    );
  }

  void onOpenSubscribe(Fund fund, int balance) {
    /*    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SubscribePage(fund: fund, balance: balance),
          ),
        );*/
    final args = [];
    args.add(fund);
    args.add(balance);
    context.push(AppRoutes.subscribe, extra: args);
  }

  void showScaffoldMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
