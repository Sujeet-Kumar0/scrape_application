import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scrape_application/components/side_bar.dart';
import 'package:scrape_application/utils/pickup_status.dart';

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
      // drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (kIsWeb)
              Expanded(
                flex: 1,
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: OrderList(),
              ),
            ),
          ],
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
        if (documents.isEmpty) {
          return Center(
            child: Text("No Customers"),
          );
        }

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return OrderItemWidget(orderSnapshot: documents[index]);
          },
        );
      },
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  final QueryDocumentSnapshot orderSnapshot;

  const OrderItemWidget({
    required this.orderSnapshot,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: orderSnapshot.reference.collection('order').get(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> nestedSnapshot) {
        if (nestedSnapshot.hasError) {
          return Text('Error fetching nested data');
        }

        if (nestedSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        //for Displaying User Has't Ordered any
        List<QueryDocumentSnapshot> nestedDocs = nestedSnapshot.data!.docs;
        // if (nestedDocs.isEmpty) {
        //   return SizedBox();
        // }

        // Mapping each nested document to an OrderItem widget
        List<OrderItem> orderItems = nestedDocs.map((nestedDoc) {
          var nestedDocData = nestedDoc.data() as Map<String, dynamic>;
          return OrderItem(
            userId: orderSnapshot.id,
            selectedWeight: nestedDocData['selectedWeight'],
            selectedDateAndTime: nestedDocData['selectedDateAndTime'].toDate(),
            address: nestedDocData['address']['address'],
            pinCode: nestedDocData['address']['pinCode'],
            onDelete: () {
              deleteOrder(nestedDoc.id);
            },
            onUpdate: () {
              _showStatusUpdateDialog(
                context,
                nestedDoc.id,
                (nestedDocData["status"] as String).toLowerCase() == 'completed'
                    ? Status.completed
                    : Status.upcoming,
              );
            },
          );
        }).toList();

        // return Column(
        //   children: orderItems,
        // );

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('User ID')),
              DataColumn(label: Text('Chossen Weight cata')),
              DataColumn(label: Text('Date and Time')),
              DataColumn(label: Text('Address')),
              DataColumn(label: Text('Pin Code')),
              DataColumn(label: Text('Actions')),
            ],
            rows: nestedDocs.map((doc) {
              return DataRow(cells: [
                DataCell(Text(orderSnapshot.id)),
                DataCell(Text(doc['selectedWeight'])),
                DataCell(Text(doc['selectedDateAndTime'].toDate().toString())),
                DataCell(Text(doc['address']['address'])),
                DataCell(Text(doc['address']['pinCode'])),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showStatusUpdateDialog(
                          context,
                          doc.id,
                          (doc["status"] as String).toLowerCase() == 'completed'
                              ? Status.completed
                              : Status.upcoming,
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteOrder(doc.id);
                      },
                    ),
                  ],
                )),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Orders')
          .doc(orderSnapshot.id)
          .collection("order")
          .doc(orderId)
          .delete();

      print('Order deleted successfully!');
    } catch (e) {
      print('Error deleting order: $e');
    }
  }

  void _showStatusUpdateDialog(
      BuildContext context, String orderId, Status status) {
    Status currentStatus = status;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Status'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Upcoming'),
                      Switch(
                        value: currentStatus == Status.completed,
                        onChanged: (value) {
                          setState(() {
                            currentStatus =
                                value ? Status.completed : Status.upcoming;
                          });
                        },
                      ),
                      Text('Completed'),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () {
                updateStatus(orderId, currentStatus);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateStatus(String orderId, Status status) async {
    try {
      await FirebaseFirestore.instance
          .collection('Orders')
          .doc(orderSnapshot.id)
          .collection("order")
          .doc(orderId)
          .update({"status": status.toString().split('.').last});

      print('Order status updated successfully!');
    } catch (e) {
      print('Error updating order status: $e');
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
  final VoidCallback? onUpdate;

  OrderItem(
      {this.userId,
      this.selectedWeight,
      this.selectedDateAndTime,
      this.address,
      this.pinCode,
      this.onDelete,
      this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('User ID: $userId'),
      subtitle: Row(
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
            onPressed: onUpdate,
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

// class OrderList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('Orders').snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text('Something went wrong');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
//         if (documents.isEmpty) {
//           return Center(
//             child: Text("No Customers"),
//           );
//         }

//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: DataTable(
//             columns: [
//               DataColumn(label: Text('User ID')),
//               DataColumn(label: Text('Selected Weight')),
//               DataColumn(label: Text('Selected Date and Time')),
//               DataColumn(label: Text('Address')),
//               DataColumn(label: Text('Pin Code')),
//               DataColumn(label: Text('Actions')),
//             ],
//             rows: documents.map((doc) {
//               return DataRow(cells: [
//                 DataCell(Text(doc.id)),
//                 DataCell(Text(doc['selectedWeight'])),
//                 DataCell(Text(doc['selectedDateAndTime'].toString())),
//                 DataCell(Text(doc['address']['address'])),
//                 DataCell(Text(doc['address']['pinCode'])),
//                 DataCell(Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.edit),
//                       onPressed: () {
//                         // Handle edit action
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         // Handle delete action
//                       },
//                     ),
//                   ],
//                 )),
//               ]);
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }
// }
