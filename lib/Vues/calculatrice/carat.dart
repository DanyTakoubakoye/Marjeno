import 'package:flutter/material.dart';

class DeterminationCarat extends StatefulWidget {
  const DeterminationCarat({super.key});

  @override
  State<DeterminationCarat> createState() => _DeterminationCaratState();
}

class _DeterminationCaratState extends State<DeterminationCarat> {
  final TextEditingController _m01Controller = TextEditingController();
  final TextEditingController _v1Controller = TextEditingController();
  final TextEditingController _d1Controller = TextEditingController();
  final TextEditingController _m02Controller = TextEditingController();
  final TextEditingController _m2Controller = TextEditingController();
  final TextEditingController _v2Controller = TextEditingController();
  final TextEditingController _d2Controller = TextEditingController();
  final TextEditingController _caratController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _m01Controller.addListener(_calculcarat);
    _v1Controller.addListener(_calculcarat);
    _m02Controller.addListener(_calculdensite);
    _m2Controller.addListener(_calculdensite);
  }

  @override
  void dispose() {
    _m01Controller.dispose();
    _v1Controller.dispose();
    _d1Controller.dispose();
    _m02Controller.dispose();
    _m2Controller.dispose();
    _v2Controller.dispose();
    _d2Controller.dispose();
    super.dispose();
  }

  // ignore: unused_element
  double _roundingNumber(x) => (100 * x).floorToDouble() / 100;

  void _calculcarat() {
    final double? m01 = double.tryParse(_m01Controller.text);
    final double? v1 = double.tryParse(_v1Controller.text);

    if (m01 != null && v1 != null) {
      if (v1 > 0) {
        _d1Controller.text = (m01 / v1).toString();
        final double density = _roundingNumber(m01 / v1);
        final double realDensity = _roundingNumber(density / 0.997);
        final double roundedRealDensity = realDensity - 10.5;
        _caratController.text =
            (52.57 * roundedRealDensity / realDensity).toString();
      }
    }
  }

  void _calculdensite() {
    final double? m02 = double.tryParse(_m02Controller.text);
    final double? m2 = double.tryParse(_m2Controller.text);
    if (m02 != null && m2 != null) {
      _v2Controller.text = (m02 - m2).toStringAsFixed(2);
      _d2Controller.text = (m02 / (m02 - m2)).toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 84, 75, 2),
          title: const Text(
            'Marjeno',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            letterSpacing: 5,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Padding(
            padding:
                const EdgeInsets.all(8.0), // Ajout de marges pour le contenu
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      color: const Color.fromARGB(255, 241, 218, 7),
                      child: Center(
                        child: const SizedBox(
                            height: 35,
                            child: Text(
                              'Détermination de Carat',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: Colors.white),
                            )),
                      )),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 20),
                      Container(
                          color: Colors.grey,
                          child: Column(children: [
                            const Text("Masse à vide"),
                            Text('(M0)')
                          ])),
                      const SizedBox(width: 15),
                      SizedBox(
                        width: 100, // Limite la largeur du TextField
                        child: TextField(
                          controller: _m01Controller,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 45),
                      Column(children: [const Text('Volume'), Text('(M0-M)')]),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _v1Controller,
                          readOnly: false,
                          style: TextStyle(
                              backgroundColor: Colors.blueGrey,
                              color: Colors.white,
                              fontSize: 16),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(width: 45),
                      const Text('Densité'),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _d1Controller,
                          readOnly: true,
                          style: TextStyle(
                              backgroundColor: Colors.blueGrey,
                              color: Colors.white,
                              fontSize: 16),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 120),
                      Container(
                          color: Colors.yellow, child: const Text('Carat')),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 240,
                        child: TextField(
                          controller: _caratController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                  SizedBox(height: 15),
                  Divider(
                    indent: 6.0,
                    thickness: 6,
                    color: Colors.blue,
                    endIndent: 6.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                        8.0), // Ajout de marges pour le contenu
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                              color: const Color.fromARGB(255, 19, 35, 64),
                              child: Center(
                                child: const SizedBox(
                                    height: 35,
                                    child: Text(
                                      'Détermination de densité par pesée',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                          color: Colors.white),
                                    )),
                              )),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 20),
                              Container(
                                  color: Colors.grey,
                                  child: Column(children: [
                                    const Text("Masse à vide"),
                                    Text('(M0)')
                                  ])),
                              const SizedBox(width: 15),
                              SizedBox(
                                width: 100, // Limite la largeur du TextField
                                child: TextField(
                                  controller: _m02Controller,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 45),
                              Column(children: [
                                const Text('Volume'),
                                Text('(M0-M)')
                              ]),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: _v2Controller,
                                  readOnly: true,
                                  style: TextStyle(
                                      backgroundColor: Colors.blueGrey,
                                      color: Colors.white,
                                      fontSize: 16),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(width: 20),
                              Container(
                                color: Colors.blue,
                                child: Column(children: [
                                  const Text("Masse humide"),
                                  Text('(M)')
                                ]),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: _m2Controller,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 45),
                              const Text('Densité'),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: _d2Controller,
                                  readOnly: true,
                                  style: TextStyle(
                                      backgroundColor: Colors.blueGrey,
                                      color: Colors.white,
                                      fontSize: 16),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
                        ]),
                  )
                ])));
  }
}
