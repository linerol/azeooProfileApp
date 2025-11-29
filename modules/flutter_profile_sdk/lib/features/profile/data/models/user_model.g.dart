// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num).toInt(),
      firstNameModel: json['first_name'] as String,
      lastNameModel: json['last_name'] as String,
      avatarUrlModel: UserModel._avatarFromPictureList(json['picture']),
      infoModel: json['info'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstNameModel,
      'last_name': instance.lastNameModel,
      'info': instance.infoModel,
      'picture': instance.avatarUrlModel,
    };
