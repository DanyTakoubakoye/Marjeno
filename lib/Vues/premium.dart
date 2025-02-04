import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marjeno/Controleurs/Services/Firebase/authentification.dart';
import 'package:marjeno/Modeles/city.dart';
import 'package:marjeno/Vues/acceuil.dart';
import 'package:marjeno/Vues/calculatrice/carat.dart';
import 'package:marjeno/Vues/calculatrice/change.dart';
import 'package:marjeno/Vues/calculatrice/facture.dart';

import 'package:marjeno/Vues/currenciesdailyvaluentriespermarket.dart';
import 'package:marjeno/Vues/notre_fixing.dart';

import 'cityMarket.dart';
import 'package:marjeno/Modeles/city.dart' as citydata;

class Premium extends StatefulWidget {
  const Premium({super.key});

  @override
  State<Premium> createState() => _PremiumState();
}

class _PremiumState extends State<Premium> {
  final List<City> cities = citydata.cities;
  final DateTime date = DateTime.now();
  final User? user = Authentification().currentuser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(Icons.more_vert),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('MARJENO'),
              const SizedBox(width: 25),
              ElevatedButton(
                onPressed: () {
                  Authentification().logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Acceuil()),
                  );
                },
                child: const Text('Déconnecter'),
              ),
            ],
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.account_circle),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 25,
              width: 160,
              color: Colors.blue,
              alignment: Alignment.center,
              child: const Text(
                'Premium',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeterminationCarat()),
                    );
                  },
                  child: const Text('Détermination Carat'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangeDevise()),
                    );
                  },
                  child: const Text('Vente de Devise'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Facture()),
                    );
                  },
                  child: const Text('Factures '),
                ),
              ],
            ),
            const SizedBox(height: 13),
            AppBar(
              backgroundColor: Colors.amber,
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Marché Régional"),
                  Text(DateFormat("dd-MM-yyyy").format(date)),
                  if (user?.email == "danytakoubakoye@gmail.com")
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CurrenciesDalyValueEntryPerMarket()),
                            );
                          },
                          child: const Text(
                            "Renseigner le marché",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotreFixing()),
                            );
                          },
                          child: const Text(
                            "Voir notre fixing",
                            style: TextStyle(color: Colors.blue, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Expanded(
              child: regionalMarketListView(context, cities),
            ),
          ],
        ),
      ),
    );
  }

  regionalMarketListView(BuildContext context, List<City> cities) {
    return ListView.builder(
      itemCount: cities.length,
      itemBuilder: (context, index) {
        return CityMarket(ville: cities[index]);
      },
    );
  }
}
