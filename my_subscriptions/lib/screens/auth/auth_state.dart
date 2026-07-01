enum AuthMode { login, register }

enum AuthStatus { initial, loading, success, failure }

class AuthState {
  const AuthState({
    this.mode = AuthMode.login,
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.nextRoute,
  });

  final AuthMode mode;
  final AuthStatus status;
  final String? errorMessage;
  final String? nextRoute;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthMode? mode,
    AuthStatus? status,
    String? errorMessage,
    String? nextRoute,
  }) {
    return AuthState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      errorMessage: errorMessage,
      nextRoute: nextRoute ?? this.nextRoute,
    );
  }
}
