import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';

/// Point d'entrée principal du SDK Azeoo pour l'affichage du profil.
class AzeooProfileSdk {
  static bool _isInitialized = false;
  static final _appRouter = AppRouter();
  static Future<void>? _initFuture;

  /// Initialise le SDK (DI, etc.) si ce n'est pas déjà fait.
  static Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      _initFuture ??= configureDependencies();
      await _initFuture;
      _isInitialized = true;
    }
  }

  /// Construit un écran complet affichant le profil pour [userId].
  ///
  /// Utilise [AppRouter] pour la navigation interne au module si besoin.
  /// Ici on push directement la route du profil.
  static Widget buildUserProfileScreen({Key? key, required int userId}) {
    return FutureBuilder(
      future: _ensureInitialized(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // Affiche un loader minimaliste pendant l'init du SDK (SharedPrefs, etc.)
          return const Directionality(
            textDirection: TextDirection.ltr,
            child: ColoredBox(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        // On retourne un Router pour bénéficier de AutoRoute
        return MaterialApp.router(
          routerConfig: _appRouter.config(
            deepLinkBuilder: (deepLink) {
              // Force la navigation vers le profil avec l'ID donné au démarrage
              return DeepLink([UserProfileRoute(userId: userId)]);
            },
          ),
        );
      },
    );
  }
}
