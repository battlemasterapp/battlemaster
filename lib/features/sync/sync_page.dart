import 'package:battlemaster/features/auth/providers/auth_provider.dart';
import 'package:battlemaster/features/encounters/providers/encounters_provider.dart';
import 'package:battlemaster/features/sync/widgets/login_form.dart';
import 'package:battlemaster/features/sync/widgets/signup_form.dart';
import 'package:battlemaster/features/sync/widgets/sync_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final localization = AppLocalizations.of(context)!;
    final authProvider = context.read<AuthProvider>();
    final encountersProvider = context.read<EncountersProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            localization.sync_page_title,
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
                          title: Text(localization.login_error_title),
                          description:
                              Text(localization.login_error_description),
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
                          title: Text(localization.signup_error_title),
                          description:
                              Text(localization.signup_error_description),
                        );
                        return;
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
                      Text(localization.sync_page_no_access_question),
                      TextButton(
                        onPressed: () => setState(() {
                          _showLogin = false;
                        }),
                        child: Text(localization.create_account_cta),
                      ),
                    ],
                  ),
                if (!_showLogin)
                  Column(
                    children: [
                      Text(
                          localization.sync_page_already_have_account_question),
                      TextButton(
                        onPressed: () => setState(() {
                          _showLogin = true;
                        }),
                        child: Text(localization.login_cta),
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
