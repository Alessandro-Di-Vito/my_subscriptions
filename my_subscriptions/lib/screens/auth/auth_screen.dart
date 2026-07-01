import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_subscriptions/components/ui/app_buttons.dart';
import 'package:my_subscriptions/components/ui/app_logo.dart';
import 'package:my_subscriptions/l10n/app_localizations.dart';
import 'package:my_subscriptions/components/ui/app_card.dart';
import 'package:my_subscriptions/components/ui/app_fields.dart';
import 'package:my_subscriptions/components/ui/app_page.dart';
import 'package:my_subscriptions/router/app_router.dart';
import 'package:my_subscriptions/screens/auth/auth_cubit.dart';
import 'package:my_subscriptions/screens/auth/auth_state.dart';
import 'package:my_subscriptions/services/auth_service.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/services/subscription_service.dart';
import 'package:my_subscriptions/services/user_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.initialMode = AuthMode.login});

  final AuthMode initialMode;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(
        getIt<AuthService>(),
        getIt<UserService>(),
        getIt<SubscriptionService>(),
        initialMode: widget.initialMode,
      ),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          final nextRoute = state.nextRoute;
          if (state.status == AuthStatus.success && nextRoute != null) {
            context.go(nextRoute);
          }
        },
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();
          final isRegister = state.mode == AuthMode.register;
          final scheme = Theme.of(context).colorScheme;
          final l10n = AppLocalizations.of(context)!;

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      children: [
                        const AppLogoMark(),
                        const SizedBox(height: 16),
                        Text(
                          isRegister ? 'Crea account' : l10n.appName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isRegister
                              ? 'Inizia con ${l10n.appName}.'
                              : l10n.appTagline,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 28),
                        AppCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              if (isRegister) ...[
                                AppField(
                                  label: 'Nome',
                                  controller: _nameController,
                                  hint: 'Mario Rossi',
                                  prefixIcon: Icons.person_outline_rounded,
                                ),
                                const SizedBox(height: 16),
                              ],
                              AppField(
                                label: 'Email',
                                controller: _emailController,
                                hint: 'nome@email.com',
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: Icons.mail_outline_rounded,
                              ),
                              const SizedBox(height: 16),
                              AppField(
                                label: 'Password',
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                prefixIcon: Icons.lock_outline_rounded,
                                suffixIcon: IconButton(
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              if (state.errorMessage != null) ...[
                                const SizedBox(height: 12),
                                Text(
                                  state.errorMessage!,
                                  style: TextStyle(color: scheme.error),
                                ),
                              ],
                              if (!isRegister) ...[
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: AppTextLink(
                                    label: 'Password dimenticata?',
                                    onPressed: () =>
                                        context.push(AppRoutes.forgotPassword),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                              AppPrimaryButton(
                                label: state.isLoading
                                    ? 'Attendere...'
                                    : (isRegister ? 'Registrati' : 'Accedi'),
                                onPressed: state.isLoading
                                    ? null
                                    : () => cubit.submit(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        displayName: _nameController.text,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppTextLink(
                          label: isRegister
                              ? 'Hai già un account? Accedi'
                              : 'Non hai un account? Registrati',
                          onPressed: state.isLoading
                              ? null
                              : () => cubit.setMode(
                                  isRegister
                                      ? AuthMode.login
                                      : AuthMode.register,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _sent = false;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      await getIt<AuthService>().forgotPassword(_emailController.text);
      setState(() => _sent = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Password dimenticata',
      subtitle: _sent
          ? 'Controlla la tua casella email.'
          : 'Ti invieremo un link per reimpostarla.',
      body: _sent
          ? null
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                AppField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline_rounded,
                ),
              ],
            ),
      actions: [
        if (!_sent)
          AppPageAction(
            label: _loading ? 'Invio...' : 'Invia link',
            onPressed: _loading ? null : _submit,
          ),
        AppPageAction(
          label: 'Torna al login',
          isPrimary: false,
          onPressed: () => context.go(AppRoutes.auth),
        ),
      ],
    );
  }
}
