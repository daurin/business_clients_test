import 'package:business_clients_test/modules/global/domain/models/client.dart';
import 'package:business_clients_test/modules/global/domain/models/client_response.dart';

abstract class ClientRepository {
  
  Future<int> addClient({
    required String name,
    required String? knowledge,
  });

  Future<List<Client>> getClients({int offset=0,int limit = 100});

  Future<ClientResponse?> getClientFull(int id);

  Future<void> deleteClient(int id);

  Future<void> editClient(
    int id, {
    String? name,
    String? knowledge,
  });

  Future<void> addAddress({
    required int clientId,
    required String name,
  });

  Future<void> deleteAddress(int id);
}
