import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onSubmit,
  });

  final Function(String email, String password) onSubmit;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  bool _showPassword = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: localization.login_form_email_label),
            onChanged: (value) {
              _email = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return localization.login_form_email_required;
              }
              if (!EmailValidator.validate(value)) {
                return localization.login_form_email_invalid;
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: !_showPassword,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: localization.login_form_password_label,
              suffixIcon: IconButton(
                icon: Icon(_showPassword
                    ? MingCute.eye_2_fill
                    : MingCute.eye_close_fill),
                onPressed: () => setState(() {
                  _showPassword = !_showPassword;
                }),
              ),
            ),
            onChanged: (value) {
              _password = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return localization.login_form_password_required;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(40),
            ),
            onPressed: _loading
                ? null
                : () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    setState(() {
                      _loading = true;
                    });
                    widget.onSubmit(_email, _password);
                    setState(() {
                      _loading = false;
                    });
                  },
            child: _loading
                ? CircularProgressIndicator.adaptive()
                : Text(localization.login_form_submit),
          ),
        ],
      ),
    );
  }
}
