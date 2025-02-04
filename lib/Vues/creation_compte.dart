import 'package:flutter/material.dart';
import 'package:marjeno/Vues/acceuil.dart';

class CreationCompte extends StatelessWidget {
  const CreationCompte({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 65, 6, 240),
        leading: Padding(
          padding: const EdgeInsets.only(left: 70.0),
          child: Icon(
            Icons.home,
            color: Colors.white,
          ),
        ),
        title: Text(
          'MARJENO',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.amber[200]),
        ),
        centerTitle: true,
        actions: [
          Container(
              padding: EdgeInsets.only(right: 70),
              child: Icon(Icons.account_circle)),
        ],
      ),
      body: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              textAlign: TextAlign.center,
              "Création de compte",
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 20),
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      labelText: 'Code Pays',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String? value) {},
                    hint: Text('Choisissez un code'),
                    items: [
                      DropdownMenuItem(
                        value: '+229',
                        child: Text('Benin (+229)'),
                      ),
                      DropdownMenuItem(
                        value: '+228',
                        child: Text('Togo (+228)'),
                      ),
                      DropdownMenuItem(
                        value: '+227',
                        child: Text('Niger (+227)'),
                      ),
                      DropdownMenuItem(
                        value: '+233',
                        child: Text('Ghana (+233)'),
                      ),
                      DropdownMenuItem(
                        value: '+234',
                        child: Text('Nigeria (+234)'),
                      ),
                      DropdownMenuItem(
                        value: '+231',
                        child: Text('Liberia (+231)'),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 45),
                SizedBox(
                  width: 200,
                  child: TextField(
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: 'Votre Numéro de Téléphone',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder())),
                ),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 20),
                SizedBox(
                  width: 200,
                  child: TextField(
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: 'Votre Prénom',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder())),
                ),
                SizedBox(width: 45),
                SizedBox(
                  width: 200,
                  child: TextField(
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: 'Votre Nom ',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder())),
                ),
                SizedBox(width: 20)
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 20),
                SizedBox(
                  width: 200,
                  child: TextField(
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: 'Mot de Passe',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder())),
                ),
                SizedBox(width: 45),
                SizedBox(
                  width: 200,
                  child: TextField(
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: 'Repetez le mot de Passe',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder())),
                ),
                SizedBox(width: 20)
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () {}, child: Text('Créer mon compte')),
                    SizedBox(width: 45),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Acceuil(),
                              ));
                        },
                        child: Text('J\'ai déjà un Compte')),
                  ],
                ),
                SizedBox(height: 13),
              ],
            )
          ],
        ),
      ),
    );
  }
}
