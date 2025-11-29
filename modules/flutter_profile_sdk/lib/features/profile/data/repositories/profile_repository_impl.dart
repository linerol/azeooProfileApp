import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;

  ProfileRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Exception, UserEntity>> getUserProfile(int userId) async {
    try {
      // 1. Tentative d'appel réseau
      final userModel = await _remoteDataSource.getUserProfile(userId);
      
      if (userModel != null) {
        // 2. Si succès, on met en cache
        await _localDataSource.cacheUserProfile(userModel);
        return Right(userModel);
      } else {
        // 404 Not Found : pas la peine de chercher dans le cache
        return Left(Exception("User not found"));
      }
    } catch (e) {
      // 3. Si erreur réseau (ou autre), on tente de récupérer le cache
      try {
        final cachedUser = await _localDataSource.getLastUserProfile(userId);
        if (cachedUser != null) {
          return Right(cachedUser);
        }
      } catch (_) {
        // Ignorer les erreurs de cache
      }
      
      // Si pas de cache, on remonte l'erreur initiale
      return Left(Exception(e.toString()));
    }
  }
}
