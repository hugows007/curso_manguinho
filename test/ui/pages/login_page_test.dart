import 'dart:async';

import 'package:curso_manguinho/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter? presenter;
  late StreamController<String> emailErrorController;
  late StreamController<String> passwordErrorController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    when(() => presenter!.emailErrorStream)
        .thenAnswer((invocation) => emailErrorController.stream);

    when(() => presenter!.passwordErrorStream)
        .thenAnswer((invocation) => passwordErrorController.stream);

    var loginPage = MaterialApp(
        home: LoginPage(
      presenter: presenter,
    ));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
  });

  testWidgets('Should load with correct initial state', (tester) async {
    await loadPage(tester);

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );

    expect(
      emailTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormFile has only one text child, means it has no errors, since one of the childs is always the label text',
    );

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(Text),
    );

    expect(
      passwordTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormFile has only one text child, means it has no errors, since one of the childs is always the label text',
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onLongPress, null);
  });

  testWidgets('Should call validate with correct values', (tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);

    verify(() => presenter!.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);

    verify(() => presenter!.validatePassword(password));
  });

  testWidgets('Should present erro if email is invalid', (tester) async {
    await loadPage(tester);

    emailErrorController.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Should present no error if email is valid', (tester) async {
    await loadPage(tester);

    expect(
      find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should present no error if email is valid', (tester) async {
    await loadPage(tester);

    emailErrorController.add('');
    await tester.pump();

    expect(
      find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should present erro if password is invalid', (tester) async {
    await loadPage(tester);

    passwordErrorController.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Should present no error if password is valid', (tester) async {
    await loadPage(tester);

    expect(
      find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should present no error if password is valid', (tester) async {
    await loadPage(tester);

    passwordErrorController.add('');
    await tester.pump();

    expect(
      find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });
}
