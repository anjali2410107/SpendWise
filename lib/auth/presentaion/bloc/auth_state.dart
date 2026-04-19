class AuthState {
  final bool isLoading;
  final String? userId;
  final String? error;
  AuthState({
    this.isLoading = false,
    this.userId,
    this.error,
  });
  AuthState copyWith({
    bool? isLoading,
    String? userId,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      userId: userId ?? this.userId,
      error: error,
    );
  }
}