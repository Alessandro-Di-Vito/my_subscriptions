import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_subscriptions/components/button/button_widget.dart';
import 'package:my_subscriptions/l10n/app_localizations.dart';
import 'package:my_subscriptions/router/app_router.dart';
import 'package:my_subscriptions/screens/welcome/welcome_cubit.dart';
import 'package:my_subscriptions/screens/welcome/welcome_state.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/services/user_service.dart';
import 'package:my_subscriptions/utils/colors.dart';
import 'package:my_subscriptions/utils/font_size.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';
import 'package:my_subscriptions/utils/storage.dart';
import 'package:smooth_corner/smooth_corner.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WelcomeCubit(getIt<UserService>())..start(),
      child: const _WelcomeView(),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<WelcomeCubit, WelcomeState>(
      listenWhen: (previous, current) =>
          previous.nextRoute != current.nextRoute ||
          previous.status != current.status,
      listener: (context, state) {
        final nextRoute = state.nextRoute;
        if (state.shouldRedirect && nextRoute != null) {
          context.go(nextRoute);
        }
      },
      child: const _AnimatedWelcomeView(),
    );
  }
}

class _AnimatedWelcomeView extends StatefulWidget {
  const _AnimatedWelcomeView();

  @override
  State<_AnimatedWelcomeView> createState() => _AnimatedWelcomeViewState();
}

class _AnimatedWelcomeViewState extends State<_AnimatedWelcomeView>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _floatingController;
  late final Animation<double> _contentOpacity;
  late final Animation<Offset> _contentOffset;
  late final Animation<double> _footerOpacity;
  late final Animation<Offset> _footerOffset;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );

    final fadeCurve = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.45, 1, curve: Curves.easeOutCubic),
    );
    _contentOpacity = fadeCurve;
    _contentOffset = Tween<Offset>(
      begin: const Offset(0, 0.16),
      end: Offset.zero,
    ).animate(fadeCurve);

    final footerCurve = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.65, 1, curve: Curves.easeOutCubic),
    );
    _footerOpacity = footerCurve;
    _footerOffset = Tween<Offset>(
      begin: const Offset(0, 0.20),
      end: Offset.zero,
    ).animate(footerCurve);

    _entranceController.forward().whenComplete(() {
      if (mounted) {
        _floatingController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned.fill(child: ColoredBox(color: Colors.white)),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.surface,
                      AppColors.surface.withValues(alpha: 0.12),
                      AppColors.primary.withValues(alpha: 0.14),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const logoSize = 140.0;
                  final startTop = (constraints.maxHeight - logoSize) / 2;
                  final endTop = constraints.maxHeight * 0.12;

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      AnimatedBuilder(
                        animation: Listenable.merge([
                          _entranceController,
                          _floatingController,
                        ]),
                        builder: (context, child) {
                          final animatedEntranceValue = Curves.easeInOutCubic
                              .transform(_entranceController.value);
                          final animatedFloatingOffset =
                              _entranceController.isCompleted
                              ? Tween<double>(begin: -8, end: 8).transform(
                                  Curves.easeInOut.transform(
                                    _floatingController.value,
                                  ),
                                )
                              : 0.0;
                          final animatedLogoTop =
                              startTop +
                              ((endTop - startTop) * animatedEntranceValue) +
                              animatedFloatingOffset;

                          return Positioned(
                            top: animatedLogoTop,
                            left: 0,
                            right: 0,
                            child: child!,
                          );
                        },
                        child: SmoothContainer(
                          smoothness: SmoothStyle.smoothness,
                          borderRadius: SmoothStyle.borderRadius,
                          width: logoSize,
                          height: logoSize,
                          color: AppColors.primary.withValues(alpha: 0.12),
                          child: Icon(
                            Icons.subscriptions_outlined,
                            size: logoSize * 0.55,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              SizedBox(height: constraints.maxHeight * 0.40),
                              FadeTransition(
                                opacity: _contentOpacity,
                                child: SlideTransition(
                                  position: _contentOffset,
                                  child: Column(
                                    children: [
                                      Text(
                                        l10n.welcomeTitle,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                              color: AppColors.textPrimary,

                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        l10n.welcomeSubtitle,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: AppColors.textPrimary
                                                  .withValues(alpha: 0.78),
                                              fontSize: bodyLarge,
                                              height: 1.55,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              FadeTransition(
                                opacity: _footerOpacity,
                                child: SlideTransition(
                                  position: _footerOffset,
                                  child: Column(
                                    children: [
                                      BlocBuilder<WelcomeCubit, WelcomeState>(
                                        buildWhen: (previous, current) =>
                                            previous.status != current.status,
                                        builder: (context, state) {
                                          if (state.status ==
                                              WelcomeStatus.checking) {
                                            return SmoothContainer(
                                              smoothness: SmoothStyle.smoothness,
                                              borderRadius:
                                                  SmoothStyle.borderRadius,
                                              width: double.infinity,
                                              height: 54,
                                              color: AppColors.gray,
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  color: AppColors.primaryDark,
                                                ),
                                              ),
                                            );
                                          }

                                          return ButtonWidget(
                                            text: l10n.welcomeButton,
                                            onPressed: () async {
                                              await Storage.setAlreadyLaunch(
                                                true,
                                              );
                                              if (context.mounted) {
                                                context.go(AppRoutes.auth);
                                              }
                                            },
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 46),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.language,
                                            size: 20,
                                            color: AppColors.textSecondary
                                                .withValues(alpha: 0.82),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            l10n.welcomeLanguage,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color:
                                                      AppColors.textSecondary,
                                                  fontSize: bodyLarge,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 28),
                                      Text(
                                        l10n.welcomePrivacyTerms,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              color: AppColors.textSecondary
                                                  .withValues(alpha: 0.58),
                                              fontSize: labelLarge,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1.6,
                                            ),
                                      ),
                                      const SizedBox(height: 36),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
