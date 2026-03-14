import 'package:btg_funds_web/core/utils/currency_formatter.dart';
import 'package:btg_funds_web/features/funds/domain/entities/fund.dart';
import 'package:flutter/material.dart';

class FundCard extends StatelessWidget {
  final Fund fund;
  final VoidCallback? onSubscribe;

  const FundCard({super.key, required this.fund, required this.onSubscribe});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: scheme.primaryContainer,
              child: Icon(Icons.trending_up, color: scheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fund.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),

                        decoration: BoxDecoration(
                          color: fund.category == "FPV"
                              ? Colors.blue.shade50
                              : Colors.green.shade50,

                          borderRadius: BorderRadius.circular(6),
                        ),

                        child: Text(
                          fund.category,
                          style: TextStyle(
                            color: fund.category == "FPV"
                                ? Colors.blue
                                : Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Monto mínimo",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),

                      Text(
                        CurrencyFormatter.getCurrencyFormated(fund.minAmount),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onSubscribe,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Suscribirse"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
