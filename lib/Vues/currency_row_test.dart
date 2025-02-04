import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marjeno/Modeles/city.dart';
import 'package:marjeno/Modeles/currency.dart';
import 'package:intl/intl.dart';

class CurrencyRowTest extends StatefulWidget {
  final City ville;
  final Currency devise;

  const CurrencyRowTest({super.key, required this.devise, required this.ville});

  @override
  State<CurrencyRowTest> createState() => _CurrencyRowTestState();
}

class _CurrencyRowTestState extends State<CurrencyRowTest> {
  late TextEditingController currencyController;

  @override
  void initState() {
    super.initState();
    currencyController = TextEditingController();
    getCurrencyValue();
  }

  @override
  void dispose() {
    currencyController.dispose();
    super.dispose();
  }

  Future<void> getCurrencyValue() async {
    final DateTime today = DateTime.now();
    final String todayFormatted = DateFormat('dd-MM-yyyy').format(today);
    final currencyCollection = FirebaseFirestore.instance
        .collection("Marché-Régional")
        .doc(widget.ville.nom)
        .collection("Date");

    try {
      // Tente de récupérer les données pour la date d'aujourd'hui
      DocumentSnapshot<Map<String, dynamic>> todaySnapshot =
          await currencyCollection.doc(todayFormatted).get();

      if (todaySnapshot.exists) {
        _loadCurrencyData(todaySnapshot['Devise']);
      } else {
        // Si aucune donnée pour aujourd'hui, récupérer les dates disponibles
        QuerySnapshot<Map<String, dynamic>> availableDates =
            await currencyCollection
                .orderBy(FieldPath.documentId, descending: true)
                .get();

        if (availableDates.docs.isNotEmpty) {
          // Charger les données pour la date la plus récente
          DocumentSnapshot<Map<String, dynamic>> latestSnapshot =
              availableDates.docs.first;
          _loadCurrencyData(latestSnapshot['Devise']);
        }
      }
    } catch (e) {
      // Gérez les erreurs (par exemple, afficher un message d'erreur à l'utilisateur)
      print("Erreur lors de la récupération des données : $e");
    }
  }

// Méthode pour charger les données dans le contrôleur
  void _loadCurrencyData(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();
    if (data != null) {
      Map<String, dynamic> deviseMap = data;
      if (deviseMap[widget.devise.name] != null) {
        setState(() {
          currencyController.text = deviseMap[widget.devise.name].toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(widget.devise.image, width: 30, height: 30),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(widget.devise.name),
            ),
            SizedBox(
              width: 160,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text(
                      'Valeur ${widget.devise.unite} ${widget.devise.symbole} (${widget.ville.monnaie.symbole})'),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                controller: currencyController,
              ),
            ),
            SizedBox(width: 100),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
