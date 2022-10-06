import 'package:curso_manguinho/data/http/http.dart';
import 'package:curso_manguinho/infra/http/http.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late Uri uri;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    uri = Uri.parse(faker.internet.httpUrl());
    registerFallbackValue(Uri());
  });

  group('post', () {
    When mockRequest() => when(() => client.post(any(),
        body: any(named: 'body'), headers: any(named: 'headers')));

    void mockResponse(int statusCode,
        {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call post with correct values', () async {
      await sut.request(uri: uri, method: 'post', body: {
        'any_key': 'any_value',
      });

      verify(() => client.post(
            uri,
            headers: any(named: 'headers'),
            body: '{"any_key":"any_value"}',
          ));
    });

    test('Should call post without body', () async {
      await sut.request(uri: uri, method: 'post');

      verify(() => client.post(
            any(),
            headers: any(named: 'headers'),
          ));
    });

    test('Should return data if post returns 200', () async {
      final response = await sut.request(uri: uri, method: 'post');

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if post returns 200 with no data', () async {
      mockResponse(200, body: '');

      final response = await sut.request(uri: uri, method: 'post');

      expect(response, null);
    });

    test('Should return null if post returns 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(uri: uri, method: 'post');

      expect(response, null);
    });

    test('Should return null if post returns 204 with data', () async {
      mockResponse(204);

      final response = await sut.request(uri: uri, method: 'post');

      expect(response, null);
    });

    test('Should return BadRequestError if post returns 400', () async {
      mockResponse(400, body: '');

      final future = sut.request(uri: uri, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return BadRequestError if post returns 400', () async {
      mockResponse(400);

      final future = sut.request(uri: uri, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return UnauthorizedError if post returns 401', () async {
      mockResponse(401);

      final future = sut.request(uri: uri, method: 'post');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return ForbiddenError if post returns 403', () async {
      mockResponse(403);

      final future = sut.request(uri: uri, method: 'post');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return NotFoundError if post returns 404', () async {
      mockResponse(404);

      final future = sut.request(uri: uri, method: 'post');

      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return ServerError if post returns 500', () async {
      mockResponse(500);

      final future = sut.request(uri: uri, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
