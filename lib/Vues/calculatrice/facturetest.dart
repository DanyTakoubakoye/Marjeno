import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
import 'package:marjeno/Vues/recherche_facture.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FactureTest extends StatefulWidget {
  const FactureTest({super.key});

  @override
  _FactureTest createState() => _FactureTest();
}

class _FactureTest extends State<FactureTest> {
  // Contrôleurs pour les champs texte
  final TextEditingController clientController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController factureNumberController = TextEditingController();

  // Liste pour stocker les lignes
  List<Map<String, dynamic>> rows = [
    {
      'N°': 1,
      'Masse Lingot': 0.0,
      'Carat Lingot': 0.0,
      'Prix Carat': 0.0,
      'Prix Lingot': 0.0,
    }
  ];

  // Fonction pour ajouter une nouvelle ligne
  void _ajouterNouvelleLigne() {
    setState(() {
      rows.add({
        'N°': rows.length + 1,
        'Masse Lingot': 0.0,
        'Carat Lingot': 0.0,
        'Prix Carat': rows[0]['Prix Carat'],
        'Prix Lingot': 0.0,
      });
    });
  }

  // Fonction pour calculer la somme de la colonne "Prix Lingot"
  double _calculateTotalPrixLingot() {
    return rows.fold(0.0, (sum, row) => sum + row['Prix Lingot']);
  }

  // Fonction pour formater les nombres en format comptabilité
  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(
        locale: 'fr_FR', symbol: '', decimalDigits: value % 1 == 0 ? 0 : 2);
    return formatter
        .format(value)
        .replaceAll('.', ' ,')
        .replaceAll('\u00A0', ' ');
  }

  // Fonction pour supprimer une ligne
  void _supprimerLigne(int index) {
    setState(() {
      rows.removeAt(index);
      for (int i = 0; i < rows.length; i++) {
        rows[i]['N°'] = i + 1;
      }
    });
  }

  // Fonction pour mettre à jour une cellule
  void _updateCell(int index, String key, double value) {
    setState(() {
      rows[index][key] = value;
      double masseLingot = rows[index]['Masse Lingot'];
      double caratLingot = rows[index]['Carat Lingot'];
      double prixCarat = rows[index]['Prix Carat'];
      rows[index]['Prix Lingot'] = masseLingot * caratLingot * prixCarat;
    });
  }

  // Générer le fichier PDF
  Future<void> _genererPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "MARJENO WALA",
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              "Facture Achat Colis d'or",
              style: pw.TextStyle(fontSize: 18, color: PdfColors.grey700),
            ),
            pw.Divider(),
            pw.SizedBox(height: 20),
            pw.Text("Client : ${clientController.text}"),
            pw.Text("Contact : ${contactController.text}"),
            pw.Text("Numéro de Facture : ${factureNumberController.text}"),
            pw.Text(
              "Date : ${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
              style: pw.TextStyle(fontSize: 14),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('N°',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 12)),
                    pw.Text('Masse Lingot',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 12)),
                    pw.Text('Carat Lingot',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 12)),
                    pw.Text('Prix/Carat',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 12)),
                    pw.Text('Prix Lingot',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 12)),
                  ],
                ),
                ...rows.map(
                  (row) => pw.TableRow(
                    children: [
                      pw.Text(row['N°'].toString()),
                      pw.Text(row['Masse Lingot'].toString()),
                      pw.Text(row['Carat Lingot'].toString()),
                      pw.Text(row['Prix Carat'].toString()),
                      pw.Text(row['Prix Lingot'].toStringAsFixed(2)),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.SizedBox(width: 30),
                pw.Text(
                  'Total: ',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(width: 300),
                pw.Text(
                  _formatCurrency(_calculateTotalPrixLingot()),
                  style: pw.TextStyle(
                      color: PdfColors.green,
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      ),
    );

    // Visualisation du PDF
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  Future<void> _sauvegarderFacture() async {
    try {
      CollectionReference factures =
          FirebaseFirestore.instance.collection('factures');

      await factures.doc(factureNumberController.text).set({
        'client': clientController.text,
        'contact': contactController.text,
        'factureNumber': factureNumberController.text,
        'date': DateFormat('dd-MM-yyyy').format(DateTime.now()),
        'rows': rows,
        'totalPrixLingot': _calculateTotalPrixLingot(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Facture sauvegardée avec succès !')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sauvegarde : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Facture Achat Colis d'or"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _sauvegarderFacture,
                child: const Text('Sauvegarder la Facture'),
              ),
              ElevatedButton(
                onPressed: _genererPDF,
                child: const Text('Générer la Facture'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchInvoiceScreen()),
                  );
                },
                child: const Text('Retrouver une Facture'),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Client :",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 120),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: clientController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              const SizedBox(width: 130),
              const Text(
                "Date :",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 60),
              Text(
                DateFormat('dd-MM-yyyy').format(DateTime.now()),
                style: const TextStyle(
                    backgroundColor: Colors.blueGrey,
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Contact Client :",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 50),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: contactController,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              const SizedBox(width: 130),
              const Text(
                "N° Facture :",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 30),
              SizedBox(
                width: 70,
                child: TextField(
                  controller: factureNumberController,
                  style: const TextStyle(
                      backgroundColor: Colors.blueGrey,
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Card(
            elevation: 5, // Ajout d'une ombre douce
            margin: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                border: TableBorder.symmetric(
                  inside: BorderSide(color: Colors.grey[300]!, width: 1),
                ), // Lignes uniquement entre les colonnes
                columnWidths: const <int, TableColumnWidth>{
                  0: FixedColumnWidth(50),
                  1: FixedColumnWidth(120),
                  2: FixedColumnWidth(120),
                  3: FixedColumnWidth(120),
                  4: FixedColumnWidth(120),
                  5: FixedColumnWidth(50),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    children: [
                      _buildHeaderCell("N°"),
                      _buildHeaderCell("Masse Lingot"),
                      _buildHeaderCell("Carat Lingot"),
                      _buildHeaderCell("Prix/Carat"),
                      _buildHeaderCell("Prix Lingot"),
                      _buildHeaderCell(""),
                    ],
                  ),
                  ...rows.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> row = entry.value;
                    return TableRow(
                      children: [
                        _buildCell(row['N°'].toString()),
                        _buildEditableCell(index, 'Masse Lingot',
                            row['Masse Lingot'].toString()),
                        _buildEditableCell(index, 'Carat Lingot',
                            row['Carat Lingot'].toString()),
                        _buildEditableCell(
                            index, 'Prix Carat', row['Prix Carat'].toString()),
                        _buildTextCell(_formatCurrency(row['Prix Lingot'])),
                        _buildActionCell(index),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 130), // Alignement sous "Masse Lingot"
                const Text(
                  'Total Prix Colis:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 350), // Alignement sous "Prix Lingot"
                Text(
                  _formatCurrency(_calculateTotalPrixLingot()),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 120) // Alignement sous "Prix Lingot"
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterNouvelleLigne,
        tooltip: "Ajouter une nouvelle ligne",
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(text)),
    );
  }

  Widget _buildEditableCell(int index, String key, String initialValue) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(border: InputBorder.none),
        onChanged: (value) {
          _updateCell(index, key, double.tryParse(value) ?? 0.0);
        },
      ),
    );
  }

  Widget _buildTextCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildActionCell(int index) {
    return Center(
      child: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () => _supprimerLigne(index),
      ),
    );
  }
}
