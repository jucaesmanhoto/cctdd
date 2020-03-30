import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

import 'app_controller.dart';
import 'app_widget.dart';
import 'core/local_storage/custom_shared_preferences.dart';
import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_data_source_interface.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_data_source_interface.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/mobx/number_trivia_controller.dart';
import 'features/number_trivia/presentation/pages/number_trivia_page.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((i) => AppController()),

        Bind((i) =>
            NetworkInfo(connectionChecker: i.get<DataConnectionChecker>())),
        Bind((i) => DataConnectionChecker()),
        Bind((i) => InputConverter()),
        //
        //
        //
        Bind((i) => NumberTriviaController(
              inputConverter: i.get<InputConverter>(),
              concrete: i.get<GetConcreteNumberTrivia>(),
              random: i.get<GetRandomNumberTrivia>(),
            )),
        Bind((i) => GetConcreteNumberTrivia(
            repository: i.get<NumberTriviaRepository>())),
        Bind((i) =>
            GetRandomNumberTrivia(repository: i.get<NumberTriviaRepository>())),
        Bind((i) => NumberTriviaRepository(
              networkInfo: i.get<NetworkInfo>(),
              localDataSource: i.get<NumberTriviaLocalDataSource>(),
              remoteDataSource: i.get<NumberTriviaRemoteDataSource>(),
            )),
        Bind(
          (i) => NumberTriviaLocalDataSource(
              sharedPreferences: i.get<CustomSharedPreferences>()),
        ),
        Bind((i) => CustomSharedPreferences()),
        Bind((i) => NumberTriviaRemoteDataSource(client: http.Client())),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => NumberTriviaPage()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
