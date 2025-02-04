import 'package:flutter/material.dart';

class ChangeDevise extends StatefulWidget {
  const ChangeDevise({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangeDeviseState createState() => _ChangeDeviseState();
}

class _ChangeDeviseState extends State<ChangeDevise> {
  // Liste pour stocker les lignes
  List<List<String>> rows = [
    // Ligne initiale avec colonnes de base
    ["", "", "", "", "", ""]
  ];

  // Fonction pour ajouter une nouvelle ligne
  void _ajouterNouvelleLigne() {
    setState(() {
      rows.add(["", "", "", "", "", ""]); // Ajouter une ligne vide
    });
  }

  // Fonction pour supprimer une ligne
  void _supprimerLigne(int index) {
    setState(() {
      rows.removeAt(index); // Supprime la ligne à l'index donné
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tableau de Change"),
        centerTitle: true,
      ),
      body: Column(children: [
        SingleChildScrollView(
          scrollDirection:
              Axis.horizontal, // Permet le défilement horizontal si nécessaire
          child: SingleChildScrollView(
            child: Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FixedColumnWidth(40), // Colonne "N°" étroite
                1: FixedColumnWidth(120), // Colonne "Quantité"
                2: FixedColumnWidth(120), // Colonne "Devise"
                3: FixedColumnWidth(120), // Colonne "Taux"
                4: FixedColumnWidth(120), // Colonne "Valeur"
                5: FixedColumnWidth(120), // Colonne "Monnaie"
                6: FixedColumnWidth(40), // Colonne "Action" large
              },
              border: TableBorder.all(
                  color: Colors.grey), // Bordures autour des cellules
              children: [
                // Entête des colonnes
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    _buildHeaderCell("N°"),
                    _buildHeaderCell("Quantité"),
                    _buildHeaderCell("Devise"),
                    _buildHeaderCell("Taux"),
                    _buildHeaderCell("Monnaie"),
                    _buildHeaderCell("Montant"),
                    _buildHeaderCell(" "),
                  ],
                ),
                // Lignes dynamiques
                ...rows.asMap().entries.map((entry) {
                  int index = entry.key;
                  List<String> row = entry.value;
                  return TableRow(
                    children: [
                      _buildCell((index + 1).toString()), // N°
                      ...row.take(5).map((cell) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                row[row.indexOf(cell)] = value;
                              });
                            },
                          ),
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _supprimerLigne(index),
                        ),
                      ),
                    ],
                  );
                })
              ],
            ),
          ),
        ),
        Total()
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterNouvelleLigne, // Ajouter une ligne au clic
        tooltip: "Ajouter une nouvelle ligne",
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget pour construire une cellule d'entête
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

  // Widget pour construire une cellule de données
  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(text),
      ),
    );
  }
}

class Total extends StatelessWidget {
  const Total({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(400), // Première colonne: largeur 180
          1: FixedColumnWidth(280), // Deuxième colonne: largeur 50
        },
        border:
            TableBorder.all(color: Colors.grey), // Bordures autour des cellules
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.grey[300]),
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Montant Total (HT)',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: const TextField(
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
