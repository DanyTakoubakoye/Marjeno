import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marjeno/Controleurs/Services/Firebase/authentification.dart';
import 'package:marjeno/Vues/premium.dart';
import 'package:marjeno/Vues/visiteur.dart';

class Acceuil extends StatefulWidget {
  const Acceuil({super.key});

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  final _formKey = GlobalKey<FormState>();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _passwordconfirmationcontroller = TextEditingController();
  bool _isloading = false;
  bool _forLogin = true;

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
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                textAlign: TextAlign.center,
                _forLogin ? "Connection" : "Inscription",
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 20),
                  SizedBox(
                    width: 240,
                    child: TextFormField(
                      controller: _emailcontroller,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          fillColor: Colors.white,
                          labelText: 'E-mail',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez Saisir votre E-mail';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    width: 240,
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordcontroller,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          fillColor: Colors.white,
                          labelText: 'Mot de Passe',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez Saisir votre Mot de Passe';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (!_forLogin)
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  SizedBox(
                    width: 240,
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordconfirmationcontroller,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          fillColor: Colors.white,
                          labelText: 'Confimer Mot de Passe',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value != _passwordcontroller.text) {
                          return 'Les deux mots de Passe ne correspondent pas';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 32.5),
                ]),
              SizedBox(height: 32.2),
              Row(
                children: [
                  SizedBox(width: 51.84),
                  TextButton(
                    onPressed: _isloading
                        ? null
                        : () async {
                            //si le formulaire est valide:
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isloading = true;
                              });
                              // Il faut connecter l'utilisateur
                              try {
                                if (_forLogin) {
                                  await Authentification()
                                      .loginWithEmailAndPassword(
                                          _emailcontroller.text,
                                          _passwordcontroller.text);
                                  Navigator.push(
                                      // ignore: use_build_context_synchronously
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Premium(),
                                      ));
                                } else {
                                  await Authentification()
                                      .createUserWithEmailAndPassword(
                                          _emailcontroller.text,
                                          _passwordcontroller.text);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Fellicitation votre Compte est créé!'),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor:
                                        const Color.fromARGB(255, 54, 244, 63),
                                    showCloseIcon: true,
                                  ));
                                  Navigator.push(
                                      // ignore: use_build_context_synchronously
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Premium(),
                                      ));
                                }
                                setState(() {
                                  _isloading = false;
                                });
                              } // En cas d'erreur
                              on FirebaseAuthException catch (e) {
                                setState(() {
                                  _isloading = false;
                                });
                                // afficher l'erreur
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('${e.message}'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red,
                                  showCloseIcon: true,
                                ));
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 45),
                        padding: EdgeInsets.all(8.0),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    child: Text(
                      _forLogin ? 'Connecter' : 'Créer le Compte',
                      style: TextStyle(
                        color: Colors.white, // Couleur du texte
                        fontWeight: FontWeight.bold, // Texte en gras
                      ),
                    ),
                  ),
                  SizedBox(width: 51.84),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _forLogin = !_forLogin;
                      });
                    },
                    style: TextButton.styleFrom(
                        minimumSize: Size(150, 45),
                        padding: EdgeInsets.all(8.0),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    child: Text(
                      _forLogin ? 'Créer un Compte' : 'Me connecter',
                      style: TextStyle(
                        color: Colors.white, // Couleur du texte
                        fontWeight: FontWeight.bold, // Texte en gras
                      ),
                    ),
                  ),
                  SizedBox(width: 51.84)
                ],
              ),
              SizedBox(height: 51.84),
              Row(children: [
                SizedBox(width: 160),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Visiteur(),
                          ));
                    },
                    style: TextButton.styleFrom(
                        minimumSize: Size(150, 45),
                        padding: EdgeInsets.all(8.0),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    child: Text(
                      'Visiteur',
                      style: TextStyle(
                        color: Colors.white, // Couleur du texte
                        fontWeight: FontWeight.bold, // Texte en gras
                      ),
                    )),
                SizedBox(width: 20)
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
