import 'package:curso_manguinho/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('Should return null if email is empty', () {
    expect(sut.validate(''), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate(null), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate('joao.gomes@gmail.com'), null);
  });

  test('Should return error if email is valid', () {
    expect(sut.validate('joao.gomes'), 'Campo inválido');
  });
}
