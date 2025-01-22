import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

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

  @override
  Widget build(BuildContext context) {
    // FIXME: textos
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: "email"),
            onChanged: (value) {
              _email = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "email é obrigatório";
              }
              if (!EmailValidator.validate(value)) {
                return "digite um email válido";
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
              labelText: "senha",
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
                return "senha é obrigatória";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(40),
            ),
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              widget.onSubmit(_email, _password);
            },
            child: Text("Entrar"),
          ),
        ],
      ),
    );
  }
}
