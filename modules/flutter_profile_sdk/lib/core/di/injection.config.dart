// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/profile/data/datasources/profile_local_datasource.dart'
    as _i1046;
import '../../features/profile/data/datasources/profile_remote_datasource.dart'
    as _i327;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/presentation/bloc/profile_bloc.dart' as _i469;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i1046.ProfileLocalDataSource>(
        () => _i1046.ProfileLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i327.ProfileRemoteDataSource>(
        () => _i327.ProfileRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
    gh.lazySingleton<_i894.ProfileRepository>(() => _i334.ProfileRepositoryImpl(
          gh<_i327.ProfileRemoteDataSource>(),
          gh<_i1046.ProfileLocalDataSource>(),
        ));
    gh.factory<_i469.ProfileBloc>(
        () => _i469.ProfileBloc(gh<_i894.ProfileRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
