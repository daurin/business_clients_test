import 'package:business_clients_test/modules/global/domain/models/address.dart';
import 'package:business_clients_test/modules/global/domain/models/client.dart';
import 'package:business_clients_test/modules/global/domain/models/client_response.dart';
import 'package:business_clients_test/modules/global/domain/repositories/client_repository.dart';
import 'package:sqflite/sqflite.dart';

class ClientRepositorySqliteImpl implements ClientRepository {
  final Database db;

  ClientRepositorySqliteImpl(this.db);

  @override
  Future<int> addClient({
    required String name,
    required String? knowledge,
  }) async {
    int id=await db.insert(
      'CLIENT',
      {
        'name': name,
        'knowledge': knowledge,
      },
    );
    return id;
  }

  @override
  Future<List<Client>> getClients({int offset = 0, int limit = 50}) async {
    List<Map<String, Object?>> res =
        await db.query('CLIENT', limit: 50, orderBy: 'id');
    if (res.length > 0) {
      return res
          .map((e) => Client(
                id: int.parse((e['id'] ?? '').toString()),
                name: (e['name'] ?? '').toString(),
                knowledge: (e['knowledge'] ?? '').toString(),
              ))
          .toList();
    }
    return [];
  }

  @override
  Future<ClientResponse?> getClientFull(int id) async {
    List<Map<String, Object?>> res = await db.query(
      'CLIENT',
      where: 'id=?',
      whereArgs: [id],
    );

    Client client;
    List<Address> addresses = [];
    if (res.length > 0) {
      client = res
          .map((e) => Client(
                id: int.parse((e['id'] ?? '').toString()),
                name: (e['name'] ?? '').toString(),
                knowledge: (e['knowledge'] ?? '').toString(),
              ))
          .first;
    } else
      return null;
    res = await db.query(
      'ADDRESS',
      where: 'client_id=?',
      whereArgs: [id],
      limit: 50,
      orderBy: 'id',
    );
    if (res.length > 0) {
      addresses = res
          .map((e) => Address(
                id: int.parse((e['id'] ?? '').toString()),
                name: (e['name'] ?? '').toString(),
                clientId: int.parse((e['client_id'] ?? '').toString()),
              ))
          .toList();
    }

    return ClientResponse(
      clientId: client.id,
      name: client.name,
      knowledge: client.knowledge,
      address: addresses,
    );
  }

  @override
  Future<void> editClient(int id, {String? name, String? knowledge}) async {
    Map<String, dynamic> values = {};
    if (name != null) values.addAll({'name': name});
    if (knowledge != null) values.addAll({'knowledge': knowledge});
    await db.update(
      'CLIENT',
      values,
      where: 'id=?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteClient(int id) async {
    await db.delete(
      'ADDRESS',
      where: 'client_id = ?',
      whereArgs: [id],
    );
    await db.delete(
      'CLIENT',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> addAddress({required int clientId, required String name}) async {
    await db.insert('ADDRESS', {
      'client_id': clientId,
      'name': name,
    });
  }

  @override
  Future<void> deleteAddress(int id) async {
    await db.delete(
      'ADDRESS',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
