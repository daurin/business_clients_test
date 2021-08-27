import 'package:business_clients_test/modules/global/domain/models/client.dart';
import 'package:business_clients_test/modules/global/presentation/pages/home_page/home_page_presenter.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomePagePresenter {
  @override
  void initState() {
    loadClients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Empresa'),
        actions: [
          ButtonBar(
            children: [],
          )
        ],
      ),
      body: ValueListenableBuilder<List<Client>>(
        valueListenable: clients,
        builder: (BuildContext context, List<Client> clients, Widget? child) {
          return ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: ValueKey(clients[index].id),
                background: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                    ),
                  ),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  await onDeleteClient(index);
                  return true;
                },
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      clients[index].name.length > 0
                          ? clients[index].name.substring(0, 1)
                          : '',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  title: Text(
                    clients[index].name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  onTap: () => onTapClient(context, index),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => onAddClient(context),
      ),
    );
  }
}
