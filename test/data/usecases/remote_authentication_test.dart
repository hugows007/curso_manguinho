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
  late String url;
  late AuthenthicationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);

    params = AuthenthicationParams(
        email: faker.internet.email(), secret: faker.internet.password());
  });

  test('Should call HttpClient with correct values', () async {
    when(() =>
        httpClient.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
            body: captureAny(named: 'body'))).thenAnswer((_) async => {
          'accessToken': faker.guid.guid(),
          'name': faker.person.name(),
        });

    await sut.auth(params);

    verify(() => httpClient.request(
          url: url,
          method: 'post',
          body: {
            'email': params.email,
            'password': params.secret,
          },
        ));
  });

  test('Should throw UnexpectedError if HttpClient return 400', () async {
    when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: captureAny(named: 'body'))).thenThrow(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 404', () async {
    when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: captureAny(named: 'body'))).thenThrow(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 500', () async {
    when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: captureAny(named: 'body'))).thenThrow(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 401', () async {
    when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: captureAny(named: 'body'))).thenThrow(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if HttpClient return 200', () async {
    final accessToken = faker.guid.guid();
    when(() =>
        httpClient.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
            body: captureAny(named: 'body'))).thenAnswer((_) async => {
          'accessToken': accessToken,
          'name': faker.person.name(),
        });

    final account = await sut.auth(params);

    expect(account.token, accessToken);
  });
}
