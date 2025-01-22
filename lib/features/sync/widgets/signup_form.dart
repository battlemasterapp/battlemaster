import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
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
  const SignupForm({super.key, required this.onSubmit,});

  final ValueChanged<SignupData> onSubmit;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  SignupData _form = SignupData.empty();
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    // FIXME: textos
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
                  decoration: InputDecoration(labelText: "nome"),
                  onChanged: (value) {
                    _form = _form.copyWith(name: value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "nome é obrigatório";
                    }
                    final parts = value.split(" ");
                    if (parts.length <= 1) {
                      return "digite seu nome e sobrenome";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "email"),
                  onChanged: (value) {
                    _form = _form.copyWith(email: value);
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
                    _form = _form.copyWith(password: value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "senha é obrigatória";
                    }
                    if (value.length < 8) {
                      return "sua senha precisa ter 8 digitos";
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
                  decoration: InputDecoration(labelText: "confirme a senha"),
                  onChanged: (value) {
                    _form = _form.copyWith(passwordConfirmation: value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "confirmação senha é obrigatória";
                    }
                    if (value != _form.passwordConfirmation) {
                      return "as senhas não são iguais";
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
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              widget.onSubmit(_form);
            },
            child: Text("Criar conta"),
          ),
        ],
      ),
    );
  }
}
