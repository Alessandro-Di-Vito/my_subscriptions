import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_subscriptions/components/sketch/sketch_screen.dart';
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

          return SketchScreen(
            title: isRegister ? 'Registrazione' : 'Login',
            subtitle: isRegister
                ? 'Crea un account per sincronizzare i tuoi abbonamenti.'
                : 'Accedi al tuo account My Subscriptions.',
            body: ListView(
              children: [
                if (isRegister) ...[
                  SketchField(
                    label: 'Nome visualizzato',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),
                ],
                SketchField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                SketchField(
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                ),
                if (state.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
                const SizedBox(height: 16),
                if (!isRegister)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(AppRoutes.forgotPassword),
                      child: const Text('Password dimenticata?'),
                    ),
                  ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: state.isLoading
                      ? null
                      : () => cubit.setMode(
                          isRegister ? AuthMode.login : AuthMode.register,
                        ),
                  child: Text(
                    isRegister
                        ? 'Hai già un account? Accedi'
                        : 'Non hai un account? Registrati',
                  ),
                ),
              ],
            ),
            actions: [
              SketchAction(
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
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SketchScreen(
      title: 'Password dimenticata',
      subtitle: _sent
          ? 'Se l\'email esiste, riceverai le istruzioni per il reset.'
          : 'Inserisci la tua email per ricevere il link di reset.',
      body: _sent
          ? null
          : SketchField(
              label: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
      actions: [
        if (!_sent)
          SketchAction(
            label: _loading ? 'Invio...' : 'Invia link',
            onPressed: _loading ? null : _submit,
          ),
        SketchAction(
          label: 'Torna al login',
          isPrimary: false,
          onPressed: () => context.go(AppRoutes.auth),
        ),
      ],
    );
  }
}
