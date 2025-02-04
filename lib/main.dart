import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:marjeno/Vues/calculatrice/carat.dart';
import 'package:marjeno/Vues/calculatrice/change.dart';
import 'package:marjeno/Vues/calculatrice/facture.dart';
import 'package:marjeno/Vues/creation_compte.dart';
import 'package:marjeno/Vues/currenciesdailyvaluentriespermarket.dart';
import 'package:marjeno/Vues/premium.dart';
import 'package:marjeno/Vues/recherche_facture.dart';
import 'package:marjeno/Vues/regional_market.dart';
import 'package:marjeno/Vues/visiteur.dart';
import 'package:marjeno/firebase_options.dart';

import 'Controleurs/Services/Firebase/redirectionPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      routes: {
        '/searchinvoicescreen': (context) => SearchInvoiceScreen(),
        '/regionalmarket': (context) {
          return Regionalmarket();
        },
        '/premium': (context) {
          return Premium();
        },
        '/creationcompte': (context) {
          return CreationCompte();
        },
        '/carat': (context) {
          return DeterminationCarat();
        },
        '/facture': (context) {
          return Facture();
        },
        '/changedevise': (context) {
          return ChangeDevise();
        },
        '/visiteur': (context) {
          return Visiteur();
        },
        '/pagedentreevaleurs': (context) {
          return CurrenciesDalyValueEntryPerMarket();
        },
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // Anglais
        const Locale('fr', ''), // Français
      ],
      home: Redirectionpage(),
      debugShowCheckedModeBanner:
          false, // Optionnel pour désactiver le bandeau de debug
    );
  }
}
