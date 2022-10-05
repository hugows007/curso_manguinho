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

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct values', () async {
    final params = AuthenthicationParams(
        email: faker.internet.email(), secret: faker.internet.password());

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

    final params = AuthenthicationParams(
        email: faker.internet.email(), secret: faker.internet.password());

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
