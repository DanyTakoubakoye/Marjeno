import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class SearchInvoiceScreen extends StatefulWidget {
  const SearchInvoiceScreen({super.key});

  @override
  _SearchInvoiceScreenState createState() => _SearchInvoiceScreenState();
}

class _SearchInvoiceScreenState extends State<SearchInvoiceScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> invoiceList = [];
  Map<String, dynamic>? selectedInvoice;

  Future<void> searchInvoice(String query) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("factures").get();

    List<Map<String, dynamic>> tempInvoiceList = [];
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data["factureNumber"] == query ||
          data["date"] == query ||
          data["client"] == query) {
        tempInvoiceList.add(data);
      }
    }

    setState(() {
      invoiceList = tempInvoiceList;
      selectedInvoice = null;
    });
  }

  Future<void> generatePdf() async {
    if (selectedInvoice == null) return;

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text("Facture ${selectedInvoice!["factureNumber"]}",
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text("Client: ${selectedInvoice!["client"]}"),
              pw.Text("Date: ${selectedInvoice!["date"]}"),
              pw.Text("Contact: ${selectedInvoice!["contact"]}"),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: [
                  "N°",
                  "Masse Lingot",
                  "Carat Lingot",
                  "Prix Carat",
                  "Prix Lingot"
                ],
                data: (selectedInvoice!["rows"] as List<dynamic>)
                    .map(
                      (entry) => [
                        entry["N°"],
                        entry["Masse Lingot"],
                        entry["Carat Lingot"],
                        entry["Prix Carat"],
                        entry["Prix Lingot"]
                      ],
                    )
                    .toList(),
              ),
              pw.SizedBox(height: 10),
              pw.Text("Total: ${selectedInvoice!["totalPrixLingot"]}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recherche de Facture"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Rechercher par numéro, date ou client",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => searchInvoice(_searchController.text),
                ),
              ),
            ),
            SizedBox(height: 10),
            invoiceList.isNotEmpty
                ? SizedBox(
                    height: 120,
                    child: ListView.builder(
                      itemCount: invoiceList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              "Facture: ${invoiceList[index]["factureNumber"]}"),
                          onTap: () {
                            setState(() {
                              selectedInvoice = invoiceList[index];
                            });
                          },
                          subtitle:
                              Text("Client: ${invoiceList[index]["client"]}"),
                          trailing: Text("Date: ${invoiceList[index]["date"]}"),
                        );
                      },
                    ),
                  )
                : Text("Aucune facture trouvée"),
            if (selectedInvoice != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Facture: ${selectedInvoice!["factureNumber"]}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Client: ${selectedInvoice!["client"]}"),
                    Text("Date: ${selectedInvoice!["date"]}"),
                    Text("Contact: ${selectedInvoice!["contact"]}"),
                    SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text("N°")),
                            DataColumn(label: Text("Masse Lingot")),
                            DataColumn(label: Text("Carat Lingot")),
                            DataColumn(label: Text("Prix Carat")),
                            DataColumn(label: Text("Prix Lingot")),
                          ],
                          rows: (selectedInvoice!["rows"] as List<dynamic>)
                              .map(
                                (entry) => DataRow(
                                  cells: [
                                    DataCell(Text(entry["N°"].toString())),
                                    DataCell(
                                        Text(entry["Masse Lingot"].toString())),
                                    DataCell(
                                        Text(entry["Carat Lingot"].toString())),
                                    DataCell(
                                        Text(entry["Prix Carat"].toString())),
                                    DataCell(
                                        Text(entry["Prix Lingot"].toString())),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Total: ${selectedInvoice!["totalPrixLingot"]}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: generatePdf,
                      child: Text("Générer PDF"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
