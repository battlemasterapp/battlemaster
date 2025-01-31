import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';

class SignupData {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  const SignupData({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  factory SignupData.empty() {
    return SignupData(
      name: "",
      email: "",
      password: "",
      passwordConfirmation: "",
    );
  }

  SignupData copyWith({
    String? name,
    String? email,
    String? password,
    String? passwordConfirmation,
  }) {
    return SignupData(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({
    super.key,
    required this.onSubmit,
  });

  final Function(SignupData data) onSubmit;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  SignupData _form = SignupData.empty();
  bool _showPassword = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      labelText: localization.signup_form_name_label),
                  onChanged: (value) {
                    _form = _form.copyWith(name: value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localization.signup_form_name_required;
                    }
                    final parts = value.split(" ");
                    if (parts.length <= 1) {
                      return localization.signup_form_name_min_length;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: localization.signup_form_email_label),
                  onChanged: (value) {
                    _form = _form.copyWith(email: value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localization.signup_form_email_required;
                    }
                    if (!EmailValidator.validate(value)) {
                      return localization.signup_form_email_invalid;
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
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
                    _form = _form.copyWith(password: value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localization.signup_form_password_required;
                    }
                    if (value.length < 8) {
                      return localization.signup_form_password_min_length;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_showPassword,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                      labelText:
                          localization.signup_form_password_confirmation_label),
                  onChanged: (value) {
                    _form = _form.copyWith(passwordConfirmation: value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localization
                          .signup_form_password_confirmation_required;
                    }
                    if (value != _form.password) {
                      return localization
                          .signup_form_password_confirmation_mismatch;
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(40),
            ),
            onPressed: _loading
                ? null
                : () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    setState(() {
                      _loading = true;
                    });
                    await widget.onSubmit(_form);
                    setState(() {
                      _loading = false;
                    });
                  },
            child: _loading
                ? CircularProgressIndicator.adaptive()
                : Text(localization.signup_form_submit),
          ),
        ],
      ),
    );
  }
}
