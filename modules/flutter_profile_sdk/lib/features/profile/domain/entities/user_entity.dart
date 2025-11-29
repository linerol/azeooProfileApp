import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String avatarUrl;
  final String info;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    required this.info,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, avatarUrl, info];
}
