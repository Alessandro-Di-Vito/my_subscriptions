enum OnboardingStep { track, analyze, remind }

class OnboardingState {
  const OnboardingState({this.step = OnboardingStep.track});

  final OnboardingStep step;

  static const stepCount = 3;

  int get stepIndex => step.index;

  double get progress => (stepIndex + 1) / stepCount;

  bool get isLastStep => step == OnboardingStep.remind;

  OnboardingState copyWith({OnboardingStep? step}) {
    return OnboardingState(step: step ?? this.step);
  }
}
