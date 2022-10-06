import 'package:curso_manguinho/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:curso_manguinho/data/usecases/usescases.dart';
import 'package:curso_manguinho/data/http/http.dart';
import 'package:curso_manguinho/domain/usecases/authentication.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late Uri uri;
  late AuthenthicationParams params;

  Map mockValidData() => {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      };

  When mockRequest() => when(() => httpClient.request(
      uri: any(named: 'uri'),
      method: any(named: 'method'),
      body: captureAny(named: 'body')));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    registerFallbackValue(Uri());
    httpClient = HttpClientSpy();
    uri = Uri.parse(faker.internet.httpUrl());
    sut = RemoteAuthentication(httpClient: httpClient, url: uri);

    params = AuthenthicationParams(
        email: faker.internet.email(), secret: faker.internet.password());

    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.auth(params);

    verify(() => httpClient.request(
          uri: uri,
          method: 'post',
          body: {
            'email': params.email,
            'password': params.secret,
          },
        ));
  });

  test('Should throw UnexpectedError if HttpClient return 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 401', () async {
    mockHttpError(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if HttpClient return 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);

    final account = await sut.auth(params);

    expect(account.token, validData['accessToken']);
  });

  test(
      'Should throw UnexpectedError if HttpClient return 200 with invalid data',
      () async {
    mockHttpData({
      'invalid_key': 'invalid_value',
    });

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
