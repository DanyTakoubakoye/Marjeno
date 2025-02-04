import 'package:marjeno/Modeles/city.dart';
import 'package:marjeno/Modeles/currency.dart';

class CurrenciesDailyValuesPerMarket {
  final City city;
  final DateTime date;
  final Map<Currency, double> values;

  CurrenciesDailyValuesPerMarket({
    required this.city,
    required this.date,
    required this.values,
  });
}
