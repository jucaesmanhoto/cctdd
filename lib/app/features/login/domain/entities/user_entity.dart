import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class UserEntity extends Equatable {
  final String name;
  final String password;

  UserEntity({
    @required this.name,
    @required this.password,
  });
  @override
  List<Object> get props => [name, password];
}
