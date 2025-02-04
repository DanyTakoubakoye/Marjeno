import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:marjeno/Modeles/city.dart' as citydata;
import 'package:marjeno/Modeles/city.dart';

import 'package:marjeno/Modeles/currency.dart' as currencydata;
import 'package:marjeno/Modeles/currency.dart';


final List<City> cities = citydata.cities;

final List<Currency> currencies = currencydata.currencies;

String? formatedSelectedDate;
String? formatedSelectedHoure;

class CurrenciesDalyValueEntryPerMarket extends StatefulWidget {
  const CurrenciesDalyValueEntryPerMarket({super.key});
  @override
  _CurrenciesDalyValueEntryPerMarketState createState() =>
      _CurrenciesDalyValueEntryPerMarketState();
}

class _CurrenciesDalyValueEntryPerMarketState
    extends State<CurrenciesDalyValueEntryPerMarket> {
  City? selectedCity;
  DateTime selectedDate = DateTime.now();

  final Map<Currency, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    // Initialiser un contrôleur pour chaque devise
    for (var currency in currencies) {
      controllers[currency] = TextEditingController();
    }
  }

  @override
  void dispose() {
    // Libérer tous les contrôleurs
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _submit() async {
    if (selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez choisir une ville.')),
      );
      return;
    }

    // Récupérer les valeurs saisies
    final Map<String, double> values = {};
    controllers.forEach((currency, controller) {
      final value = double.tryParse(controller.text);
      if (value != null) {
        values[currency.name] = value;
      }
    });

    if (values.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez saisir au moins une valeur.')),
      );
      return;
    }

    // Formater la date
    final String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

    // Référence Firestore
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Ajouter ou mettre à jour le document dans la sous-collection "Date"
      await firestore
          .collection('Marché-Régional')
          .doc(selectedCity!.nom)
          .collection('Date')
          .doc(formattedDate)
          .set({
        'Devise': values,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Données enregistrées avec succès.'),
          backgroundColor: const Color.fromARGB(255, 54, 244, 63),
          showCloseIcon: true,
        ),
      );

      // Réinitialiser les champs de saisie
      for (var controller in controllers.values) {
        controller.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'enregistrement : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Valeurs journalières des devises')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<City>(
              value: selectedCity,
              hint: Text('Sélectionnez une ville'),
              items: cities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city.nom),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text.rich(TextSpan(
                  text: 'Date :',
                  children: [
                    TextSpan(
                        text: DateFormat('dd-MM-yyyy').format(selectedDate),
                        style: TextStyle(
                            color: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(255, 68, 68, 67)))
                  ],
                )),
                const SizedBox(width: 10),
                Text.rich(TextSpan(text: 'Heure:', children: [
                  TextSpan(
                      text: DateFormat('H:MM').format(selectedDate),
                      style: TextStyle(
                          color: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 68, 68, 67)))
                ])),
                const SizedBox(width: 50),
                ElevatedButton(
                  onPressed: _pickDate,
                  child: const Text('Choisir la date'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: currencies
                    .where((currency) => currency != selectedCity?.monnaie)
                    .map((currency) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: controllers[currency],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '${currency.name} (${currency.symbole})',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Valider'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
