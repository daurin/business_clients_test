import 'package:business_clients_test/modules/global/domain/models/client.dart';
import 'package:business_clients_test/modules/global/domain/models/client_response.dart';
import 'package:business_clients_test/modules/global/domain/repositories/client_repository.dart';

class ClientUseCases implements ClientRepository {
  late final ClientRepository _repository;

  ClientUseCases(ClientRepository repository){
    _repository=repository;
  }

  @override
  Future<int> addClient({required String name, required String? knowledge}) {
    return _repository.addClient(name: name, knowledge: knowledge);
  }

  @override
  Future<ClientResponse?> getClientFull(int id) {
    return _repository.getClientFull(id);
  }

  @override
  Future<List<Client>> getClients({int offset = 0, int limit = 10}) {
    return _repository.getClients(
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<void> editClient(int id, {String? name, String? knowledge}) {
    return _repository.editClient(
      id,
      name: name,
      knowledge: knowledge,
    );
  }

  @override
  Future<void> deleteClient(int id) {
    return _repository.deleteClient(id);
  }

  @override
  Future<void> addAddress({required int clientId, required String name}) {
    return _repository.addAddress(clientId: clientId, name: name);
  }

  @override
  Future<void> deleteAddress(int id) {
    return _repository.deleteAddress(id);
  }
}
