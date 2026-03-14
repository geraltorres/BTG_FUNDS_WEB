class BaseState {
  final bool loading;
  final String? error;
  final String? successMessage;

  const BaseState({this.loading = false, this.error, this.successMessage});

  BaseState copyWith({bool? loading, String? error}) {
    return BaseState(
      loading: loading ?? this.loading,
      error: error,
      successMessage: successMessage,
    );
  }
}
