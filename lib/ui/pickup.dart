import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrape_application/utils/pickup_status.dart';

import '../model/address_model.dart';
import '../model/order_detail_model.dart';
import '../viewmodels/pickup_viewmodel.dart';

class PickUpScreen extends StatefulWidget {
  const PickUpScreen({super.key});

  @override
  State<PickUpScreen> createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen>
    with TickerProviderStateMixin {
  late PickupViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<PickupViewModel>(context, listen: false);
    _viewModel.init(this);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _viewModel.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_viewModel.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white, // Change as needed
        body: SafeArea(
          child: Column(
            children: [
              // Build TabBar
              TabBar(
                labelColor: Colors.black, // Change as needed
                unselectedLabelColor: Colors.grey, // Change as needed
                tabs: [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Completed'),
                ],
                controller: _viewModel.tabController,
              ),
              Expanded(
                child: TabBarView(
                  controller: _viewModel.tabController,
                  children: [
                    _buildUpcomingContent("Upcoming"),
                    _buildCompletedContent("Completed"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingContent(String text) {
    return StreamBuilder<QuerySnapshot>(
      stream: _viewModel.fetchOrdersStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final upcomingOrders = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data.containsKey('status') &&
              data['status'] == Status.upcoming.name;
        }).toList();

        if (snapshot.data == null ||
            snapshot.data!.docs.isEmpty ||
            upcomingOrders.isEmpty) {
          return Center(child: Text('Nothing Here!'));
        } else {
          return ListView.builder(
            itemCount: upcomingOrders.length,
            itemBuilder: (context, index) {
              final doc = upcomingOrders[index];
              final data = doc.data() as Map<String, dynamic>;
              final selectedWeight = data?['selectedWeight'] ?? "";
              final selectedDateTime =
                  (data?['selectedDateAndTime'] as Timestamp?)?.toDate();
              final selectedDateAndTime = selectedDateTime != null
                  ? TimeOfDay.fromDateTime(selectedDateTime)
                  : null;
              final addressJson = data?['address'];
              final address =
                  addressJson != null ? Address.fromJson(addressJson) : null;
              if (selectedDateAndTime == null || address == null) {
                return SizedBox(); // Skip rendering if necessary data is null
              }
              final order = OrderDetails(
                selectedWeight,
                selectedDateTime!,
                selectedDateAndTime,
                address!,
              );

              return _buildOrderCard(order, index);
            },
          );
        }
      },
    );
  }

// Widget _buildUpcomingContent(String text) {
//   return StreamBuilder<QuerySnapshot>(
//     stream: _viewModel.fetchOrdersStream().map((snapshot) => snapshot.docs.where((doc) => doc['status'] == ).toList()),
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return Center(child: CircularProgressIndicator());
//       } else if (snapshot.hasError) {
//         return Center(child: Text('Error: ${snapshot.error}'));
//       } else if (snapshot.data == null || snapshot.data!.isEmpty) {
//         return Center(child: Text('Nothing Here!'));
//       } else {
//               final upcomingOrders = snapshot.data!.docs.where((doc) => doc['status'] == Status.upcoming.name).toList();

//         return ListView.builder(

//           itemCount: snapshot.data!.length,
//           itemBuilder: (context, index) {
//             final doc = snapshot.data![index];
//             final selectedWeight = doc['selectedWeight'] ?? "";
//             final selectedDateTime = (doc['selectedDateAndTime'] as Timestamp?)?.toDate();
//             final selectedDateAndTime = selectedDateTime != null ? TimeOfDay.fromDateTime(selectedDateTime) : null;
//             final addressJson = doc['address'];
//             final address = addressJson != null ? Address.fromJson(addressJson) : null;
//             if (selectedDateAndTime == null || address == null) {
//               return SizedBox(); // Skip rendering if necessary data is null
//             }
//             final order = OrderDetails(
//               selectedWeight,
//               selectedDateTime!,
//               selectedDateAndTime,
//               address!,
//             );
//             return _buildOrderCard(order);
//           },
//         );
//       }
//     },
//   );
// }

  Widget _buildCompletedContent(String text) {
    return StreamBuilder<QuerySnapshot>(
      stream: _viewModel.fetchOrdersStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final completedOrders = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data.containsKey('status') &&
              data['status'] == Status.completed.name;
        }).toList();
        if (snapshot.data == null ||
            snapshot.data!.docs.isEmpty ||
            completedOrders.isEmpty) {
          return const Center(child: Text('Nothing Here!'));
        } else {
          return ListView.builder(
            itemCount: completedOrders.length,
            itemBuilder: (context, index) {
              final doc = completedOrders[index];
              final selectedWeight = doc['selectedWeight'] ?? "";
              final selectedDateTime =
                  (doc['selectedDateAndTime'] as Timestamp?)?.toDate();
              final selectedDateAndTime = selectedDateTime != null
                  ? TimeOfDay.fromDateTime(selectedDateTime)
                  : null;
              final addressJson = doc['address'];
              final address =
                  addressJson != null ? Address.fromJson(addressJson) : null;
              if (selectedDateAndTime == null || address == null) {
                return SizedBox(); // Skip rendering if necessary data is null
              }
              final order = OrderDetails(
                selectedWeight,
                selectedDateTime!,
                selectedDateAndTime,
                address!,
              );
              return _buildOrderCard(order, index);
            },
          );
        }
      },
    );
  }

  Widget _buildOrderCard(OrderDetails order, index) {
    return Column(
      children: [
        ListTile(
          title: Text('Order #${index + 1}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Weight: ${order.selectedWeight}'),
              Text(
                  'Date: ${order.selectedDate.day} - ${order.selectedDate.month} - ${order.selectedDate.year}'),
              Text(
                  'Time: ${order.selectedTime.hour} : ${order.selectedTime.minute}'),
              Text('Address: ${order.address.address}'),
              Text('Pin Code: ${order.address.pinCode}'),
              Divider(
                thickness: 1,
              )
            ],
          ),
        ),
      ],
    );
  }
}
