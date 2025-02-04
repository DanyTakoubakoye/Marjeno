import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marjeno/Modeles/city.dart';
import 'package:marjeno/Modeles/city.dart' as citydata;
import 'package:marjeno/Modeles/currency.dart';
import 'package:marjeno/Vues/cityMarket.dart';

class NotreFixing extends StatelessWidget {
  const NotreFixing({super.key});

  @override
  Widget build(BuildContext context) {
    final List<City> cities = citydata.cities;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 30,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Marjeno Hunkuna ?',
              style: TextStyle(fontSize: 16, color: Colors.amber),
            ),
            const SizedBox(width: 35),
            Text(
              DateFormat("dd-MM-yyyy").format(DateTime.now()),
              style: const TextStyle(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          return CityFixingCard(laville: cities[index]);
        },
      ),
    );
  }
}

class CityFixingCard extends StatefulWidget {
  final City laville;

  const CityFixingCard({super.key, required this.laville});

  @override
  State<CityFixingCard> createState() => _CityFixingCardState();
}

class _CityFixingCardState extends State<CityFixingCard> {
  String goldPrice1 = "Chargement...";
  String goldPrice = "0.0";

  final TextEditingController _coursDollarController = TextEditingController();
  final TextEditingController _notreFixingController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? date;
  Currency devise = dollar;

  @override
  void initState() {
    super.initState();
    _coursDollarController.addListener(_calculateFixing);

    CityMarket.fetchGoldPrice().then((price) {
      setState(() {
        goldPrice = price;
        goldPrice1 = "$price USD/Once";
      });
      _calculateFixing();
    });

    _initializeData().then((_) {
      _calculateFixing();
    });
  }

  @override
  void dispose() {
    _coursDollarController.dispose();
    super.dispose();
  }

  void _calculateFixing() {
    final double? tauxdollar = double.tryParse(_coursDollarController.text);
    final double? coursgold = double.tryParse(goldPrice);
    if (tauxdollar != null && coursgold != null) {
      final double notrecityfixing =
          ((coursgold - 35) / (31.104 * 24)) * tauxdollar;
      _notreFixingController.text = notrecityfixing.toString();
    } else {
      _notreFixingController.text = "En attente de valeur";
    }
  }

  Future<void> _initializeData() async {
    await _findLatestDateWithData();
    if (date != null) {
      await _loadCurrencyValue();
    }
  }

  Future<void> _findLatestDateWithData() async {
    try {
      CollectionReference datesCollection = _firestore
          .collection("Marché-Régional")
          .doc(widget.laville.nom)
          .collection("Date");

      QuerySnapshot querySnapshot = await datesCollection.get();

      List<QueryDocumentSnapshot> documentsWithData =
          querySnapshot.docs.where((doc) {
        return doc.data() is Map<String, dynamic> &&
            (doc.data() as Map<String, dynamic>).containsKey("Devise");
      }).toList();

      if (documentsWithData.isEmpty) {
        setState(() {
          date = null;
        });
        return;
      }

      documentsWithData.sort((a, b) {
        DateTime dateA = _parseDate(a.id);
        DateTime dateB = _parseDate(b.id);
        return dateB.compareTo(dateA);
      });

      setState(() {
        date = documentsWithData.first.id;
      });
    } catch (e) {
      print("Erreur lors de la récupération de la date : $e");
      setState(() {
        date = null;
      });
    }
  }

  DateTime _parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr.split("-").reversed.join("-"));
    } catch (e) {
      print("Erreur lors de l'analyse de la date : $dateStr");
      return DateTime(0);
    }
  }

  Future<void> _loadCurrencyValue() async {
    try {
      final currencyValue = _firestore
          .collection("Marché-Régional")
          .doc(widget.laville.nom)
          .collection("Date")
          .doc(date);

      DocumentSnapshot<Map<String, dynamic>> valeurdevise =
          await currencyValue.get();

      if (valeurdevise.exists) {
        Map<String, dynamic>? donnee = valeurdevise.data();
        if (donnee != null && donnee['Devise'] != null) {
          Map<String, dynamic> deviseMap = donnee['Devise'];
          String? value = deviseMap[devise.name]?.toString();
          setState(() {
            _coursDollarController.text = value ?? "Valeur non disponible";
          });
        } else {
          setState(() {
            _coursDollarController.text = "Valeur non disponible";
          });
        }
      } else {
        setState(() {
          _coursDollarController.text = "Valeur non disponible";
        });
      }
    } catch (e) {
      print("Erreur lors de la récupération de la devise : $e");
      setState(() {
        _coursDollarController.text = "Valeur non disponible";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.laville.nom,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _coursDollarController,
                    decoration: const InputDecoration(
                      labelText: 'Taux Dollar',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _notreFixingController,
                    decoration: const InputDecoration(
                      labelText: 'Notre Fixing',
                    ),
                    readOnly: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(goldPrice1, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
