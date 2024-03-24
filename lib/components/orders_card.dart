import 'package:flutter/material.dart';

import '../model/order_detail_model.dart';

class OrderCard extends StatelessWidget {
  final OrderDetails order;
  final int index;

  const OrderCard({Key? key, required this.order, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('Order #${index + 1}'),
          subtitle: Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            children: [
              _buildTableRow('Weight', order.selectedWeight),
              _buildTableRow('Date',
                  '${order.selectedDate.day} - ${order.selectedDate.month} - ${order.selectedDate.year}'),
              _buildTableRow('Time',
                  '${order.selectedTime.hour} : ${order.selectedTime.minute}'),
              _buildTableRow('Address', order.address.address),
              _buildTableRow('Pin Code', order.address.pinCode),
            ],
          ),
        ),
        const Divider(
          thickness: 1,
          height: 1,
        )
      ],
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(value),
        ),
      ],
    );
  }
}
