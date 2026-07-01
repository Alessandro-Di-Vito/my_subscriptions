import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_subscriptions/screens/onboarding/onboarding_state.dart';
import 'package:my_subscriptions/utils/storage.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void goBack() {
    if (state.stepIndex == 0) {
      return;
    }
    emit(state.copyWith(step: OnboardingStep.values[state.stepIndex - 1]));
  }

  void continueFlow() {
    if (state.isLastStep) {
      return;
    }
    emit(state.copyWith(step: OnboardingStep.values[state.stepIndex + 1]));
  }

  Future<void> completeOnboarding() async {
    await Storage.setOnboardingCompleted(true);
  }
}
