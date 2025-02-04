class Membre {
  // Propriétés
  final int id; // Identifiant unique
  final String nom;
  final String prenom;
  final String pays;
  final double numero;
  final String motDePasse;

  // Constructeur
  Membre({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.pays,
    required this.numero,
    required this.motDePasse,
  });

  // Générateur d'index
  static int _currentId = 2;
  static List<Membre> membres = [daouda, ibrahim, boulyamine];

  // Méthode pour créer un nouveau membre
  static Membre createMembre({
    required String nom,
    required String prenom,
    required String pays,
    required double numero,
    required String motDePasse,
  }) {
    _currentId++;
    Membre newMembre = Membre(
        id: _currentId,
        nom: nom,
        prenom: prenom,
        pays: pays,
        numero: numero,
        motDePasse: motDePasse); // Augmenter l'index pour chaque nouveau membre
    membres.add(newMembre);
    return newMembre;
  }

  Membre membre4 = Membre.createMembre(
      nom: 'Amar',
      prenom: 'Joseph',
      numero: 71036295,
      pays: 'Burkina Faso',
      motDePasse: 'JAm1234');
  print() {
    [membres];
  }
}

Membre daouda = Membre(
    id: 0,
    nom: 'Djibo',
    prenom: 'Daouda',
    pays: 'Benin',
    numero: 58585848,
    motDePasse: '82568\$Takou');
Membre ibrahim = Membre(
    id: 1,
    nom: 'Ibrahim',
    prenom: 'Saad',
    pays: 'Benin',
    numero: 97971907,
    motDePasse: 'IB07');
Membre boulyamine = Membre(
    id: 2,
    nom: 'Moumouni',
    prenom: 'Boulyamine',
    pays: 'Togo',
    numero: 93746789,
    motDePasse: 'Boulo89');
