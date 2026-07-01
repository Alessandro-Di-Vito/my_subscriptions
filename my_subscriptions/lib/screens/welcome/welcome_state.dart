enum WelcomeStatus { checking, visible, redirect }

class WelcomeState {
  const WelcomeState({this.status = WelcomeStatus.checking, this.nextRoute});

  final WelcomeStatus status;
  final String? nextRoute;

  bool get shouldRedirect => status == WelcomeStatus.redirect;

  WelcomeState copyWith({WelcomeStatus? status, String? nextRoute}) {
    return WelcomeState(
      status: status ?? this.status,
      nextRoute: nextRoute ?? this.nextRoute,
    );
  }
}
