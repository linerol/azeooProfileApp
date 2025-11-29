import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  @JsonKey(name: 'first_name')
  final String firstNameModel;
  
  @JsonKey(name: 'last_name')
  final String lastNameModel;

  @JsonKey(name: 'info')
  final String infoModel;

  @JsonKey(name: 'picture', fromJson: _avatarFromPictureList)
  final String avatarUrlModel;

  const UserModel({
    required super.id,
    required this.firstNameModel,
    required this.lastNameModel,
    required this.avatarUrlModel,
    required this.infoModel,
  }) : super(
          firstName: firstNameModel,
          lastName: lastNameModel,
          avatarUrl: avatarUrlModel,
          info: infoModel,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  static String _avatarFromPictureList(dynamic pictures) {
    // Cas 1: Cache local (String directe)
    if (pictures is String) {
      return pictures;
    }
    // Cas 2: API (Liste d'objets)
    if (pictures is List && pictures.isNotEmpty) {
      final List<Map<String, dynamic>> pics = pictures
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      Map<String, dynamic>? largeImg;
      try {
        largeImg = pics.firstWhere((element) => element['label'] == 'large');
      } on StateError {
        largeImg = null;
      }

      if (largeImg != null) {
        return (largeImg['url'] as String?) ?? '';
      } else {
        return (pics.first['url'] as String?) ?? '';
      }
    }
    return '';
  }
}
