## Azeoo Profile SDK (Flutter)

SDK Flutter permettant d’afficher le **profil Azeoo d’un utilisateur** à partir de son `userId`.
Ce SDK est conçu pour être intégré dans une application hôte (React Native, Android natif, iOS natif).

---

### 1. Fonctionnalités

- Récupère les données de profil via l’API REST Azeoo :
  - endpoint : `GET https://api.azeoo.dev/v1/users/me`
  - headers : `Accept-Language`, `X-User-Id`, `Authorization` (Bearer)
- Affiche au minimum :
  - **Prénom** / **Nom**
  - **Avatar** (avec fallback si l’image ne charge pas)
  - **Infos** supplémentaires (`info`, ex : "H, 48 - 175 cm / 106,6 kg - Montpellier, France")
- Gère les états de chargement et d’erreur (loader, message d’erreur, bouton “Réessayer”).

---

### 2. Architecture du SDK

- `lib/azeoo_profile_sdk.dart`  
  Point d’entrée public du SDK.

- `lib/ui/user_profile_screen.dart`  
  Écran Flutter complet affichant le profil d’un utilisateur.

- `lib/services/api_service.dart`  
  Service HTTP (Dio) qui appelle l’API Azeoo et retourne un `User`.

- `lib/models/user_model.dart`  
  Modèle `User` mappé sur la réponse JSON de l’API.

---

### 3. API publique du SDK

Le contrat principal du SDK est une méthode statique qui construit un écran Flutter prêt à être affiché :

```startLine:endLine:flutter_profile_sdk/lib/azeoo_profile_sdk.dart
class AzeooProfileSdk {
  static Widget buildUserProfileScreen({Key? key, required int userId}) {
    return UserProfileScreen(key: key, userId: userId);
  }
}
```

**Utilisation côté Flutter (exemple de démo) :**

```startLine:endLine:flutter_profile_sdk/lib/main.dart
void main() => runApp(const AzeooProfileDemoApp());

class AzeooProfileDemoApp extends StatelessWidget {
  const AzeooProfileDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Azeoo Profile SDK Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: AzeooProfileSdk.buildUserProfileScreen(userId: 1),
    );
  }
}
```

Dans un contexte **React Native / Android / iOS**, le host devra simplement afficher ce `Widget` via un `FlutterActivity` / `FlutterViewController` / `FlutterEngine` selon la plateforme.

---

### 4. Détails de l’appel API

Le service utilise **Dio** et reproduit le curl fourni dans l’énoncé :

```startLine:endLine:flutter_profile_sdk/lib/services/api_service.dart
final response = await _dio.get(
  'https://api.azeoo.dev/v1/users/me',
  options: Options(
    headers: {
      'Accept-Language': 'fr-FR',
      'X-User-Id': userId.toString(),
      'Authorization': 'Bearer $_token',
    },
  ),
);
```

> ⚠️ Le token dans ce projet est celui fourni pour le test technique.  
> Dans un contexte réel, il devrait être externalisé (config, secrets, etc.).

---

### 5. Choix techniques / Sécurité

Pour faciliter le test et l'exécution du projet par l'équipe, **j'ai laissé le token API dans un fichier `config.dart`** (ou configuration équivalente dans le code).
Dans un contexte de production réel :

- j'utiliserais `flutter_dotenv` ou `--dart-define` pour **ne pas commiter de secrets** dans le dépôt,
- et je mettrais en place une **obfuscation du code** (et éventuellement du splitting de secrets côté backend) afin de réduire le risque d'exposition.

---

### 6. Lancer le module en local (mode démo Flutter)

1. Se placer dans le dossier `flutter_profile_sdk` :
   ```bash
   cd flutter_profile_sdk
   ```
2. Récupérer les dépendances :
   ```bash
   flutter pub get
   ```
3. Lancer l’app de démo :
   ```bash
   flutter run
   ```

L’app de démo affiche directement le profil de l’utilisateur `userId = 1` (modifiables dans `lib/main.dart`).

---

### 7. Intégration haut niveau dans React Native

(Résumé, les détails dépendront du boilerplate choisi) :

1. Ajouter ce module Flutter dans le projet RN (Flutter module + configuration Android/iOS standard).
2. Côté natif (Android / iOS), créer un écran natif qui instancie un `FlutterEngine` et affiche :
   - `AzeooProfileSdk.buildUserProfileScreen(userId: X)` pour l’`userId` saisi dans l’onglet 1 de l’app RN.
3. Naviguer vers cet écran depuis l’onglet 2 React Native.

La partie 2 du test se concentre sur cette intégration ; ce SDK fournit déjà le `Widget` nécessaire.

---

### 8. Pistes d’amélioration possibles

- Rendre configurable le **token** et l’URL de base (ex. via constructeur ou config externe).
- Ajouter une petite API de thème pour adapter les couleurs / typo au style de l’app hôte.
- Ajouter des tests unitaires sur `User.fromJson` et sur le `UserProfileScreen` (golden tests).

Ce SDK est volontairement simple pour répondre au périmètre du test, tout en étant prêt à être branché à une app React Native. 
