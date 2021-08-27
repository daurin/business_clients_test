import 'package:business_clients_test/modules/global/domain/models/address.dart';

class ClientResponse {
  final int clientId;
  final String name;
  final String? knowledge;
  final List<Address> address;

  ClientResponse({
    required this.clientId,
    required this.name,
    this.knowledge,
    this.address = const [],
  });
}
