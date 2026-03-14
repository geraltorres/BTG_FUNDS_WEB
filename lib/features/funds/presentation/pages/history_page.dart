import 'package:btg_funds_web/core/router/app_routes.dart';
import 'package:btg_funds_web/core/theme/app_theme.dart';
import 'package:btg_funds_web/core/utils/currency_formatter.dart';
import 'package:btg_funds_web/core/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/fund_bloc.dart';
import '../bloc/fund_state.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Historial de transacciones")),

      body: BlocBuilder<FundBloc, FundState>(
        builder: (context, state) {
          final transactions = [...state.portfolio.transactions]
            ..sort((a, b) => b.date.compareTo(a.date));

          if (transactions.isEmpty) {
            return const Center(
              child: Text("No hay transacciones registradas"),
            );
          }

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              final isSuscription = (tx.type == "SUBSCRIPTION");
              final investmentColor = MaterialTheme.customColor1.light.color;
              return ListTile(
                leading: Icon(
                  isSuscription ? Icons.trending_up : Icons.trending_down,
                  color: isSuscription ? investmentColor : Colors.red,
                ),

                title: Text(tx.fundName),

                subtitle: Text(
                  "${tx.type} • ${DateFormatter.getDateFormated(tx.date)} • Notificación: ${tx.notification}",
                ),
                onTap: isSuscription
                    ? () {
                        /*
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CancelSubscriptionPage(),
                          ),
                        );*/
                        context.push(AppRoutes.cancel);
                      }
                    : null,
                trailing: Text(
                  CurrencyFormatter.getCurrencyFormated(tx.amount),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
