import 'package:business_clients_test/injection_container.dart';
import 'package:flutter/material.dart';
import 'app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(App());
}