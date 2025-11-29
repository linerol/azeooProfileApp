import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_profile_sdk/services/api_service.dart';
import 'package:flutter_profile_sdk/models/user_model.dart';

/// HttpClientAdapter minimaliste qui renvoie une réponse mockée
/// sans faire d’appel réseau.
class FakeHttpClientAdapter implements HttpClientAdapter {
  final ResponseBody Function(RequestOptions options) handler;

  FakeHttpClientAdapter(this.handler);

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return handler(options);
  }
}

void main() {
  group('ApiService.getUserProfile', () {
    test(
      'retourne un User quand le serveur répond 200 avec un JSON valide',
      () async {
        // Prépare un Dio avec un adapter qui renvoie une réponse 200
        final dio = Dio();
        dio.httpClientAdapter = FakeHttpClientAdapter((options) {
          final data = {
            'id': 3,
            'first_name': 'John',
            'last_name': 'Doe',
            'info': 'Profil de test',
          };

          return ResponseBody.fromString(
            jsonEncode(data),
            200,
            headers: {
              Headers.contentTypeHeader: ['application/json'],
            },
          );
        });

        final api = ApiService(dio: dio);

        final user = await api.getUserProfile(3);

        expect(user, isA<User>());
        expect(user!.id, 3);
        expect(user.firstName, 'John');
        expect(user.lastName, 'Doe');
        expect(user.info, 'Profil de test');
      },
    );

    test('retourne null quand le serveur répond 404', () async {
      final dio = Dio();
      dio.httpClientAdapter = FakeHttpClientAdapter((options) {
        return ResponseBody.fromString(
          'Not found',
          404,
          headers: {
            Headers.contentTypeHeader: ['text/plain'],
          },
        );
      });

      final api = ApiService(dio: dio);

      final user = await api.getUserProfile(999);

      expect(user, isNull);
    });
  });
}
