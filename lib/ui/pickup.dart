import 'package:flutter/material.dart';

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
    _viewModel = PickupViewModel();
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
                    _buildTabContent("Upcoming"),
                    _buildTabContent("Completed"),
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
  Widget _buildTabContent(String text) {
    return Center(
      child: Text(
        'Nothing Here!',
        style: TextStyle(fontSize: 20), // Change as needed
      ),
    );
  }
}
