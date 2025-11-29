# Azeoo Profile App & SDK

Ce projet est une démonstration technique comprenant un **SDK Flutter** modulaire intégré dans une application **React Native**.

## 🎯 Objectifs

*   Développer un SDK Flutter autonome pour l'affichage de profils utilisateurs.
*   Intégrer ce SDK dans une application hôte React Native.
*   Respecter des contraintes d'architecture avancée, de gestion d'état et de performance.

---

## 🏗️ Architecture & Choix Techniques

### 1. SDK Flutter (`modules/flutter_profile_sdk`)

Le SDK a été conçu pour être **robuste, scalable et testable**.

*   **Clean Architecture :** Le code est divisé en 3 couches distinctes pour séparer les responsabilités :
    *   **Domain :** Entités et interfaces (Business Logic pure). Aucune dépendance externe.
    *   **Data :** Implémentation des repositories, sources de données (API, Cache local).
    *   **Presentation :** UI et gestion d'état (Bloc).
*   **State Management : `flutter_bloc`**
    *   Choisi pour sa séparation stricte entre UI et Logique, et sa gestion prédictible des états (`Loading`, `Loaded`, `Error`).
    *   Permet de gérer facilement le "Pull-to-refresh" et les erreurs.
*   **Navigation : `auto_route`**
    *   Solution de navigation déclarative et typée, plus robuste que le `Navigator` de base.
    *   Permet une gestion fine des Deep Links et des transitions.
*   **Dependency Injection : `get_it` & `injectable`**
    *   Assure le découplage entre les classes.
    *   Facilite le testing et le remplacement des implémentations (ex: Mock vs Real API).
*   **Réseau & Cache :**
    *   **API :** `Dio` pour les appels HTTP (Intercepteurs, gestion fine des erreurs).
    *   **Cache :** `shared_preferences` pour stocker le dernier profil chargé. Permet un affichage hors-ligne (Offline First).
    *   **Images :** `cached_network_image` pour la mise en cache performante des avatars.

### 2. Application React Native (`/`)

L'application hôte sert de démonstrateur pour l'intégration du SDK.

*   **Architecture :** Utilisation de **Context API** (`UserIdContext`) pour gérer l'état global de l'ID utilisateur entre les écrans.
*   **Stockage :** `AsyncStorage` pour persister l'ID utilisateur choisi.
*   **Intégration Native :**
    *   Le SDK Flutter est intégré sous forme de **module AAR compilé**. C'est une approche "Boîte Noire" professionnelle qui isole le code Flutter du cycle de vie React Native.
    *   Communication via **Native Modules** (Android) pour lancer l'activité Flutter.
    *   **Choix d'intégration :** Nous avons opté pour le lancement d'une **Activité Plein Écran** pour le SDK.
        *   *Pourquoi pas un Fragment / Vue intégrée ?* Bien que techniquement possible, l'intégration de Flutter via des Fragments dans une navigation native existante est souvent complexe à maintenir et peut introduire des instabilités (gestion de la pile de navigation hybride, conflits de gestes).
        *   *Avantages de l'Activité :* Cette approche garantit une **isolation totale**, des performances optimales (le moteur Flutter a le contrôle total de la surface de rendu) et une stabilité accrue. C'est le choix privilégié pour intégrer des "features complètes" ou des parcours utilisateurs entiers.
    *   **Note sur la Navigation :**
        *   L'énoncé mentionne deux barres de navigation. Dans notre approche, l'application React Native possède sa propre `BottomTabBar`. Lorsqu'on lance le SDK Flutter, on entre dans un contexte "Plein Écran".
        *   Le SDK gère sa propre navigation interne (si nécessaire) et propose un bouton "Retour" (ou le geste natif Android) pour revenir à l'application hôte, assurant une expérience utilisateur fluide et sans confusion visuelle (pas de double barre de navigation superposée).

---

## 🚀 Installation & Lancement

### Pré-requis
*   Flutter SDK installé et configuré.
*   Node.js & NPM.
*   Environnement Android (Android Studio, SDK, Emulator).

### Étape 1 : Préparer le SDK Flutter

Le SDK doit être compilé en `.aar` pour être consommé par l'app Android.

```bash
cd modules/flutter_profile_sdk

# 1. Installer les dépendances
flutter pub get

# 2. Générer les fichiers de Code (DI, Router, JSON)
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Compiler le module AAR
flutter build aar
```

### Étape 2 : Lancer l'application React Native

Une fois le SDK compilé, revenez à la racine.

```bash
cd ../..

# 1. Installer les dépendances JS
npm install

# 2. Lancer l'application sur Android
npm run android
```

---

## ✨ Fonctionnalités Clés

1.  **Gestion d'erreur & Offline :**
    *   Si le réseau est coupé, le SDK affiche le dernier profil mis en cache.
    *   Si aucun cache n'est disponible, un écran d'erreur convivial invite à vérifier la connexion.
2.  **Pull-to-Refresh :**
    *   Sur l'écran de profil, tirez vers le bas pour forcer le rechargement des données depuis l'API.
3.  **Persistance :**
    *   L'ID utilisateur est sauvegardé côté React Native.
    *   Le profil complet est mis en cache côté Flutter.

---

## 👤 Auteur

**Linerol**
*   [Email](mailto:linerol@icloud.com)
*   [LinkedIn](https://www.linkedin.com/in/linerol/)

Projet réalisé dans le cadre du test technique Azeoo.
