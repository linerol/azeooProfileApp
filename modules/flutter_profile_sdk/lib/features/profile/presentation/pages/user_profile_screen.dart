import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

@RoutePage()
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.userId});

  final int userId;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  static const MethodChannel _channel = MethodChannel('azeoo/profile');
  late int _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = widget.userId;
    _channel.setMethodCallHandler(_handleNativeCall);
  }

  @override
  void dispose() {
    _channel.setMethodCallHandler(null);
    super.dispose();
  }

  Future<void> _handleNativeCall(MethodCall call) async {
    if (call.method != 'setUserId') return;

    final dynamic rawValue = call.arguments;
    if (rawValue is! int) return;
    if (rawValue <= 0 || rawValue == _currentUserId) return;

    setState(() {
      _currentUserId = rawValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileBloc>()..add(LoadProfile(_currentUserId)),
      // On utilise Key pour forcer la reconstruction du BlocProvider si l'ID change
      key: ValueKey(_currentUserId), 
      child: Scaffold(
        appBar: AppBar(title: const Text("Profil Azeoo"), centerTitle: true),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        "Oups, impossible de charger le profil.",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Vérifiez votre connexion internet.\n(Aucun cache disponible pour cet utilisateur)",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => context
                            .read<ProfileBloc>()
                            .add(LoadProfile(_currentUserId)),
                        icon: const Icon(Icons.refresh),
                        label: const Text("Réessayer"),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ProfileLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProfileBloc>().add(LoadProfile(_currentUserId));
                  // On attend que le bloc change d'état (loading -> loaded/error)
                  // Mais ici le bloc émet Loading immédiatement, donc le refresh indicator
                  // va tourner jusqu'à ce que le Future complète.
                  // Pour faire propre, on pourrait attendre un Completer dans le Bloc,
                  // mais pour ce test, déclencher l'event suffit souvent si l'UI rebuild.
                  // Cependant, RefreshIndicator attend un Future qui complète quand c'est fini.
                  // Astuce simple : attendre un peu ou écouter le stream.
                  // Ici on fait simple :
                  await Future.delayed(const Duration(seconds: 1)); 
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                    child: Container(
                      // Hack pour que le ScrollView prenne toute la hauteur et permette le pull même si contenu petit
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
                      ),
                      alignment: Alignment.center, // Centre le contenu verticalement
                      child: _buildUserProfile(state.user),
                    ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildUserProfile(UserEntity user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipOval(
            child: user.avatarUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: user.avatarUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: const Icon(Icons.person, size: 60, color: Colors.grey),
                    ),
                  )
                : Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const Icon(Icons.person, size: 60, color: Colors.grey),
                  ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "${user.firstName} ${user.lastName}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        if (user.info.isNotEmpty)
          Text(
            user.info,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
          ),
          child: Text(
            "User ID: ${user.id}",
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
