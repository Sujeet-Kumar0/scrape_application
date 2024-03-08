import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Item',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              AddNewItemForm(),
              SizedBox(height: 20),
              Text(
                'Items List',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ItemsList(),
              ),
            ],
          ),
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
          TextFormField(
            controller: itemNameController,
            decoration: InputDecoration(labelText: 'Item Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter item name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: priceController,
            decoration: InputDecoration(labelText: 'Price'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter price';
              }
              return null;
            },
          ),
          TextFormField(
            controller: imageURLController,
            decoration: InputDecoration(labelText: 'Image URL'),
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
