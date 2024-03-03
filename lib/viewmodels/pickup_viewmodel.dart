import 'package:flutter/material.dart';

class PickupViewModel {
  late TabController tabController;
  final unfocusNode = FocusNode();

  void init(TickerProvider vsync) {
    tabController = TabController(length: 2, initialIndex: 0, vsync: vsync);
  }

  void dispose() {
    tabController.dispose();
    unfocusNode.dispose();
  }
}
