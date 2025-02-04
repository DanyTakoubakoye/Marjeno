import 'package:flutter/material.dart';

class CalculationView extends StatefulWidget {
  const CalculationView({super.key});

  @override
  _CalculationViewState createState() => _CalculationViewState();
}

class _CalculationViewState extends State<CalculationView> {
  final TextEditingController _m0Controller = TextEditingController();
  final TextEditingController _mController = TextEditingController();
  final TextEditingController _vController = TextEditingController();
  final TextEditingController _densityController = TextEditingController();
  final TextEditingController _caratController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _m0Controller.addListener(_updateCalculations);
    _mController.addListener(_updateCalculations);
    _vController.addListener(_updateCalculations);
  }

  @override
  void dispose() {
    _m0Controller.dispose();
    _mController.dispose();
    _vController.dispose();
    _densityController.dispose();
    _caratController.dispose();
    super.dispose();
  }

  void _updateCalculations() {
    final double? m0 = double.tryParse(_m0Controller.text);
    final double? m = double.tryParse(_mController.text);
    final double? v = double.tryParse(_vController.text);

    if (m0 != null) {
      // Calcul automatique pour M ou V
      if (m != null) {
        _vController.removeListener(_updateCalculations);
        _vController.text = (m0 - m).toStringAsFixed(2);
        _vController.addListener(_updateCalculations);
      } else if (v != null) {
        _mController.removeListener(_updateCalculations);
        _mController.text = (m0 - v).toStringAsFixed(2);
        _mController.addListener(_updateCalculations);
      }

      // Calcul de la densité
      if (v != null && v > 0) {
        final double density = m0 / v;
        final double realDensity = density / 0.997;
        final double roundedRealDensity =
            (realDensity * 100).floorToDouble() / 100;

        _densityController.text = roundedRealDensity.toStringAsFixed(2);

        // Calcul du carat
        final double carat =
            52.57 * ((roundedRealDensity - 10.5) / roundedRealDensity);
        _caratController.text = carat.toStringAsFixed(2);
      } else {
        _densityController.clear();
        _caratController.clear();
      }
    } else {
      _vController.clear();
      _densityController.clear();
      _caratController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calcul des Propriétés")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              controller: _m0Controller,
              label: "Masse à vide (M0)",
            ),
            SizedBox(height: 16.0),
            _buildTextField(
              controller: _mController,
              label: "Masse humide (M)",
            ),
            SizedBox(height: 16.0),
            _buildTextField(
              controller: _vController,
              label: "Volume (V)",
            ),
            SizedBox(height: 16.0),
            _buildTextField(
              controller: _densityController,
              label: "Densité (d)",
              isReadOnly: true,
            ),
            SizedBox(height: 16.0),
            _buildTextField(
              controller: _caratController,
              label: "Carat",
              isReadOnly: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isReadOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: isReadOnly,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
