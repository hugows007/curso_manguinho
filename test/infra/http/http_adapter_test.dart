import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({
    required String url,
    required String method,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    await client.post(Uri.parse(url), headers: headers);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late Uri uri;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    uri = Uri.parse(faker.internet.httpUrl());
  });

  group('post', () {
    test('Should call post with correct values', () async {
      await sut.request(url: uri.path, method: 'post');

      verify(() => client.post(
            uri,
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });
  });
}
