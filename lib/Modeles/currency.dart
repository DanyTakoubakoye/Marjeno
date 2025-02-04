// ignore: file_names
class Currency {
  // Propriétés
  String name; // Nom de la devise
  String image; // Image associée à la devise
  double value; // Valeur associée à la devise
  double unite; // unité de conversion de la devise
  String symbole; // Symbole de la devise
  // Constructeur
  Currency(
      {required this.unite,
      required this.symbole,
      required this.name,
      required this.image,
      required this.value});

  // Méthode pour définir la valeur
  void setValue(double valeur) {
    value = valeur; // Attribue la nouvelle valeur
  }
}

// Créer une instance du carat de l'or comme une monnaie
Currency or = Currency(
    name: 'OR',
    image: 'assets/Or.jpg',
    value: 2205,
    unite: 1,
    symbole: 'Carat');
// Créer une instance de la monnaie CFA
Currency cfa = Currency(
  unite: 1000,
  symbole: 'FCFA',
  name: 'CFA',
  image: 'assets/CFA.jpg', // Chemin de l'image de la monnaie
  value: 1.0, // Valeur initiale de la monnaie
);
Currency dollar = Currency(
  unite: 1,
  symbole: '\$',
  name: 'Dollar',
  image: 'assets/Dollar.jpg', // Chemin de l'image de la monnaie
  value: 633.0, // Valeur initiale de la monnaie
);
Currency euro = Currency(
    unite: 1,
    symbole: 'Є',
    name: 'Euro',
    image: 'assets/Euro.jpg', // Chemin de l'image de la monnaie
    value: 655.957); // Valeur initiale de la monnaie
Currency cedis = Currency(
    unite: 1,
    symbole: 'GHC',
    name: 'Cedis',
    image: 'assets/Cedis.jpg', // Chemin de l'image de la monnaie
    value: 4.08); // Valeur initiale de la monnaie
Currency naira = Currency(
    unite: 1000,
    symbole: '₦',
    name: 'Naira',
    image: 'assets/Naira.jpg', // Chemin de l'image de la monnaie
    value: 0.37); // Valeur initiale de la monnaie
Currency lrd = Currency(
    unite: 1,
    symbole: 'lrd',
    name: 'LRD',
    image: 'assets/LRD.jpg', // Chemin de l'image de la monnaie
    value: 3.48); // Valeur initiale de la monnaie

List<Currency> currencies = [or, dollar, cfa, euro, naira, cedis, lrd];
