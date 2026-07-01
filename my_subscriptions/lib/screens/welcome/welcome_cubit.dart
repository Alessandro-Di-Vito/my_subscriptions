import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_subscriptions/router/app_router.dart';
import 'package:my_subscriptions/screens/welcome/welcome_state.dart';
import 'package:my_subscriptions/services/auth_service.dart';
import 'package:my_subscriptions/utils/storage.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit(this._authService) : super(const WelcomeState());

  final AuthService _authService;

  Future<void> start() async {
    if (await _authService.isLoggedIn()) {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      emit(
        state.copyWith(
          status: WelcomeStatus.redirect,
          nextRoute: AppRoutes.home,
        ),
      );
      return;
    }

    final onboardingCompleted = await Storage.getOnboardingCompleted();
    if (onboardingCompleted) {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      emit(
        state.copyWith(
          status: WelcomeStatus.redirect,
          nextRoute: AppRoutes.auth,
        ),
      );
      return;
    }

    emit(state.copyWith(status: WelcomeStatus.visible));
  }
}
