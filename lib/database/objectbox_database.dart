import 'package:financas_pessoais_flutter/database/objectbox.g.dart';

class ObjectboxDatabase {
  static Store? _store;

  static Future<Store> getStore() async {
    return _store ??= await openStore();
  }
}
