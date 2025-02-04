import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:marjeno/Modeles/city.dart';
import 'package:marjeno/Modeles/currency.dart' as currencydata;

import 'package:marjeno/Modeles/currency.dart';
import 'package:marjeno/Vues/currencyRow.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class CityMarket extends StatefulWidget {
  final List<Currency> currencies = currencydata.currencies;
  final City ville;
  CityMarket({super.key, required this.ville});

  @override
  State<CityMarket> createState() => _CityMarketState();
  // Méthode statique pour récupérer le prix de l'or
  static Future<String> fetchGoldPrice() async {
    const String apiUrl = "https://www.goldapi.io/api/XAU/USD";
    const String apiKey = "goldapi-14p1xnsm5y3tzyq-io";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"x-access-token": apiKey, "Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['price'].toStringAsFixed(2);
      } else {
        return "Erreur status: ${response.statusCode}";
      }
    } catch (e) {
      return "Erreur normale: $e";
    }
  }
}

class _CityMarketState extends State<CityMarket> {
  @override
  void initState() {
    super.initState();
// Assignation de l'instance actuelle au singleton
    fetchGoldPrice();
  }

  @override
  void dispose() {
// Nettoyage de l'instance statique
    super.dispose();
  }

  DateTime date = DateTime.now();
  String goldPrice = "Chargement....";

  final String apiUrl =
      "https://www.goldapi.io/api/XAU/USD"; // Cours de l'or en USD
  final String apiKey =
      "goldapi-14p1xnsm5y3tzyq-io"; // Remplacez par votre clé API

  Future<void> fetchGoldPrice() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"x-access-token": apiKey, "Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          goldPrice =
              "${data['price'].toStringAsFixed(2)} USD"; // Récupère le prix
        });
      } else {
        setState(() {
          goldPrice = "Erreur : ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        goldPrice = "Erreur : $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15.00, vertical: 15.00),
      elevation: 10.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(widget.ville.nom,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(width: 24),
              Image.asset(widget.ville.image),
              SizedBox(width: 100),
              Text(
                (DateFormat("dd-MM-yyyy").format(date)).toString(),
                style: TextStyle(backgroundColor: Colors.green),
              ),
              SizedBox(
                width: 170,
              ),
              Text(" Cours Officiel: "),
              SizedBox(
                width: 12,
              ),
              Text(
                goldPrice,
                style: TextStyle(
                    backgroundColor: const Color.fromARGB(255, 226, 230, 20)),
              ),
            ],
          ),
          SizedBox(height: 20),
          Column(
              children: widget.currencies
                  .where((currency) => currency != widget.ville.monnaie)
                  .map((currency) =>
                      CurrencyRow(devise: currency, ville: widget.ville))
                  .toList()),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
