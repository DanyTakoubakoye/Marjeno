import 'package:flutter/material.dart';
import 'package:marjeno/Modeles/city.dart';
import 'package:marjeno/Vues/acceuil.dart';
import 'cityMarket.dart';
import 'package:marjeno/Modeles/city.dart' as citydata;

class Visiteur extends StatelessWidget {
  final List<City> cities = citydata.cities;
  Visiteur({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
            padding: EdgeInsets.only(left: 12), child: Icon(Icons.more_vert)),
        title: const Text('MARJENO'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.account_circle),
          )
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
              child: Text(
                'VISITEUR',
                style: TextStyle(
                    color: Colors.yellow, fontSize: 16, letterSpacing: 2),
              ),
            ),
            SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Acceuil(),
                          ));
                    },
                    child: Text('Connecter')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Acceuil(),
                          ));
                    },
                    child: Text('Créer un Compte')),
              ],
            ),
            SizedBox(height: 13),
            AppBar(
              backgroundColor: Colors.amber,
              centerTitle: true,
              title: Text("Marché Régional"),
            ),
            Expanded(
              child: regionalMarketListView(
                  context, cities), // Inclure le ListView
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
