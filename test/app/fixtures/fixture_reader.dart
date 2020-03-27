import 'dart:io';

String fixture({String filename}) =>
    File('test/app/fixtures/$filename').readAsStringSync();
