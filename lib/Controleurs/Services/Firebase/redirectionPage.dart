import 'package:flutter/material.dart';
import 'package:marjeno/Controleurs/Services/Firebase/authentification.dart';
import 'package:marjeno/Vues/acceuil.dart';
import 'package:marjeno/Vues/premium.dart';

class Redirectionpage extends StatefulWidget {
  const Redirectionpage({super.key});

  @override
  State<Redirectionpage> createState() => _RedirectionpageState();
}

class _RedirectionpageState extends State<Redirectionpage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Authentification().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return Premium();
          } else {
            return Acceuil();
          }
        });
  }
}
