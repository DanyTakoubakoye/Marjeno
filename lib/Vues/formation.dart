import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CashAccountTest extends StatefulWidget {
  const CashAccountTest({super.key});

  @override
  State<CashAccountTest> createState() => _CashAccountTestState();
}

class _CashAccountTestState extends State<CashAccountTest> {
  double lageurColonne = 50.0;
  double hauteurColonne = 50.0;
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountIDController = TextEditingController();
  final TextEditingController _totalDollarInController =
      TextEditingController();
  final TextEditingController _totalDollarOutController =
      TextEditingController();
  final TextEditingController _totalDirhamInController =
      TextEditingController();
  final TextEditingController _totalDirhamOutController =
      TextEditingController();
  final TextEditingController _totalCFAInController = TextEditingController();
  final TextEditingController _totalCFAOutController = TextEditingController();
  final TextEditingController _soldeCFAController = TextEditingController();
  final TextEditingController _soldeDirhamController = TextEditingController();
  final TextEditingController _soldeDollarController = TextEditingController();

  List<Map<String, dynamic>> rows = [
    {
      'Date': DateFormat('dd/MM/yy').format(DateTime.now()),
      'Day': DateFormat('EEEE', 'fr_FR').format(DateTime.now()).titleCase,
      'Dollar in': 0.0,
      'Dirham in': 0.0,
      'CFA in': 0.0,
      'Location in': " ",
      'Dollar out': 0.0,
      'Dirham out': 0.0,
      'CFA out': 0.0,
      'Location out': " "
    },
  ];
  void _ajouterNouvelleLigne() {
    setState(() {
      rows.add({
        'Date': DateFormat('dd/MM/yy').format(DateTime.now()),
        'Day': DateFormat('EEEE', 'fr_FR').format(DateTime.now()).titleCase,
        'Dollar in': 0.0,
        'Dirham in': 0.0,
        'CFA in': 0.0,
        'Location in': " ",
        'Dollar out': 0.0,
        'Dirham out': 0.0,
        'CFA out': 0.0,
        'Location out': " "
      });
    });
  }

  // Fonction pour calculer la somme de la colonne "Prix Lingot"
  double _calculateTotalDollarIn() {
    return rows.fold(0.0, (T, row) => T + row['Dollar in']);
  }

  double _calculateTotalCFAIn() {
    return rows.fold(0.0, (T, row) => T + row['CFA in']);
  }

  double _calculateTotalDirhamIn() {
    return rows.fold(0.0, (T, row) => T + row['Dirham in']);
  }

  double _calculateTotalDollarOut() {
    return rows.fold(0.0, (T, row) => T + row['Dollar out']);
  }

  double _calculateTotalCFAOut() {
    return rows.fold(0.0, (T, row) => T + row['CFA out']);
  }

  double _calculateTotalDirhamOut() {
    return rows.fold(0.0, (T, row) => T + row['Dirham out']);
  }

  double _calculateSoldeDollard() =>
      _calculateTotalDollarIn() - _calculateTotalDollarOut();
  double _calculateSoldeDirham() =>
      _calculateTotalDirhamIn() - _calculateTotalDirhamOut();
  double _calculateSoldeCFA() =>
      _calculateTotalCFAIn() - _calculateTotalCFAOut();

