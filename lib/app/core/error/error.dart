import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Error extends Equatable {
  final String message;

  Error({
    @required this.message,
  }) {
    print(message);
  }

  @override
  List<Object> get props => [message];
}
