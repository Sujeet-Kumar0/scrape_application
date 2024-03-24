import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scrape_application/components/side_bar.dart';
import 'package:scrape_application/components/utils.dart';
import 'package:scrape_application/utils/pickup_status.dart';

import '../../components/order_web_tab_item.dart';
import '../../model/order_detail_model.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _currentTabIndex = 0; // Track the current tab index
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

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
              const Expanded(
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
                      actions: [
                        IconButton(
                          icon: Icon(Icons.filter_list),
                          onPressed: () {
                            _showFilterDialog(context);
                          },
                        ),
                      ],
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
                          padding: EdgeInsets.all(24.0),
                          child: OrderList(
                            tabIndex: 0,
                            selectedDate: _selectedDate,
                            selectedTime: _selectedTime,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(24.0),
                          child: OrderList(
                            tabIndex: 1,
                            selectedDate: _selectedDate,
                            selectedTime: _selectedTime,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(24.0),
                          child: OrderList(
                            tabIndex: 2,
                            selectedDate: _selectedDate,
                            selectedTime: _selectedTime,
                          ),
                        ),
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

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Orders'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Filter by Date'),
                onTap: () {
                  _selectDate(context);
                },
              ),
              ListTile(
                title: Text('Filter by Date and Time'),
                onTap: () {
                  _selectDateTime(context);
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Clear Filter'),
              onPressed: () {
                setState(() {
                  _selectedDate = null;
                  _selectedTime = null;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Apply Filter'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedTime != null && pickedDate != null) {
      setState(() {
        _selectedTime = pickedTime;
        _selectedDate = pickedDate;
      });
    }
  }
}

class OrderList extends StatelessWidget {
  final int tabIndex;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;

  const OrderList({
    super.key,
    required this.tabIndex,
    this.selectedDate,
    this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    Query ordersQuery = FirebaseFirestore.instance.collection('Orders');

    // Apply filtering based on the selected tab index
    if (tabIndex == 1) {
      // Upcoming tab
      ordersQuery =
          ordersQuery.where('status', isEqualTo: Status.upcoming.name);
    } else if (tabIndex == 2) {
      // Completed tab
      ordersQuery =
          ordersQuery.where('status', isEqualTo: Status.completed.name);
    }

    // Apply filter by selectedDate if provided
    if (selectedDate != null) {
      // Convert selectedDate to a timestamp range
      DateTime startOfDay =
          DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day);
      DateTime endOfDay = startOfDay.add(Duration(days: 1));

      // Add where clause to filter by selectedDate range
      ordersQuery = ordersQuery.where(
        'selectedDateAndTime',
        isGreaterThanOrEqualTo: startOfDay,
        isLessThan: endOfDay,
      );
    }

    // Apply filter by selectedTime if provided
    if (selectedTime != null) {
      // Extract hour and minute from selectedTime
      int hour = selectedTime!.hour;
      int minute = selectedTime!.minute;

      // Convert selectedTime to a timestamp range
      DateTime startTime = DateTime(selectedDate!.year, selectedDate!.month,
          selectedDate!.day, hour, minute);
      DateTime endTime = startTime.add(Duration(hours: 1));

      // Add where clause to filter by selectedTime range
      ordersQuery = ordersQuery.where(
        'selectedDateAndTime',
        isGreaterThanOrEqualTo: startTime,
        isLessThan: endTime,
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: ordersQuery.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          log('Error: ${snapshot.error.toString()}');
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildProgressIndicator();
        }

        List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        if (documents.isEmpty) {
          return const Center(
            child: Text("No Orders"),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
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
                return const DataRow(cells: [
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
                        return const Text('User details not found');
                      }

                      final userData = userSnapshot.data!.data() as Map?;
                      if (userData == null || userData.isEmpty) {
                        return const Text('User details not found');
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
                        return const Text('User details not found');
                      }

                      final userData = userSnapshot.data!.data() as Map?;
                      if (userData == null || userData.isEmpty) {
                        return const Text('User details not found');
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
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showStatusUpdateDialog(
                              context, doc.id, order.status!);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
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
      log('Order deleted successfully!');
    } catch (e) {
      log('Error deleting order: $e');
    }
  }

  void _showStatusUpdateDialog(
      BuildContext context, String orderId, Status status) {
    Status currentStatus = status;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Status'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Upcoming'),
                      Switch(
                        value: currentStatus == Status.completed,
                        onChanged: (value) {
                          setState(() {
                            currentStatus =
                                value ? Status.completed : Status.upcoming;
                          });
                        },
                      ),
                      const Text('Completed'),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
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

      log('Order status updated successfully!');
    } catch (e) {
      log('Error updating order status: $e');
    }
  }
}
