import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AccountManagerIbrahim extends StatefulWidget {
  const AccountManagerIbrahim({super.key});

  @override
  _AccountManagerIbrahimState createState() => _AccountManagerIbrahimState();
}

class _AccountManagerIbrahimState extends State<AccountManagerIbrahim> {
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String selectedCurrency = 'Dollar';
  String movementType = 'Deposit';
  DateTime selectedDate = DateTime.now(); // Par défaut : aujourd'hui

  Map<String, dynamic>? accountData;

  Future<void> recordMovement({
    required String accountNumber,
    required String currency,
    required String type,
    required double amount,
    required String location,
    required DateTime date,
  }) async {
    final firestore = FirebaseFirestore.instance;

    final docRef = firestore.collection('Cash-Account').doc(accountNumber);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("Compte introuvable.");
      }

      final data = snapshot.data() as Map<String, dynamic>;
      final balances = data['balances'] ?? {};
      final currencyData = balances[currency] ??
          {
            'totalMovements': 0.0,
            'balance': 0.0,
          };

      final totalMovements =
          (currencyData['totalMovements'] as double) + amount;
      final balance = type == 'deposit'
          ? (currencyData['balance'] as double) + amount
          : (currencyData['balance'] as double) - amount;

      final transactionData = {
        'date': Timestamp.fromDate(date), // Utilisation de la date
        'type': type,
        'currency': currency,
        'amount': amount,
        'location': location,
      };

      transaction.update(docRef, {
        'balances.$currency': {
          'totalMovements': totalMovements,
          'balance': balance,
        },
        'transactions': FieldValue.arrayUnion([transactionData]),
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Données enregistrées avec succès.'),
        backgroundColor: const Color.fromARGB(255, 54, 244, 63),
        showCloseIcon: true,
      ),
    );

    setState(() {
      accountData = null; // Forcer une nouvelle recherche après l'ajout
    });
  }

  Future<void> fetchAccountData(String accountNumber) async {
    final firestore = FirebaseFirestore.instance;
    final doc =
        await firestore.collection('Cash-Account').doc(accountNumber).get();

    if (!doc.exists) {
      setState(() {
        accountData = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Compte introuvable.")),
      );
      return;
    }

    setState(() {
      accountData = doc.data();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Relévé des Transactions',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/Images/Lys.jpg',
                  ),
                  SizedBox(width: 10),
                  Text(
                    "LYS INTERNATIONAL",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Divider(thickness: 5),
              SizedBox(
                height: 12,
              ),
              // Formulaire de mouvement
              TextField(
                controller: accountNumberController,
                decoration: InputDecoration(labelText: 'Numéro de compte'),
              ),
              SizedBox(
                height: 12,
              ),
              // Recherche et affichage des données
              ElevatedButton(
                onPressed: () async {
                  await fetchAccountData(accountNumberController.text);
                },
                child: Text('Afficher les Informations du Compte'),
              ),
              if (accountData != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Informations du Compte",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text("Nom : ${accountData!['Name']}"),
                    Text("Numéro : ${accountData!['Account']}"),
                    Divider(
                      thickness: 2,
                    ),
                    Text(
                      "Soldes :",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    ...['dollar', 'dirham', 'cfa'].map((currency) {
                      final balance = accountData!['balances'][currency] ?? {};
                      return Text(
                          "$currency : ${balance['balance']} (Total : ${balance['totalMovements']})");
                    }),
                    Divider(
                      thickness: 2,
                    ),
                    Text(
                      "Transactions :",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    ...accountData!['transactions'].map<Widget>((txn) {
                      return Text(
                        "Le ${txn['date'].toDate()} - ${txn['type']} de ${txn['amount']} ${txn['currency']} à ${txn['location']}",
                      );
                    }).toList(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
