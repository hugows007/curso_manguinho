import 'package:curso_manguinho/presentation/protocols/protocols.dart';
import 'package:curso_manguinho/validation/protocols/field_validation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String? validate({required String field, required String value}) {
   return null;
  }
}

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  late ValidationComposite sut;

  setUp(() {

  });

  test('Should return null if all validation returns null or empty', () {
    final validation1 = FieldValidationSpy();
    when(() => validation1.field).thenReturn('any_field');
    when(() => validation1.validate(any())).thenReturn(null);

    final validation2 = FieldValidationSpy();
    when(() => validation2.field).thenReturn('any_field');
    when(() => validation2.validate(any())).thenReturn('');
    sut = ValidationComposite([validation1, validation2]);

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, null);
  });
}
