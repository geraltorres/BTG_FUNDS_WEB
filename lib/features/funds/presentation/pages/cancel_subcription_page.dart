import 'package:btg_funds_web/core/router/app_routes.dart';
import 'package:btg_funds_web/core/utils/currency_formatter.dart';
import 'package:btg_funds_web/features/funds/presentation/bloc/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CancelSubscriptionPage extends StatelessWidget {
  const CancelSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cancelar suscripción")),

      body: BlocBuilder<FundBloc, FundState>(
        builder: (context, state) {
          final transactions = state.portfolio.transactions
              .where((t) => t.type == "SUBSCRIPTION")
              .toList();

          if (transactions.isEmpty) {
            return const Center(child: Text("No tienes suscripciones activas"));
          }

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];

              return ListTile(
                leading: const Icon(Icons.account_balance),

                title: Text(tx.fundName),

                subtitle: Text(
                  "Monto: COP ${CurrencyFormatter.getCurrencyFormated(tx.amount)}",
                ),

                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

                  child: const Text("Cancelar"),

                  onPressed: () async {
                    context.read<FundBloc>().add(
                      CancelFundEvent(tx.fundId, tx.notification),
                    );
                    await goBackPage(context);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> goBackPage(BuildContext context) async {
    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home));
  }
}
