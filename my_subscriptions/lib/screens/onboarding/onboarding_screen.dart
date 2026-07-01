import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_subscriptions/components/ui/app_animated_appear.dart';
import 'package:my_subscriptions/components/ui/app_buttons.dart';
import 'package:my_subscriptions/components/ui/app_logo.dart';
import 'package:my_subscriptions/l10n/app_localizations.dart';
import 'package:my_subscriptions/router/app_router.dart';
import 'package:my_subscriptions/screens/onboarding/onboarding_cubit.dart';
import 'package:my_subscriptions/screens/onboarding/onboarding_state.dart';
import 'package:my_subscriptions/utils/font_size.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scaffoldBg,
              scheme.primary.withValues(alpha: 0.08),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                final l10n = AppLocalizations.of(context)!;
                final stepContent = switch (state.step) {
                  OnboardingStep.track => (
                    icon: Icons.subscriptions_outlined,
                    title: l10n.onboardingTrackTitle,
                    subtitle: l10n.onboardingTrackSubtitle,
                  ),
                  OnboardingStep.analyze => (
                    icon: Icons.pie_chart_outline_rounded,
                    title: l10n.onboardingAnalyzeTitle,
                    subtitle: l10n.onboardingAnalyzeSubtitle,
                  ),
                  OnboardingStep.remind => (
                    icon: Icons.notifications_active_outlined,
                    title: l10n.onboardingRemindTitle,
                    subtitle: l10n.onboardingRemindSubtitle,
                  ),
                };

                return Column(
                  children: [
                    _ProgressHeader(state: state),
                    const SizedBox(height: 32),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.08, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: _IntroStep(
                          key: ValueKey(state.step),
                          icon: stepContent.icon,
                          title: stepContent.title,
                          subtitle: stepContent.subtitle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _BottomActions(state: state),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.state});

  final OnboardingState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              minHeight: 4,
              value: state.progress,
              backgroundColor: scheme.primary.withValues(alpha: 0.16),
              color: scheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          l10n.onboardingStepProgress(
            state.stepIndex + 1,
            OnboardingState.stepCount,
          ),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _IntroStep extends StatelessWidget {
  const _IntroStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        const Spacer(),
        AppAnimatedAppear(
          child: AppLogoMark(size: 120, borderRadius: 24),
        ),
        const SizedBox(height: 36),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: scheme.onSurface,
            fontSize: titleMedium,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: scheme.onSurfaceVariant,
            fontSize: bodyLarge,
            height: 1.45,
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.state});

  final OnboardingState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<OnboardingCubit>();
    final isFirst = state.stepIndex == 0;
    final isLast = state.isLastStep;

    return Column(
      children: [
        AppPrimaryButton(
          label: isLast ? l10n.onboardingFinish : l10n.onboardingContinue,
          onPressed: isLast
              ? () => _completeAndGo(context, cubit)
              : cubit.continueFlow,
        ),
        if (!isFirst) ...[
          const SizedBox(height: 12),
          AppSecondaryButton(
            label: l10n.onboardingBack,
            onPressed: cubit.goBack,
          ),
        ],
      ],
    );
  }

  Future<void> _completeAndGo(
    BuildContext context,
    OnboardingCubit cubit,
  ) async {
    await cubit.completeOnboarding();
    if (context.mounted) {
      context.go(AppRoutes.auth);
    }
  }
}
