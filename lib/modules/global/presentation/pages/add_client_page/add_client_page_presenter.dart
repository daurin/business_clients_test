import 'package:business_clients_test/modules/global/domain/models/address.dart';
import 'package:business_clients_test/modules/global/domain/models/client_response.dart';
import 'package:business_clients_test/modules/global/domain/usecases/client_use_cases.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AddClientPagePresenter {
  int? _clientId;
  late bool editMode;
  ClientUseCases _clientService = GetIt.instance();

  late TextEditingController nameTextController, knowledgeTextController;

  ValueNotifier<List<Address>> addresses = ValueNotifier([]);

  void init([int? clientId]) async {
    nameTextController = TextEditingController();
    knowledgeTextController = TextEditingController();

    this._clientId = clientId;
    editMode = clientId != null;
    if (editMode) {
      ClientResponse? clientResponse =
          await _clientService.getClientFull(_clientId!);
      if (clientResponse != null) {
        nameTextController.text = clientResponse.name;
        knowledgeTextController.text = clientResponse.knowledge ?? '';
        addresses.value = clientResponse.address;
      }
    }
  }

  void onDeleteAddress(int id) async {
    await _clientService.deleteAddress(id);
    addresses.value =
        addresses.value.where((element) => element.id != id).toList();
  }

  void onAddAddress(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        TextEditingController addressTextController = TextEditingController();
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text('New Address'),
              content: SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: addressTextController,
                  maxLength: 100,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Add'),
                  onPressed: () async {
                    if (editMode) {
                      await _clientService.addAddress(
                        clientId: _clientId!,
                        name: addressTextController.text,
                      );
                      _clientService.getClientFull(_clientId!).then((value) {
                        addresses.value = value!.address;
                      });
                    } else {
                      addresses.value = [
                        ...addresses.value,
                        Address(
                          clientId: _clientId!,
                          name: addressTextController.text,
                          id: DateTime.now().millisecondsSinceEpoch,
                        )
                      ];
                    }
                    Navigator.pop(context, true);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void save(BuildContext context) async {
    if (editMode) {
      await _clientService.editClient(
        _clientId!,
        name: nameTextController.text,
        knowledge: knowledgeTextController.text,
      );
    } else {
      await _clientService.addClient(
        name: nameTextController.text,
        knowledge: knowledgeTextController.text,
      );
      for (Address item in addresses.value) {
        await _clientService.addAddress(
          clientId: item.clientId,
          name: item.name,
        );
      }
    }
    Navigator.pop(context, true);
  }
}
