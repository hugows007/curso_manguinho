import 'package:curso_manguinho/validation/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('Should return null if value is not empty', () {
    expect(sut.validate('any_value'), null);
  });

  test('Should return null if value is empty', () {
    expect(sut.validate(''), 'Campo obrigatório');
  });

  test('Should return null if value is empty', () {
    expect(sut.validate(null), 'Campo obrigatório');
  });
}
