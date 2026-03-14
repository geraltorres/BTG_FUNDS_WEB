import 'package:flutter/material.dart';

import 'app_loading_view.dart';
import 'app_error_view.dart';
import 'app_empty_view.dart';

class PageStateBuilder extends StatelessWidget {
  final bool loading;
  final String? error;
  final bool isEmpty;

  final Widget child;
  final VoidCallback? onRetry;

  const PageStateBuilder({
    super.key,
    required this.loading,
    required this.error,
    required this.isEmpty,
    required this.child,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const AppLoadingView();
    }

    if (error != null) {
      return AppErrorView(message: error!, onRetry: onRetry);
    }

    if (isEmpty) {
      return const AppEmptyView(message: "No hay información disponible");
    }

    return child;
  }
}
