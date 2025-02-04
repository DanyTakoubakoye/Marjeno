import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FindLatestDate extends StatefulWidget {
  const FindLatestDate({super.key});

  @override
  _FindLatestDateState createState() => _FindLatestDateState();
}

class _FindLatestDateState extends State<FindLatestDate> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String?
      date; // Variable pour stocker la dernière date trouvée avec des données

  Future<void> _findLatestDateWithData() async {
    try {
      // Accéder à la collection "Marché-Régional" > Document "ville" > Collection "Date"
      CollectionReference datesCollection = _firestore
          .collection("Marché-Régional")
          .doc("Cotonou")
          .collection("Date");

      // Obtenir tous les documents de la collection
      QuerySnapshot querySnapshot = await datesCollection.get();

      // Filtrer les documents qui ont des données (vérifier la clé "Devise")
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

  // Fonction pour convertir un ID de document (format "dd-MM-yyyy") en DateTime
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

  @override
  void initState() {
    super.initState();
    _findLatestDateWithData(); // Recherche la dernière date dès le démarrage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dernière date avec données'),
      ),
      body: Center(
        child: date != null
            ? Text("Dernière date avec données : $date",
                style: TextStyle(fontSize: 18))
            : Text("Aucune date avec des données trouvée.",
                style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
