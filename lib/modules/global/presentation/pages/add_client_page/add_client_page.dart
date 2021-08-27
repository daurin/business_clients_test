import 'package:business_clients_test/modules/global/domain/models/address.dart';
import 'package:business_clients_test/modules/global/presentation/pages/add_client_page/add_client_page_presenter.dart';
import 'package:flutter/material.dart';

class AddClientPage extends StatefulWidget {
  final int? clientId;
  const AddClientPage({
    Key? key,
    this.clientId,
  }) : super(key: key);

  @override
  _AddClientPageState createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage>
    with AddClientPagePresenter {
  @override
  void initState() {
    init(widget.clientId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editMode?'Edit Client': 'New Client'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'General',
              ),
              Tab(
                text: 'Address',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFragment1(),
            _buildFragment2(),
          ],
        ),
      ),
    );
  }

  Widget _buildFragment1() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: nameTextController,
            maxLength: 30,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: knowledgeTextController,
            maxLength: 300,
            minLines: 6,
            maxLines: 12,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              labelText: 'Knowledge',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              )),
              child: Text('Save'),
              onPressed: () =>save(context),
            ),
          )
        ],
      ),
    );
  }

  ListView _buildFragment2() {
    return ListView(
      children: [
        ValueListenableBuilder(
          valueListenable: addresses,
          builder:
              (BuildContext context, List<Address> addresses, Widget? child) {
            return Column(
              children: addresses
                  .map(
                    (e) => ListTile(
                      title: Text(e.name),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => onDeleteAddress(e.id),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 8,
            )),
            child: Text('Add Address'),
            onPressed: () => onAddAddress(context),
          ),
        ),
      ],
    );
  }
}
