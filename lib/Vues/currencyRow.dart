import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marjeno/Modeles/city.dart';
import 'package:marjeno/Modeles/currency.dart';

class CurrencyRow extends StatefulWidget {
  final City ville;
  final Currency devise;

  const CurrencyRow({
    super.key,
    required this.devise,
    required this.ville,
  });

  @override
  State<CurrencyRow> createState() => _CurrencyRowState();
}

class _CurrencyRowState extends State<CurrencyRow> {
  late TextEditingController currencyController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String?
      date; // Variable pour stocker la dernière date trouvée avec des données

  @override
  void initState() {
    super.initState();
    currencyController = TextEditingController();
    _initializeData(); // Appel à la fonction qui initialise les données
  }

  @override
  void dispose() {
    currencyController.dispose();
    super.dispose();
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
          .doc(widget.ville.nom)
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
          .doc(widget.ville.nom)
          .collection("Date")
          .doc(date);

      DocumentSnapshot<Map<String, dynamic>> valeurdevise =
          await currencyValue.get();

      if (valeurdevise.exists) {
        Map<String, dynamic>? donnee = valeurdevise.data();
        if (donnee != null && donnee['Devise'] != null) {
          Map<String, dynamic> deviseMap = donnee['Devise'];
          String? value = deviseMap[widget.devise.name]?.toString();
          setState(() {
            currencyController.text = value ??
                "Valeur non disponible"; // Affiche la valeur de la devise
            // ou le texte "Valeur non disponible"
          });
        } else {
          setState(() {
            currencyController.text = "Valeur non disponible";
          });
        }
      } else {
        setState(() {
          currencyController.text = "Valeur non disponible";
        });
      }
    } catch (e) {
      print("Erreur lors de la récupération de la devise : $e");
      setState(() {
        currencyController.text = "Valeur non disponible";
      });
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
