import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scrape_application/components/side_bar.dart';
import 'package:scrape_application/components/utils.dart';
import 'package:scrape_application/utils/pickup_status.dart';

import '../../model/order_detail_model.dart';

class TabItem extends StatelessWidget {
  final String title;
  final int count;

  const TabItem({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
          ),
          count > 0
              ? Container(
                  margin: const EdgeInsetsDirectional.only(start: 5),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      count > 9 ? "9+" : count.toString(),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                      ),
                    ),
                  ),
                )
              : const SizedBox(width: 0, height: 0),
        ],
      ),
    );
  }
}

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

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
                padding: const EdgeInsets.all(8.0),
                child: DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(40),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: Container(
                            height: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: Colors.green.shade100,
                            ),
                            child: const TabBar(
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              indicator: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.black54,
                              tabs: [
                                TabItem(title: 'All Orders', count: 0),
                                TabItem(title: 'Pending', count: 0),
                                TabItem(title: 'Completed', count: 0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: OrderList(),
                        ),
                        Center(child: Text('Pending Page')),
                        Center(child: Text('Completed Page')),
                      ],
                    ),
                  ),
                ),
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
      stream: FirebaseFirestore.instance
          .collection('Orders')
          // .orderBy('selectedDateAndTime', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildProgressIndicator();
        }

        List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        if (documents.isEmpty) {
          return Center(
            child: Text("No Orders"),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Phone Number')),
              DataColumn(label: Text('Selected Weight')),
              DataColumn(label: Text('Selected Date and Time')),
              DataColumn(label: Text('Address')),
              DataColumn(label: Text('Pin Code')),
              DataColumn(label: Text('Actions')),
            ],
            rows: documents.map<DataRow>((doc) {
              final data = doc.data() as Map?;

              if (data == null || data.isEmpty) {
                return DataRow(cells: [
                  DataCell(SizedBox()),
                  DataCell(SizedBox()),
                  DataCell(SizedBox()),
                  DataCell(SizedBox()),
                  DataCell(SizedBox()),
                  DataCell(SizedBox()),
                  DataCell(SizedBox()),
                ]);
              }

              final order =
                  OrderDetails.fromFirestore(data as Map<String, dynamic>);

              return DataRow(
                cells: [
                  DataCell(FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(order.userId)
                        .get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return buildProgressIndicator();
                      }

                      if (userSnapshot.hasError || !userSnapshot.hasData) {
                        return Text('User details not found');
                      }

                      final userData = userSnapshot.data!.data() as Map?;
                      if (userData == null || userData.isEmpty) {
                        return Text('User details not found');
                      }

                      final userName = userData['userName'];

                      return Text(userName ?? 'N/A');
                    },
                  )),
                  DataCell(FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(order.userId)
                        .get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return buildProgressIndicator();
                      }

                      if (userSnapshot.hasError || !userSnapshot.hasData) {
                        return Text('User details not found');
                      }

                      final userData = userSnapshot.data!.data() as Map?;
                      if (userData == null || userData.isEmpty) {
                        return Text('User details not found');
                      }

                      final userPhoneNumber = userData['phoneNumber'];

                      return Text(userPhoneNumber ?? 'N/A');
                    },
                  )),
                  DataCell(Text(order.selectedWeight)),
                  DataCell(Text('${order.selectedDate}')),
                  DataCell(Text(order.address.address)),
                  DataCell(Text(order.address.pinCode)),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showStatusUpdateDialog(
                              context, doc.id, order.status!);
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
                ],
              );
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
          .doc(orderId)
          .update({"status": status.toString().split('.').last});

      print('Order status updated successfully!');
    } catch (e) {
      print('Error updating order status: $e');
    }
  }
}

class OrderItem extends StatelessWidget {
  final OrderDetails order;
  final VoidCallback? onDelete;
  final VoidCallback? onUpdate;

  const OrderItem({
    required this.order,
    this.onDelete,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('User ID: ${order.userId}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Selected Weight: ${order.selectedWeight}'),
          Text(
              'Selected Date and Time: ${order.selectedDate} ${order.selectedTime}'),
          Text('Address: ${order.address.address}'),
          Text('Pin Code: ${order.address.pinCode}'),
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
