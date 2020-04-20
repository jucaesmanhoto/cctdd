import 'package:flutter/material.dart';
import 'package:cctdd/app/app_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async => runApp(ModularApp(
    module:
        AppModule(sharedPreferences: await SharedPreferences.getInstance())));
