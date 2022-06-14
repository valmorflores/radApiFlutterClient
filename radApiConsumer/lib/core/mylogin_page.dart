import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text('LoginPage'),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (email) {
                if (email == null || email.isEmpty) {
                  return 'Digite um e-mail';
                }
              },
            ),
            TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.text,
              validator: (password) {
                if (password == null || password.isEmpty) {
                  return 'Senha está incorreta';
                } else if (password.length < 6) {
                  return 'Por favor informe uma senha com 6 digitos pelo menos';
                }
                return null;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  return;
                },
                child: Text('ENTRAR'))
          ]),
        ),
      ),
    );
  }
}
