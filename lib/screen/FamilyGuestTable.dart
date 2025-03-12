import 'package:flutter/material.dart';

class FamilyGuestTable extends StatelessWidget {
  final int familyCount;
  final int guestCount;
  final double familyAmount;
  final double guestAmount;

  FamilyGuestTable({
    required this.familyCount,
    required this.guestCount,
    required this.familyAmount,
    required this.guestAmount,
  });

  @override
  Widget build(BuildContext context) {
    double totalAmount = familyAmount + guestAmount;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Table(
        border: TableBorder.all(
          color: Colors.black, // Border color
          width: 1, // Border width
        ),
        columnWidths: const {
          0: FlexColumnWidth(2), // No of members (Family/Guest)
          1: FlexColumnWidth(1), // Count of members
          2: FlexColumnWidth(1), // Amount
        },
        children: [
          // Header Row
          TableRow(
            decoration: BoxDecoration(color: Colors.grey[300]),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Count', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          // Row for Family members
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('No. of Family Members'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(familyCount.toString()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(familyAmount.toStringAsFixed(2)),
              ),
            ],
          ),
          // Row for Guest members
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('No. of Guests'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(guestCount.toString()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(guestAmount.toStringAsFixed(2)),
              ),
            ],
          ),
          // Row for Total Amount
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(''), // Empty cell for Count
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(totalAmount.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
