import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_subscriptions/router/app_router.dart';
import 'package:my_subscriptions/screens/welcome/welcome_state.dart';
import 'package:my_subscriptions/services/user_service.dart';
import 'package:my_subscriptions/utils/storage.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit(this._userService) : super(const WelcomeState());

  final UserService _userService;

  Future<void> start() async {
    final alreadyLaunch = await Storage.getAlreadyLaunch();
    if (!alreadyLaunch) {
      emit(state.copyWith(status: WelcomeStatus.visible));
      return;
    }

    final accessToken = await Storage.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      emit(state.copyWith(status: WelcomeStatus.visible));
      return;
    }

    await _getOnboardingCompleted();
    await Future<void>.delayed(const Duration(milliseconds: 900));
    emit(
      state.copyWith(
        status: WelcomeStatus.redirect,
        nextRoute: AppRoutes.home,
      ),
    );
  }

  Future<bool> _getOnboardingCompleted() async {
    try {
      final onboardingCompleted = await _userService.hasCompletedOnboarding(
        showErrorBanner: false,
      );
      await Storage.setOnboardingCompleted(onboardingCompleted);
      return onboardingCompleted;
    } catch (_) {
      return Storage.getOnboardingCompleted();
    }
  }
}
