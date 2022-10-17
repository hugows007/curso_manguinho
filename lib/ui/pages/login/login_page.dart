import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../pages.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter? presenter;

  const LoginPage({
    this.presenter,
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter!.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showCustomLoading(context);
            } else {
              hideLoading(context);
            }
          });

          widget.presenter!.mainErrorStream.listen((error) {
            if (error.isNotEmpty) {
              showErrorMessage(context, error);
            }
          });

          return SingleChildScrollView(
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
                            stream: widget.presenter!.emailErrorStream,
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
                                onChanged: widget.presenter!.validateEmail,
                              );
                            }),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 32),
                          child: StreamBuilder<String>(
                              stream: widget.presenter!.passwordErrorStream,
                              builder: (context, snapshot) {
                                return TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Senha',
                                    errorText: snapshot.data?.isEmpty == true
                                        ? null
                                        : snapshot.data,
                                    icon: Icon(
                                      Icons.lock,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                  ),
                                  obscureText: true,
                                  onChanged: widget.presenter!.validatePassword,
                                );
                              }),
                        ),
                        StreamBuilder<bool>(
                          stream: widget.presenter!.isFormValidStream,
                          builder: (context, snapshot) {
                            return ElevatedButton(
                              onPressed: snapshot.data == true
                                  ? widget.presenter!.auth
                                  : null,
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
          );
        },
      ),
    );
  }
}
