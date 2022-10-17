import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../pages.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter? presenter;

  const LoginPage({
    this.presenter,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginHeader(),
            const Headline1(
              text: 'Login',
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                child: Column(
                  children: [
                    StreamBuilder<String>(
                        stream: presenter!.emailErrorStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              errorText: snapshot.data?.isEmpty == true
                                  ? null
                                  : snapshot.data,
                              icon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColorLight,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: presenter!.validateEmail,
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 32),
                      child: StreamBuilder<String>(
                          stream: presenter!.passwordErrorStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                errorText: snapshot.data?.isEmpty == true
                                    ? null
                                    : snapshot.data,
                                icon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                              obscureText: true,
                              onChanged: presenter!.validatePassword,
                            );
                          }),
                    ),
                    StreamBuilder<bool>(
                      stream: presenter!.isFormValidStream,
                      builder: (context, snapshot) {
                        return ElevatedButton(
                          onPressed:
                              snapshot.data == true ? presenter!.auth : null,
                          child: Text('Entrar'.toUpperCase()),
                        );
                      },
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                      label: const Text('Criar Conta'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
