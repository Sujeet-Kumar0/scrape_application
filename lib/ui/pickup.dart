import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  // Method to build the content of each tab
  Widget _buildUpcomingContent(String text) {
    return Visibility(
      visible: _viewModel.orders.isNotEmpty,
      replacement: Center(
        child: Text(
          'Nothing Here!',
          style: TextStyle(fontSize: 20), // Change as needed
        ),
      ),
      child: ListView.builder(
        itemCount: _viewModel.orders.length,
        itemBuilder: (context, index) {
          // Retrieve order details at the given index
          OrderDetails order = _viewModel.orders[index];
          return Card(
            elevation: 4,
            child: Column(
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
            ),
          );
        },
      ),
    );
  } // Method to build the content of each tab

  Widget _buildCompletedContent(String text) {
    return Center(
      child: Text(
        'Nothing Here!',
        style: TextStyle(fontSize: 20), // Change as needed
      ),
    );
  }
}
