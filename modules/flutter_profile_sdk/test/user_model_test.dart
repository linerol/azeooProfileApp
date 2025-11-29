import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_profile_sdk/models/user_model.dart';

void main() {
  group('User.fromJson', () {
    test('mappe correctement un JSON de profil utilisateur minimal', () {
      // JSON inspiré de text.json fourni pour le test
      final json = {
        'id': 1,
        'first_name': 'Samuel',
        'last_name': 'Verdier',
        'info': 'H, 48 - 175 cm / 106,6 kg - Montpellier, France',
        'picture': [
          {
            'url': 'https://cdn-staging.azeoo.com/users/1/thumbnail/xxx.jpg',
            'label': 'thumbnail',
          },
          {
            'url': 'https://cdn-staging.azeoo.com/users/1/large/yyy.jpg',
            'label': 'large',
          },
        ],
      };

      final user = User.fromJson(json);

      expect(user.id, 1);
      expect(user.firstName, 'Samuel');
      expect(user.lastName, 'Verdier');
      expect(user.info, 'H, 48 - 175 cm / 106,6 kg - Montpellier, France');
      // On vérifie qu'on a bien sélectionné l'image "large"
      expect(
        user.avatarUrl,
        'https://cdn-staging.azeoo.com/users/1/large/yyy.jpg',
      );
    });

    test('gère l’absence d’image et de champs optionnels', () {
      final json = {
        'id': 42,
        'first_name': 'Jane',
        'last_name': 'Doe',
        // pas de "picture", pas de "info"
      };

      final user = User.fromJson(json);

      expect(user.id, 42);
      expect(user.firstName, 'Jane');
      expect(user.lastName, 'Doe');
      expect(user.avatarUrl, isEmpty);
      expect(user.info, isEmpty);
    });
  });
}
