# Azeoo Profile SDK (Flutter)

SDK Flutter modulaire permettant d’afficher le **profil Azeoo d’un utilisateur** à partir de son `userId`.
Ce SDK est conçu pour être intégré dans une application hôte (React Native, Android natif, iOS natif) en tant que module autonome.

---

## 🏗️ Architecture & Choix Techniques

Ce SDK respecte les principes de **Clean Architecture** et de **Scalabilité** exigés par le test.

### 1. Clean Architecture
Le code est structuré en 3 couches distinctes (`lib/features/profile/`) :
*   **Domain** (`domain/`) : Contient les Entités (`UserEntity`) et les Interfaces de Repository (`ProfileRepository`). C'est le cœur de la logique métier, indépendant de toute librairie externe.
*   **Data** (`data/`) : Implémente l'accès aux données.
    *   `ProfileRemoteDataSource` : Appels API via **Dio**.
    *   `ProfileLocalDataSource` : Cache local via **SharedPreferences**.
    *   `ProfileRepositoryImpl` : Orchestre la récupération (Cache puis API, ou API puis Cache).
*   **Presentation** (`presentation/`) : Contient l'UI et la gestion d'état.
    *   `ProfileBloc` : Gestion d'état prédictible.
    *   `UserProfileScreen` : Vue passive qui réagit aux états du Bloc.

### 2. State Management : `flutter_bloc`
J'ai choisi **Bloc** pour :
*   Séparer strictement l'UI de la logique métier.
*   Gérer facilement les états complexes (`Loading`, `Loaded`, `Error`).
*   Faciliter le testabilité (les Blocs sont faciles à tester unitairement).
*   *Note : `setState` n'est pas utilisé pour la logique métier.*

### 3. Navigation : `auto_route`
J'ai choisi **AutoRoute** pour :
*   La navigation déclarative et fortement typée.
*   La gestion simplifiée des arguments (passer l'`userId` de manière sûre).
*   La scalabilité : facile d'ajouter de nouvelles pages ou des Deep Links.

### 4. Dependency Injection : `get_it` & `injectable`
*   Permet de découpler les classes (le Bloc ne connaît pas l'implémentation du Repository, juste l'interface).
*   Facilite l'injection de mocks pour les tests.
*   Le module `RegisterModule` gère les dépendances tierces comme `Dio` et `SharedPreferences`.

### 5. Cache & Offline First
*   Le SDK utilise `shared_preferences` pour stocker le JSON du dernier profil chargé.
*   **Stratégie :**
    1.  Tente de charger depuis l'API.
    2.  Si succès : sauvegarde en cache et affiche.
    3.  Si erreur (ex: pas de réseau) : tente de charger depuis le cache.
    4.  Si cache vide : affiche une erreur conviviale.

---

## 🛠️ Installation & Développement

### Pré-requis
*   Flutter SDK
*   `build_runner` pour la génération de code (AutoRoute, Injectable, JsonSerializable).

### Commandes utiles

```bash
# Installer les dépendances
flutter pub get

# Générer les fichiers de code (DI, Router, Models)
flutter pub run build_runner build --delete-conflicting-outputs

# Lancer les tests
flutter test

# Lancer l'application de démo (standalone)
flutter run
```

---

## 📦 Intégration (Build AAR)

Pour intégrer ce SDK dans une application hôte (Android/React Native), il faut le compiler en AAR :

```bash
flutter build aar
```

Cela génère un dépôt Maven local dans `build/host/outputs/repo` qui peut être référencé par l'application hôte.

---

## 📝 API Publique

Le point d'entrée unique est la classe `AzeooProfileSdk` :

```dart
// Affiche l'écran de profil pour l'utilisateur donné
AzeooProfileSdk.buildUserProfileScreen(userId: 1);
```

Cette méthode gère l'initialisation de l'injection de dépendances (asynchrone) et retourne un `Widget` autonome (`MaterialApp.router`).

---

## 👤 Auteur

Projet réalisé dans le cadre du test technique Azeoo.
