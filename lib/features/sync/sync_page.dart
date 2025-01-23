import 'package:battlemaster/features/auth/providers/auth_provider.dart';
import 'package:battlemaster/features/encounters/providers/encounters_provider.dart';
import 'package:battlemaster/features/sync/widgets/login_form.dart';
import 'package:battlemaster/features/sync/widgets/signup_form.dart';
import 'package:battlemaster/features/sync/widgets/sync_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class SyncPage extends StatelessWidget {
  const SyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    if (authProvider.isAuthenticated) {
      return const SyncStatus();
    }
    return const _Login();
  }
}

class _Login extends StatefulWidget {
  const _Login();

  @override
  State<_Login> createState() => __LoginState();
}

class __LoginState extends State<_Login> {
  bool _showLogin = true;
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final encountersProvider = context.read<EncountersProvider>();
    // FIXME: textos
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Sincronize seus combates entre aparelhos",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                if (_showLogin)
                  LoginForm(
                    onSubmit: (email, password) async {
                      final success = await authProvider
                          .login(UserCredentials(email, password));
                      if (!success) {
                        toastification.show(
                          type: ToastificationType.error,
                          style: ToastificationStyle.fillColored,
                          autoCloseDuration: 3.seconds,
                          showProgressBar: false,
                          title: Text("Houve um erro ao entrar"),
                          description: Text("Tente novamente ou crie uma conta"),
                        );
                      }
                      await encountersProvider.syncAllEncounters();
                    },
                  ),
                if (!_showLogin)
                  SignupForm(
                    onSubmit: (data) async {
                      final success = await authProvider.signUp(data);
                      if (!success) {
                        toastification.show(
                          type: ToastificationType.error,
                          style: ToastificationStyle.fillColored,
                          autoCloseDuration: 3.seconds,
                          showProgressBar: false,
                          title: Text("houve um erro ao criar sua conta"),
                          description: Text(
                              "faça o login ou tente novamente mais tarde"),
                        );
                      }
                      await authProvider
                          .login(UserCredentials(data.email, data.password));
                      await encountersProvider.syncAllEncounters();
                    },
                  ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                if (_showLogin)
                  Column(
                    children: [
                      Text("Não tem acesso?"),
                      TextButton(
                        onPressed: () => setState(() {
                          _showLogin = false;
                        }),
                        child: Text("Criar nova conta"),
                      ),
                    ],
                  ),
                if (!_showLogin)
                  Column(
                    children: [
                      Text("Já tem uma conta?"),
                      TextButton(
                        onPressed: () => setState(() {
                          _showLogin = true;
                        }),
                        child: Text("Acesse sua conta"),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
