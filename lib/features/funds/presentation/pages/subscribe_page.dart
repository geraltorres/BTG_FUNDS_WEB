import 'package:btg_funds_web/core/utils/currency_formatter.dart';
import 'package:btg_funds_web/features/funds/domain/entities/fund.dart';
import 'package:btg_funds_web/features/funds/presentation/bloc/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SubscribePage extends StatefulWidget {
  final Fund fund;
  final int balance;

  const SubscribePage({super.key, required this.fund, required this.balance});

  @override
  State<SubscribePage> createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();

  String _notification = "EMAIL";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Suscribirse a fondo")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// nombre del fondo
              Text(
                widget.fund.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Monto mínimo: COP ${CurrencyFormatter.getCurrencyFormated(widget.fund.minAmount)}",
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 10),

              Text(
                "Balance: COP ${CurrencyFormatter.getCurrencyFormated(widget.balance)}",
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              /// campo monto
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,

                decoration: const InputDecoration(
                  labelText: "Monto a invertir",
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese un monto";
                  }

                  final amount = int.tryParse(value);

                  if (amount == null) {
                    return "Monto inválido";
                  }

                  if (amount < widget.fund.minAmount) {
                    return "El monto debe ser mayor al mínimo";
                  }

                  if (amount > widget.balance) {
                    return "El monto debe ser menor o igual al balance";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              /// notificación
              DropdownButtonFormField<String>(
                initialValue: _notification,

                decoration: const InputDecoration(
                  labelText: "Método de notificación",
                  border: OutlineInputBorder(),
                ),

                items: const [
                  DropdownMenuItem(value: "EMAIL", child: Text("Email")),

                  DropdownMenuItem(value: "SMS", child: Text("SMS")),
                ],

                onChanged: (value) {
                  setState(() {
                    _notification = value!;
                  });
                },
              ),

              const SizedBox(height: 30),

              /// botón suscribir
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: onPressed,
                  child: const Text("Confirmar suscripción"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onPressed() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = int.parse(_amountController.text);

    context.read<FundBloc>().add(
      SubscribeFundEvent(
        fundId: widget.fund.id,
        fundName: widget.fund.name,
        amount: amount,
        notification: _notification,
      ),
    );

    context.pop();
  }
}
