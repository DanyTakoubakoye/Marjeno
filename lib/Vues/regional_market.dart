import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:marjeno/Modeles/city.dart';
import 'cityMarket.dart';
import 'package:marjeno/Modeles/city.dart' as citydata;


class Regionalmarket extends StatefulWidget {
  Regionalmarket({super.key});
  final List<City> cities = citydata.cities;
  final DateTime date = DateTime.now();

  Widget regionalMarketListView(BuildContext context, List<City> cities) {
    return ListView.builder(
      itemCount: cities.length,
      itemBuilder: (context, index) {
        return CityMarket(ville: cities[index]);
      },
    );
  }

  @override
  State<Regionalmarket> createState() => _RegionalmarketState();
}

class _RegionalmarketState extends State<Regionalmarket> {
  final CollectionReference regionalMarket =
      FirebaseFirestore.instance.collection('RegionalMarket');

  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: Icon(Icons.more_vert),
        centerTitle: true,
        title: Text("Marché Régional"),
        actions: [
          Padding(
              padding: EdgeInsets.all(20), child: Icon(Icons.account_circle))
        ],
      ),
      body: ListView.builder(
        itemCount: widget.cities.length,
        itemBuilder: (context, index) {
          return CityMarket(ville: widget.cities[index]);
        },
      ),
    );
  }
}
