
import 'package:flutter_profile_sdk/features/profile/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel', () {
    test('fromJson should return a valid model from JSON', () {
      // JSON simulé (structure simplifiée de l'API Azeoo)
      final jsonMap = {
        "id": 123,
        "first_name": "Jean",
        "last_name": "Dupont",
        "info": "Test Info",
        "picture": [
          {"label": "small", "url": "http://example.com/small.jpg"},
          {"label": "large", "url": "http://example.com/large.jpg"}
        ]
      };

      final result = UserModel.fromJson(jsonMap);

      expect(result.id, 123);
      expect(result.firstName, "Jean");
      expect(result.lastName, "Dupont");
      // Vérifie que la logique de priorité 'large' fonctionne
      expect(result.avatarUrl, "http://example.com/large.jpg");
    });

    test('fromJson should fallback to first image if large is missing', () {
      final jsonMap = {
        "id": 123,
        "first_name": "Jean",
        "last_name": "Dupont",
        "info": "",
        "picture": [
          {"label": "small", "url": "http://example.com/small.jpg"}
        ]
      };

      final result = UserModel.fromJson(jsonMap);

      expect(result.avatarUrl, "http://example.com/small.jpg");
    });

    test('toJson should return a JSON map containing proper data', () {
      const userModel = UserModel(
        id: 123,
        firstNameModel: "Jean",
        lastNameModel: "Dupont",
        avatarUrlModel: "http://example.com/large.jpg",
        infoModel: "Info",
      );

      final result = userModel.toJson();

      expect(result["id"], 123);
      expect(result["first_name"], "Jean");
      expect(result["last_name"], "Dupont");
      expect(result["info"], "Info");
      // Le cache local stocke l'URL directement dans le champ 'picture'
      expect(result["picture"], "http://example.com/large.jpg");
    });

    test('fromJson should work with cached data (String picture)', () {
      final jsonMap = {
        "id": 123,
        "first_name": "Jean",
        "last_name": "Dupont",
        "info": "Info",
        "picture": "http://example.com/cached.jpg"
      };

      final result = UserModel.fromJson(jsonMap);

      expect(result.avatarUrl, "http://example.com/cached.jpg");
    });
  });
}
