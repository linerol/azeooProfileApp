import 'package:flutter/material.dart';
import 'azeoo_profile_sdk.dart';

void main() {
  // Lance directement l'écran du SDK pour le test standalone.
  // Vous pouvez changer l'ID ici pour tester différents utilisateurs.
  runApp(const AzeooProfileDemoApp());
}

class AzeooProfileDemoApp extends StatelessWidget {
  const AzeooProfileDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Le SDK retourne déjà un MaterialApp.router, donc on peut le retourner directement.
    return AzeooProfileSdk.buildUserProfileScreen(userId: 3);
  }
}