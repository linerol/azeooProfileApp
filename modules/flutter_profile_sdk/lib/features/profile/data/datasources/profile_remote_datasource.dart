import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/config.dart';
import '../models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel?> getUserProfile(int userId);
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<UserModel?> getUserProfile(int userId) async {
    try {
      final response = await _dio.get(
        '${Config.apiUrl}/users/me',
        options: Options(
          headers: {
            'Accept-Language': 'fr-FR',
            'X-User-Id': userId.toString(),
            'Authorization': 'Bearer ${Config.apiToken}',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data);
      }

      if (response.statusCode == 404) {
        return null;
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException {
      rethrow;
    }
  }
}
