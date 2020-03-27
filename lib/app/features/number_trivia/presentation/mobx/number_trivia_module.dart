import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/util/input_converter.dart';
import '../../data/datasources/number_trivia_local_data_source_interface.dart';
import '../../data/datasources/number_trivia_remote_data_source_interface.dart';
import '../../data/repositories/number_trivia_repository.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';
import '../pages/number_trivia_page.dart';
import 'number_trivia_controller.dart';

class NumberTriviaModule extends ChildModule {
  @override
  List<Bind> get binds => [];

  @override
  List<Router> get routers => [
        Router('/', child: (_, args) => NumberTriviaPage()),
      ];
}
