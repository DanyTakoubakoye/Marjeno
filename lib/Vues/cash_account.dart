import 'package:flutter/material.dart';

class CashAccountView extends StatelessWidget {
  const CashAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column 1
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter account name',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                // Column 2
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Number',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter account number',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Dynamic Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    // Date Column with Subheaders
                    DataColumn(
                      label: Column(
                        children: [
                          Text('Date',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Text('Date'),
                              SizedBox(width: 10),
                              Text('Day'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Inflow Columns with Subheaders
                    DataColumn(
                      label: Column(
                        children: [
                          Text('Inflow',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Text('Dollar'),
                              SizedBox(width: 10),
                              Text('Dirham'),
                              SizedBox(width: 10),
                              Text('CFA(XOF)'),
                              SizedBox(width: 10),
                              Text('Location'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Outflow Columns with Subheaders
                    DataColumn(
                      label: Column(
                        children: [
                          Text('Outflow',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Text('Dollar'),
                              SizedBox(width: 10),
                              Text('Dirham'),
                              SizedBox(width: 10),
                              Text('CFA(XOF)'),
                              SizedBox(width: 10),
                              Text('Location'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  rows: List.generate(
                    5,
                    (index) => DataRow(cells: [
                      DataCell(Text('Date $index')),
                      DataCell(Text('Inflow $index')),
                      DataCell(Text('Outflow $index')),
                    ]),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Total Transaction Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('TOTAL TRANSACTION',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Dollar'),
                Text('Dirham'),
                Text('CFA(XOF)'),
              ],
            ),
            SizedBox(height: 10),
            // Balance Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Balance', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Dollar'),
                Text('Dirham'),
                Text('CFA(XOF)'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
