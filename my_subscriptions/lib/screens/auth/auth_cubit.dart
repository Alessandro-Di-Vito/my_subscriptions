import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_subscriptions/network/api_exception.dart';
import 'package:my_subscriptions/cubit/theme_cubit.dart';
import 'package:my_subscriptions/router/app_router.dart';
import 'package:my_subscriptions/screens/auth/auth_state.dart';
import 'package:my_subscriptions/services/auth_service.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/services/subscription_service.dart';
import 'package:my_subscriptions/services/user_service.dart';
import 'package:my_subscriptions/utils/storage.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._authService,
    this._userService,
    this._subscriptionService, {
    AuthMode initialMode = AuthMode.login,
  }) : super(AuthState(mode: initialMode));

  final AuthService _authService;
  final UserService _userService;
  final SubscriptionService _subscriptionService;

  void setMode(AuthMode mode) {
    emit(state.copyWith(mode: mode, status: AuthStatus.initial, errorMessage: null));
  }

  Future<void> submit({
    required String email,
    required String password,
    String? displayName,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      if (state.mode == AuthMode.register) {
        final currency = await Storage.getPreferredCurrency();
        await _authService.register(
          email: email,
          password: password,
          displayName: displayName,
          defaultCurrency: currency,
        );
        await _userService.syncLocalOnboardingPreferences();
        await getIt<ThemeCubit>().load();
        emit(
          state.copyWith(
            status: AuthStatus.success,
            nextRoute: AppRoutes.firstSubscription,
          ),
        );
        return;
      }

      await _authService.login(email: email, password: password);
      final profile = await _userService.getProfile(showErrorBanner: false);
      if (!(profile.preferences?.isOnboardingCompleted ?? false)) {
        await _userService.syncLocalOnboardingPreferences();
      }

      final summary = await _subscriptionService.summary();
      await getIt<ThemeCubit>().load();
      emit(
        state.copyWith(
          status: AuthStatus.success,
          nextRoute: summary.totalCount == 0
              ? AppRoutes.firstSubscription
              : AppRoutes.home,
        ),
      );
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
