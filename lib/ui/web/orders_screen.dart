import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Orders'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: OrderList(),
        ),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Orders').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return FutureBuilder<QuerySnapshot>(
              future: documents[index].reference.collection('order').get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> nestedSnapshot) {
                if (nestedSnapshot.hasError) {
                  return Text('Error fetching nested data');
                }

                if (nestedSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                List<QueryDocumentSnapshot> nestedDocs =
                    nestedSnapshot.data!.docs;
                if (nestedDocs.isEmpty) {
                  return SizedBox(); // If there are no nested documents, return an empty SizedBox
                }

                var nestedDocData =
                    nestedDocs.first.data() as Map<String, dynamic>;
                return OrderItem(
                  userId: documents[index].id,
                  selectedWeight: nestedDocData['selectedWeight'],
                  selectedDateAndTime:
                      nestedDocData['selectedDateAndTime'].toDate(),
                  address: nestedDocData['address']['address'],
                  pinCode: nestedDocData['address']['pinCode'],
                  onDelete: () {
                    deleteOrder(documents[index].id);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Orders')
          .doc(orderId)
          .delete();
      print('Order deleted successfully!');
    } catch (e) {
      print('Error deleting order: $e');
    }
  }
}

class OrderItem extends StatelessWidget {
  final String? userId;
  final String? selectedWeight;
  final DateTime? selectedDateAndTime;
  final String? address;
  final String? pinCode;
  final VoidCallback? onDelete;

  OrderItem({
    this.userId,
    this.selectedWeight,
    this.selectedDateAndTime,
    this.address,
    this.pinCode,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('User ID: $userId'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Selected Weight: $selectedWeight'),
          Text('Selected Date and Time: ${selectedDateAndTime.toString()}'),
          Text('Address: $address'),
          Text('Pin Code: $pinCode'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Implement update operation here
              // You can navigate to a new screen for updating the order
              print('Update operation for $userId');
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
