import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrape_application/components/custom_text_field.dart';
import 'package:scrape_application/components/side_bar.dart';

import '../../components/utils.dart';
import '../../model/item_data.dart';
import '../../viewmodels/rates_screen_model.dart';

class RatesUpdateScreen extends StatefulWidget {
  const RatesUpdateScreen({super.key});

  @override
  State<RatesUpdateScreen> createState() => _RatesUpdateScreenState();
}

class _RatesUpdateScreenState extends State<RatesUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          children: [
            if (kIsWeb)
              Expanded(
                flex: 1,
                child: const SideMenu(),
              ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add New Item',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    AddNewItemForm(),
                    SizedBox(height: 10),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Items List',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        ItemsListStream(),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddNewItemForm extends StatefulWidget {
  @override
  _AddNewItemFormState createState() => _AddNewItemFormState();
}

class _AddNewItemFormState extends State<AddNewItemForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageURLController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            context: context,
            controller: itemNameController,
            label: 'Item Name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter item name';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          CustomTextField(
            context: context,
            controller: priceController,
            label: 'Price',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter price';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          CustomTextField(
            context: context,
            controller: imageURLController,
            label: 'Image URL',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter image URL';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Perform add operation here
                final newItem = ItemData(
                  itemName: itemNameController.text,
                  price: priceController.text,
                  imageURL: imageURLController.text,
                );
                Provider.of<RatesScreenViewModel>(context, listen: false)
                    .addItemToDB(newItem);
                // Clear text fields after adding
                itemNameController.clear();
                priceController.clear();
                imageURLController.clear();
              }
            },
            child: Text('Add Item'),
          ),
        ],
      ),
    );
  }
}

class ItemsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RatesScreenViewModel>(context);
    return ListView.builder(
      itemCount: viewModel.filteredItems.length,
      itemBuilder: (context, index) {
        final item = viewModel.filteredItems[index];
        return ListTile(
          title: Text(item.itemName),
          subtitle: Text('Price: ${item.price}'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Perform delete operation here
              Provider.of<RatesScreenViewModel>(context, listen: false)
                  .deleteItemFromDB("item.id");
            },
          ),
        );
      },
    );
  }
}

class ItemsListStream extends StatefulWidget {
  @override
  State<ItemsListStream> createState() => _ItemsListStreamState();
}

class _ItemsListStreamState extends State<ItemsListStream> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('rates').snapshots();
    return Scrollbar(
      child: SizedBox(
        height: 550,
        child: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return buildProgressIndicator();
            }

            return Scrollbar(
              child: SizedBox(
                height: 600,
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['itemName']),
                      subtitle: Text(data['price'].toString()),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Perform delete operation here
                          Provider.of<RatesScreenViewModel>(context,
                                  listen: false)
                              .deleteItemFromDB(document.id);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
