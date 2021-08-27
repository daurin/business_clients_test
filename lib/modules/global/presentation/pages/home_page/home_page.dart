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
                  color: Colors.red,
                  child: Align(
                    alignment:Alignment.centerRight,
                    child: Icon(Icons.delete_outline,color: Colors.white,),
                  ),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction)async{
                  await onDeleteClient(index);
                  return true;
                },
                child: ListTile(
                  title: Text(clients[index].name),
                  onTap: ()=>onTapClient(context,index),
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