  // Fonction pour formater les nombres en format comptabilité
  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(
        locale: 'fr_FR', symbol: '', decimalDigits: value % 1 == 0 ? 0 : 2);
    return formatter
        .format(value)
        .replaceAll('.', ' ,')
        .replaceAll('\u00A0', ' ');
  }

  // Fonction pour mettre à jour une cellule
  void _updateCurrencyCell(int index, String key, double value) {
    setState(() {
      rows[index][key] = value;

      _totalDollarInController.text =
          _formatCurrency(_calculateTotalDollarIn());
      _totalCFAInController.text = _formatCurrency(_calculateTotalCFAIn());
      _totalDirhamInController.text =
          _formatCurrency(_calculateTotalDirhamIn());
      _totalDollarOutController.text =
          _formatCurrency(_calculateTotalDollarOut());
      _totalCFAOutController.text = _formatCurrency(_calculateTotalCFAOut());
      _totalDirhamOutController.text =
          _formatCurrency(_calculateTotalDirhamOut());
      _soldeDollarController.text = _formatCurrency(_calculateSoldeDollard());
      _soldeDirhamController.text = _formatCurrency(_calculateSoldeDirham());
      _soldeCFAController.text = _formatCurrency(_calculateSoldeCFA());
    });
  }

  Future<void> _genererPDF() async {
    final pdf = pw.Document();
    final image = await rootBundle.load('assets/Images/Lys.jpg');
    final imageProvider = pw.MemoryImage(image.buffer.asUint8List());
    double? soldeDollar = double.tryParse(_soldeDollarController.text);
    double? soldeDirham = double.tryParse(_soldeDollarController.text);
    double? soldeCFA = double.tryParse(_soldeCFAController.text);

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Container(
          width: double.infinity,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Row(
                children: [
                  pw.Text(
                    "LYS INTERNATIONAL",
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(width: 10),
                  pw.Image(imageProvider),
                ],
              ),
              pw.SizedBox(height: 25),
              pw.Center(
                child: pw.Text(
                  textAlign: pw.TextAlign.center,
                  "STATEMENT CASH ACCOUNT",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 25),
              pw.Text(
                "Account Name:      ${_accountNameController.text}",
                style: pw.TextStyle(
                    fontSize: 13,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Account Number :    ${_accountIDController.text}',
                style: pw.TextStyle(
                    fontSize: 13,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              pw.Divider(thickness: 4.0),
              pw.SizedBox(height: 20),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Text(
                  "Date : ${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
                  style: pw.TextStyle(fontSize: 14),
                ),
              ]),
              pw.SizedBox(height: 12),
              pw.Table(border: pw.TableBorder.all(), columnWidths: {
                0: pw.FlexColumnWidth(4 * lageurColonne), // Largeur colonne 1
                1: pw.FlexColumnWidth(8 * lageurColonne), // Largeur colonne 2
                2: pw.FlexColumnWidth(8 * lageurColonne)
              }, children: [
                pw.TableRow(
                  children: [
                    pw.Text(
                      'Date',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 14.0,
                          fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Inflow',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14.0,
                          color: PdfColors.green),
                    ),
                    pw.Text(
                      'Outflow',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14.0,
                        color: PdfColors.red,
                      ),
                    ),
                  ],
                ),
              ]),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FlexColumnWidth(1), // Largeur colonne 1
                  1: pw.FlexColumnWidth(1), // Largeur colonne 2
                  2: pw.FlexColumnWidth(1),
                  3: pw.FlexColumnWidth(1),
                  4: pw.FlexColumnWidth(1),
                  5: pw.FlexColumnWidth(1),
                  6: pw.FlexColumnWidth(1),
                  7: pw.FlexColumnWidth(1),
                  8: pw.FlexColumnWidth(1),
                  9: pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(children: [
                    pw.Container(
                        color: PdfColors.grey200,
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          'Date',
                          textAlign: pw.TextAlign.center,
                        )),
                    pw.Container(
                        color: PdfColors.grey200,
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          'Day',
                          textAlign: pw.TextAlign.center,
                        )),
                    pw.Container(
                        color: PdfColors.grey200,
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          'Dollar',
                          textAlign: pw.TextAlign.center,
                        )),
                    pw.Container(
                        color: PdfColors.grey200,
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          'Dirham',
                          textAlign: pw.TextAlign.center,
                        )),
                    pw.Container(
                        color: PdfColors.grey200,
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          'CFA',
                          textAlign: pw.TextAlign.center,
                        )),
                    pw.Container(
                        color: PdfColors.grey200,
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          'Location',
                          textAlign: pw.TextAlign.center,
                        )),
                    pw.Container(
                        color: PdfColors.grey200,
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text('Dollar')),
                    pw.Container(
                        color: PdfColors.grey200,
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          'Dirham',
                          textAlign: pw.TextAlign.center,
                        )),
                    pw.Container(
                        color: PdfColors.grey200,
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          'CFA',
                          textAlign: pw.TextAlign.center,
                        )),
                    pw.Container(
                        color: PdfColors.grey200,
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          'Location',
                          textAlign: pw.TextAlign.center,
                        )),
                  ]),
                  ...rows.map(
                    (row) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(
                              top: 25, right: 4, left: 4),
                          child: pw.Center(
                            child: pw.Text(
                              row['Date'].toString(),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(
                              top: 25, right: 25, left: 12),
                          child: pw.Center(
                            child: pw.Text(
                              row['Day'].toString(),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ),
                        pw.Center(
                          child: pw.Text(
                            row['Dollar in'].toString(),
                            style: pw.TextStyle(color: PdfColors.green500),
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                        pw.Center(
                          child: pw.Text(
                            row['Dirham in'].toString(),
                            style: pw.TextStyle(color: PdfColors.green500),
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                        pw.Center(
                          child: pw.Text(
                            row['CFA in'].toString(),
                            style: pw.TextStyle(color: PdfColors.green500),
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                        pw.Center(
                          child: pw.Text(
                            row['Location in'].toString(),
                            style: pw.TextStyle(color: PdfColors.green500),
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                        pw.Center(
                          child: pw.Text(
                            row['Dollar out'].toString(),
                            style: pw.TextStyle(color: PdfColors.red),
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                        pw.Center(
                          child: pw.Text(
                            row['Dirham out'].toString(),
                            style: pw.TextStyle(color: PdfColors.red),
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                        pw.Center(
                          child: pw.Text(
                            row['CFA out'].toString(),
                            style: pw.TextStyle(color: PdfColors.red),
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                        pw.Center(
                          child: pw.Text(
                            row['Location out'].toString(),
                            style: pw.TextStyle(color: PdfColors.red),
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FlexColumnWidth(2 * lageurColonne), // Largeur colonne 1
                  1: pw.FlexColumnWidth(lageurColonne), // Largeur colonne 2
                  2: pw.FlexColumnWidth(lageurColonne),
                  3: pw.FlexColumnWidth(lageurColonne),
                  4: pw.FlexColumnWidth(lageurColonne),
                  5: pw.FlexColumnWidth(lageurColonne),
                  6: pw.FlexColumnWidth(lageurColonne),
                  7: pw.FlexColumnWidth(lageurColonne),
                  8: pw.FlexColumnWidth(lageurColonne),
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text(
                        'Total Transactions on the period',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontSize: 15, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        style: pw.TextStyle(color: PdfColors.green),
                        _totalDollarInController.text,
                      ),
                      pw.Text(
                        style: pw.TextStyle(color: PdfColors.green),
                        _totalDirhamInController.text,
                      ),
                      pw.Text(
                        style: pw.TextStyle(color: PdfColors.green),
                        _totalCFAInController.text,
                      ),
                      pw.SizedBox(
                        width: lageurColonne,
                        child: pw.Container(
                          color: PdfColors.grey400,
                        ),
                      ),
                      pw.Text(
                        style: pw.TextStyle(color: PdfColors.red),
                        _totalDollarOutController.text,
                      ),
                      pw.Text(
                        style: pw.TextStyle(color: PdfColors.red),
                        _totalDirhamOutController.text,
                      ),
                      pw.Text(
                        style: pw.TextStyle(color: PdfColors.red),
                        _totalCFAOutController.text,
                      ),
                      pw.SizedBox(
                        width: lageurColonne,
                        child: pw.Container(
                          color: PdfColors.grey400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 15),
              pw.Row(
                children: [
                  pw.SizedBox(
                    width: 4 * lageurColonne,
                    height: hauteurColonne,
                  ),
                  pw.SizedBox(
                    width: lageurColonne,
                    child: pw.Text('Dollar (\$)'),
                  ),
                  pw.SizedBox(width: 30),
                  pw.SizedBox(
                    width: 1.5 * lageurColonne,
                    child: pw.Text('Dirham (AED)'),
                  ),
                  pw.SizedBox(width: 50),
                  pw.SizedBox(
                    width: 1.5 * lageurColonne,
                    child: pw.Text('CFA(XOF)'),
                  ),
                ],
              ),
              pw.Row(
                children: [
                  pw.SizedBox(
                    width: 2 * lageurColonne,
                    height: hauteurColonne,
                  ),
                  pw.SizedBox(
                    width: 2 * lageurColonne,
                    height: hauteurColonne,
                    child: pw.Text(
                      'BALANCE',
                      style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black),
                    ),
                  ),
                  pw.SizedBox(
                    width: 2 * lageurColonne,
                    height: hauteurColonne,
                    child: pw.Text(
                      _soldeDollarController.text,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: (soldeDollar != null && soldeDollar >= 0)
                            ? PdfColors.green
                            : PdfColors.red,
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 10),
                  pw.SizedBox(
                    width: 2 * lageurColonne,
                    height: hauteurColonne,
                    child: pw.Text(
                      _soldeDirhamController.text,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: (soldeDirham != null && soldeDirham >= 0)
                            ? PdfColors.green
                            : PdfColors.red,
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 20),
                  pw.SizedBox(
                    width: 2 * lageurColonne,
                    height: hauteurColonne,
                    child: pw.Text(
                      _soldeCFAController.text,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: (soldeCFA != null && soldeCFA >= 0)
                            ? PdfColors.green
                            : PdfColors.red,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cash Account',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: _genererPDF, child: Text('Imprimer le solde')),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Account Name',
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: TextField(
                        controller: _accountNameController,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Account Number',
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: TextField(
                        controller: _accountIDController,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    )
                  ],
                )
              ],
            ),
            Card(
              elevation: 5, // Ajout d'une ombre douce
              margin: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(border: TableBorder.all(), columnWidths: {
                  0: FlexColumnWidth(4 * lageurColonne), // Largeur colonne 1
                  1: FlexColumnWidth(8 * lageurColonne), // Largeur colonne 2
                  2: FlexColumnWidth(8 * lageurColonne)
                }, children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          color: Colors.blueAccent,
                          child: Text(
                            'Date',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                          child: Container(
                              padding: EdgeInsets.all(8.0),
                              color: Colors.grey[200],
                              child: Text(
                                'Inflow',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    color: Colors.green),
                              ))),
                      TableCell(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          color: Colors.grey[200],
                          child: Text(
                            'Outflow',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ]),
              ),
            ),
            Card(
                elevation: 5, // Ajout d'une ombre douce
                margin: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Table(border: TableBorder.all(), columnWidths: {
                    0: FlexColumnWidth(lageurColonne), // Largeur colonne 1
                    1: FlexColumnWidth(lageurColonne), // Largeur colonne 2
                    2: FlexColumnWidth(lageurColonne),
                    3: FlexColumnWidth(lageurColonne),
                    4: FlexColumnWidth(lageurColonne),
                    5: FlexColumnWidth(lageurColonne),
                    6: FlexColumnWidth(lageurColonne),
                    7: FlexColumnWidth(lageurColonne),
                    8: FlexColumnWidth(lageurColonne),
                    9: FlexColumnWidth(lageurColonne),
                  }, children: [
                    TableRow(children: [
                      TableCell(
                          child: Container(
                              color: Colors.grey[200],
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Date',
                                textAlign: TextAlign.center,
                              ))),
                      TableCell(
                          child: Container(
                              color: Colors.grey[200],
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Day',
                                textAlign: TextAlign.center,
                              ))),
                      TableCell(
                          child: Container(
                              color: Colors.grey[200],
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Dollar',
                                textAlign: TextAlign.center,
                              ))),
                      TableCell(
                          child: Container(
                              color: Colors.grey[200],
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Dirham',
                                textAlign: TextAlign.center,
                              ))),
                      TableCell(
                          child: Container(
                              color: Colors.grey[200],
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'CFA',
                                textAlign: TextAlign.center,
                              ))),
                      TableCell(
                          child: Container(
                              color: Colors.grey[200],
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Location',
                                textAlign: TextAlign.center,
                              ))),
                      TableCell(
                          child: Container(
                              color: Colors.grey[200],
                              padding: EdgeInsets.all(8.0),
                              child: Text('Dollar'))),
                      TableCell(
                          child: Container(
                              color: Colors.grey[200],
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Dirham',
                                textAlign: TextAlign.center,
                              ))),
                      TableCell(
                          child: Container(
                              color: Colors.grey[200],
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'CFA',
                                textAlign: TextAlign.center,
                              ))),
                      TableCell(
                          child: Container(
                              color: Colors.grey[200],
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Location',
                                textAlign: TextAlign.center,
                              ))),
                    ]),
                    ...rows.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> row = entry.value;
                      return TableRow(
                        children: [
                          _buildDateCell(),
                          _buildDayCell(),
                          _buildCurrencyInCell(
                              index, 'Dollar in', row['Dollar in'].toString()),
                          _buildCurrencyInCell(
                              index, 'Dirham in', row['Dirham in'].toString()),
                          _buildCurrencyInCell(
                              index, 'CFA in', row['CFA in'].toString()),
                          _buildLocationInCell(),
                          _buildCurrencyOutCell(index, 'Dollar out',
                              row['Dollar out'].toString()),
                          _buildCurrencyOutCell(index, 'Dirham out',
                              row['Dirham out'].toString()),
                          _buildCurrencyOutCell(
                              index, 'CFA out', row['CFA out'].toString()),
                          _buildLocationOutCell()
                        ],
                      );
                    }),
                  ]),
                )),
            Card(
              elevation: 5, // Ajout d'une ombre douce
              margin: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Table(border: TableBorder.all(), columnWidths: {
                0: FlexColumnWidth(2 * lageurColonne), // Largeur colonne 1
                1: FlexColumnWidth(lageurColonne), // Largeur colonne 2
                2: FlexColumnWidth(lageurColonne),
                3: FlexColumnWidth(lageurColonne),
                4: FlexColumnWidth(lageurColonne),
                5: FlexColumnWidth(lageurColonne),
                6: FlexColumnWidth(lageurColonne),
                7: FlexColumnWidth(lageurColonne),
                8: FlexColumnWidth(lageurColonne),
              }, children: [
                TableRow(children: [
                  TableCell(
                    child: Text(
                      'Total Transactions on the period',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: TextField(
                      style: TextStyle(color: Colors.green),
                      controller: _totalDollarInController,
                      readOnly: true,
                    ),
                  ),
                  TableCell(
                    child: TextField(
                      style: TextStyle(color: Colors.green),
                      controller: _totalDirhamInController,
                      readOnly: true,
                    ),
                  ),
                  TableCell(
                    child: TextField(
                      style: TextStyle(color: Colors.green),
                      controller: _totalCFAInController,
                      readOnly: true,
                    ),
                  ),
                  TableCell(
                    child: SizedBox(
                      width: lageurColonne,
                      child: Container(
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  TableCell(
                    child: TextField(
                      style: TextStyle(color: Colors.red),
                      controller: _totalDollarOutController,
                      readOnly: true,
                    ),
                  ),
                  TableCell(
                    child: TextField(
                      style: TextStyle(color: Colors.red),
                      controller: _totalDirhamOutController,
                      readOnly: true,
                    ),
                  ),
                  TableCell(
                    child: TextField(
                      style: TextStyle(color: Colors.red),
                      controller: _totalCFAOutController,
                      readOnly: true,
                    ),
                  ),
                  TableCell(
                      child: SizedBox(
                    width: lageurColonne,
                    child: Container(
                      color: Colors.grey[400],
                    ),
                  ))
                ]),
              ]),
            ),
            Row(
              children: [
                SizedBox(
                  width: 720.0,
                  height: 120.0,
                ),
                SizedBox(
                  width: 120.0,
                  child: Text('Dollar (\$)'),
                ),
                SizedBox(
                  width: 120.0,
                  child: Text('Dirham (AED)'),
                ),
                SizedBox(
                  width: 120.0,
                  child: Text('CFA(XOF)'),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 240,
                  height: 240,
                ),
                SizedBox(
                  width: 480,
                  height: 240,
                  child: Text(
                    'BALANCE',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                SizedBox(
                  width: 120,
                  height: 240,
                  child: TextField(
                    controller: _soldeDollarController,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: (double.tryParse(
                                        _calculateSoldeDollard().toString()) ??
                                    1) >=
                                0
                            ? Colors.green
                            : Colors.red),
                  ),
                ),
                SizedBox(
                  width: 120,
                  height: 240,
                  child: TextField(
                    controller: _soldeDirhamController,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: (double.tryParse(
                                        _calculateSoldeDirham().toString()) ??
                                    1) >=
                                0
                            ? Colors.green
                            : Colors.red),
                  ),
                ),
                SizedBox(
                  width: 120,
                  height: 240,
                  child: TextField(
                    controller: _soldeCFAController,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            (double.tryParse(_calculateSoldeCFA().toString()) ??
                                        1) >=
                                    0
                                ? Colors.green
                                : Colors.red),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterNouvelleLigne,
        tooltip: "Ajouter une nouvelle ligne",
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDateCell() {
    return Padding(
      padding: const EdgeInsets.only(top: 25, right: 4, left: 4),
      child: Center(
        child: Text(
          DateFormat('dd/MM/yyyy').format(
            DateTime.now(),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDayCell() {
    return Padding(
      padding: const EdgeInsets.only(top: 25, right: 25, left: 12),
      child: Center(
        child: Text(
          DateFormat('EEEE', 'fr_FR').format(DateTime.now()).titleCase,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCurrencyInCell(int index, String key, String initialValue) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            border: InputBorder.none,
            fillColor: Color.fromARGB(255, 108, 194, 113)),
        onChanged: (value) {
          _updateCurrencyCell(index, key, double.tryParse(value) ?? 0.0);
        },
      ),
    );
  }

  Widget _buildCurrencyOutCell(int index, String key, String initialValue) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            border: InputBorder.none,
            fillColor: Color.fromARGB(255, 231, 49, 49)),
        onChanged: (value) {
          _updateCurrencyCell(index, key, double.tryParse(value) ?? 0.0);
        },
      ),
    );
  }

  Widget _buildLocationInCell() {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: TextField(
        decoration: const InputDecoration(
            border: InputBorder.none,
            fillColor: Color.fromARGB(255, 108, 194, 113)),
      ),
    );
  }

  Widget _buildLocationOutCell() {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: TextField(
        decoration: const InputDecoration(
            border: InputBorder.none,
            fillColor: Color.fromARGB(255, 231, 49, 49)),
      ),
    );
  }
}
