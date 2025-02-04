import 'package:marjeno/Modeles/currency.dart';

class City {
  // Propriétés
  String pays; // Le pays de la ville
  String nom; // Le nom de la ville
  Currency monnaie; // La monnaie associée à la ville
  String image; // L'image représentant la ville

  // Constructeur
  City({
    required this.pays,
    required this.nom,
    required this.monnaie,
    required this.image,
  });

  get fetchGoldPrice => null;
}

City cotonou = City(
  pays: 'Benin',
  nom: 'Cotonou',
  monnaie: cfa,
  image: 'assets/Images/Benin/Cotonou.jpg',
);
City lome = City(
  pays: 'Togo',
  nom: 'Lomé',
  monnaie: cfa,
  image: 'assets/Images/Togo/LOME.jpg',
);
City niamey = City(
  pays: 'Niger',
  nom: 'Niamey',
  monnaie: cfa,
  image: 'assets/Images/Niger/Niamey.jpg',
);
City accra = City(
  pays: 'Ghana',
  nom: 'Accra',
  monnaie: cedis,
  image: 'assets/Images/Ghana/Accra.jpg',
);
City lagos = City(
  pays: 'Nigeria',
  nom: 'Lagos',
  monnaie: naira,
  image: 'assets/Images/Nigeria/Lagos.jpg',
);
City monrovia = City(
  pays: 'Liberia',
  nom: 'Monrovia',
  monnaie: lrd,
  image: 'assets/Images/Liberia/Monrovia.jpg',
);
City ouagadougou = City(
  pays: 'Burkina',
  nom: 'Ouagadougou',
  monnaie: cfa,
  image: 'assets/Images/Burkina/Ouagadougou.jpg',
);

List<City> cities = [
  cotonou,
  lome,
  niamey,
  ouagadougou,
  accra,
  lagos,
  monrovia
];
