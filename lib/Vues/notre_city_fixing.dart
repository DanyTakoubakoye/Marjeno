import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marjeno/Modeles/city.dart' as citydata;
import 'package:marjeno/Modeles/city.dart';
import 'package:marjeno/Vues/cityMarket.dart';

import 'package:marjeno/Modeles/currency.dart';

class NotreCityFixing extends StatefulWidget {
  final City laville;
  final List<City> cities = citydata.cities;

  NotreCityFixing({super.key, required this.laville});

  @override
  State<NotreCityFixing> createState() => _NotreCityFixingState();
}

class _NotreCityFixingState extends State<NotreCityFixing> {
  String goldPrice1 = "Chargement..."; // Initialisation de la variable
  String goldPrice = "0.0";

  final TextEditingController _coursDollarController = TextEditingController();
  final TextEditingController _notreFixingController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? date;
  Currency devise = dollar;
  @override
  void initState() {
    super.initState();
    _coursDollarController.addListener(_calulatefixing);

    // Récupération du prix de l'or
    CityMarket.fetchGoldPrice().then((price) {
      setState(() {
        goldPrice = price;
        goldPrice1 = "$price USD/Once";
      });

      // Calcul une fois le prix de l'or récupéré
      _calulatefixing();
    });

    _initializeData().then((_) {
      _calulatefixing(); // Calcul après chargement de la valeur initiale
    });
  }

  @override
  void dispose() {
    _coursDollarController.dispose();
    super.dispose();
  }

  void _calulatefixing() {
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

  /// Fonction principale pour initialiser la date et charger la valeur
  Future<void> _initializeData() async {
    await _findLatestDateWithData(); // Trouver la dernière date valide
    if (date != null) {
      await _loadCurrencyValue(); // Charger la valeur associée si une date valide existe
    }
  }

  /// Recherche de la dernière date valide avec des données
  Future<void> _findLatestDateWithData() async {
    try {
      // Accéder à la collection "Marché-Régional" > Document "ville" > Collection "Date"
      CollectionReference datesCollection = _firestore
          .collection("Marché-Régional")
          .doc(widget.laville.nom)
          .collection("Date");

      // Obtenir tous les documents de la collection
      QuerySnapshot querySnapshot = await datesCollection.get();

      // Filtrer les documents qui contiennent une clé "Devise"
      List<QueryDocumentSnapshot> documentsWithData =
          querySnapshot.docs.where((doc) {
        return doc.data() is Map<String, dynamic> &&
            (doc.data() as Map<String, dynamic>).containsKey("Devise");
      }).toList();

      if (documentsWithData.isEmpty) {
        setState(() {
          date = null; // Aucune date trouvée
        });
        return;
      }

      // Trier les documents par date descendante
      documentsWithData.sort((a, b) {
        DateTime dateA = _parseDate(a.id);
        DateTime dateB = _parseDate(b.id);
        return dateB.compareTo(dateA); // Trier par ordre décroissant
      });

      // Mettre à jour la variable `date` avec l'ID du premier document trié
      setState(() {
        date = documentsWithData.first.id;
      });
    } catch (e) {
      print("Erreur lors de la récupération de la date : $e");
      setState(() {
        date = null; // En cas d'erreur
      });
    }
  }

  /// Convertit une chaîne de date au format "dd-MM-yyyy" en objet DateTime
  DateTime _parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr
          .split("-")
          .reversed
          .join("-")); // "dd-MM-yyyy" -> "yyyy-MM-dd"
    } catch (e) {
      print("Erreur lors de l'analyse de la date : $dateStr");
      return DateTime(0); // Retourner une date par défaut en cas d'erreur
    }
  }

  /// Récupère la valeur de la devise pour la date et la ville spécifiées
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
      body: Card(
        elevation: 25,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Ligne pour afficher le nom de la ville et d'autres informations
                Row(
                  children: [
                    Text(
                      widget.laville.nom,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 17),
                    Image.asset(
                      widget.laville.image,
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Ligne pour afficher le cours officiel et un champ de saisie pour le cours Dollar
                Row(
                  children: [
                    const Text(
                      "Cours Officiel : ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Expanded(
                      child: Text(
                        goldPrice1,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text("Taux dollars: "),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _coursDollarController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Section "Notre Fixing"
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 27,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Notre Fixing',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _notreFixingController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
