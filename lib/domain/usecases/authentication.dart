import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenthicationParams params);
}

class AuthenthicationParams {
  final String email;
  final String secret;

  AuthenthicationParams({
    required this.email,
    required this.secret,
  });

  Map toJson() => {'email': email, 'password': secret};
}
