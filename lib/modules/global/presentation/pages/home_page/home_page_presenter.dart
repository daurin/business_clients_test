import 'package:business_clients_test/modules/global/domain/models/client.dart';
import 'package:business_clients_test/modules/global/domain/usecases/client_use_cases.dart';
import 'package:business_clients_test/modules/global/presentation/pages/add_client_page/add_client_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePagePresenter {
  final ClientUseCases _clientService = GetIt.instance();
  final ValueNotifier<List<Client>> clients = ValueNotifier([]);

  void loadClients() async {
    clients.value = await _clientService.getClients();
  }

  void onAddClient(BuildContext context) async {
    bool? edited = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddClientPage(),
      ),
    );
    if (edited ?? false) loadClients();
  }

  void onTapClient(BuildContext context, int index) async {
    bool? edited = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddClientPage(
          clientId: clients.value[index].id,
        ),
      ),
    );
    if (edited ?? false) loadClients();
  }

  Future<void> onDeleteClient(int index) async {
    int id = clients.value[index].id;
    await _clientService.deleteClient(id);
    clients.value.removeWhere((e) => e.id == id);
  }
}
