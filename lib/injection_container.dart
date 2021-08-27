import 'dart:io';
import 'package:business_clients_test/modules/global/domain/usecases/client_use_cases.dart';
import 'package:path/path.dart';
import 'package:business_clients_test/modules/global/data/repositories/client_repository_sqlite_impl.dart';
import 'package:business_clients_test/modules/global/domain/repositories/client_repository.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  // Uses cases
  getIt.registerLazySingleton(() => ClientUseCases(getIt()));

  // Repositories
  getIt.registerLazySingleton<ClientRepository>(
      () => ClientRepositorySqliteImpl(getIt()));

  // External
  Database db = await _initDatabase();
  getIt.registerLazySingleton(() => db);
}

Future<Database> _initDatabase() async {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  }

  String path = join(await getDatabasesPath(), 'business_clients.db');
  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      try {
        String script = await rootBundle.loadString('lib/db/db_script.sql');
        print(script);
        await db.execute(script);
        int clientId = await db.insert(
          'CLIENT',
          {
            'name': 'Daurin Lora Mejia',
            'knowledge': '''- Flutter
- Nodejs
- Typescript
- React
- Design Patters''',
          },
        );
        await db.insert(
          'ADDRESS',
          {
            'client_id': clientId,
            'name': 'Island nowhere',
          },
        );
      } catch (err) {
        print(err);
      }
    },
  );
}
