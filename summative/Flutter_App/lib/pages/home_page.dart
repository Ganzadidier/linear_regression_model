import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  // Step management
  int currentStep = -1; // -1 = welcome, 0+ = input steps, n = result
  String result = "";
  bool isLoading = false;

  // Input fields and their order
  final List<_InputField> inputFields = [
    _InputField(
      key: 'Elevation',
      label: 'Elevation',
      icon: Icons.terrain,
      type: _InputType.number,
    ),
    _InputField(
      key: 'Latitude',
      label: 'Latitude',
      icon: Icons.explore,
      type: _InputType.number,
    ),
    _InputField(
      key: 'Longitude',
      label: 'Longitude',
      icon: Icons.explore_outlined,
      type: _InputType.number,
    ),
    _InputField(
      key: 'Slope',
      label: 'Slope',
      icon: Icons.show_chart,
      type: _InputType.number,
    ),
    _InputField(
      key: 'Rainfall',
      label: 'Rainfall',
      icon: Icons.grain,
      type: _InputType.number,
    ),
    _InputField(
      key: 'Min_temperature_C',
      label: 'Min Temperature (°C)',
      icon: Icons.ac_unit,
      type: _InputType.number,
    ),
    _InputField(
      key: 'Max_temperature_C',
      label: 'Max Temperature (°C)',
      icon: Icons.wb_sunny,
      type: _InputType.number,
    ),
    _InputField(
      key: 'Ave_temps',
      label: 'Average Temperature',
      icon: Icons.thermostat,
      type: _InputType.number,
    ),
    _InputField(
      key: 'Soil_fertility',
      label: 'Soil Fertility',
      icon: Icons.eco,
      type: _InputType.number,
    ),
    _InputField(
      key: 'pH',
      label: 'Soil pH',
      icon: Icons.science,
      type: _InputType.number,
    ),
    _InputField(
      key: 'Pollution_level',
      label: 'Pollution Level',
      icon: Icons.cloud,
      type: _InputType.number,
    ),
    _InputField(
      key: 'Plot_size',
      label: 'Plot Size',
      icon: Icons.square_foot,
      type: _InputType.number,
    ),
    _InputField(
      key: 'Annual_yield',
      label: 'Annual Yield',
      icon: Icons.agriculture,
      type: _InputType.number,
    ),
    _InputField(
      key: 'Location',
      label: 'Location',
      icon: Icons.location_on,
      type: _InputType.dropdown,
      options: [
        'Rural_Amanzi',
        'Rural_Hawassa',
        'Rural_Kilimani',
        'Rural_Sokoto',
      ],
    ),
    _InputField(
      key: 'Soil_type',
      label: 'Soil Type',
      icon: Icons.landscape,
      type: _InputType.dropdown,
      options: ['Peaty', 'Rocky', 'Sandy', 'Silt', 'Volcanic'],
    ),
    _InputField(
      key: 'Crop_type',
      label: 'Crop Type',
      icon: Icons.grass,
      type: _InputType.dropdown,
      options: [
        'cassava',
        'cassava_',
        'coffee',
        'maize',
        'potato',
        'rice',
        'tea',
        'tea_',
        'wheat',
        'wheat_',
      ],
    ),
  ];

  // Store user input
  final Map<String, dynamic> formData = {};
  final TextEditingController _stepController = TextEditingController();
  String? _dropdownValue;

  // Colors
  final Color green = const Color(0xFF43A047);
  final Color orange = const Color(0xFFFF9800);

  void _startPrediction() {
    setState(() {
      currentStep = 0;
      result = "";
      formData.clear();
      _stepController.clear();
      _dropdownValue = null;
    });
  }

  void _nextStep() {
    final field = inputFields[currentStep];
    if (field.type == _InputType.number) {
      if (_stepController.text.isEmpty ||
          num.tryParse(_stepController.text) == null) {
        _showSnackBar('Please enter a valid number for ${field.label}');
        return;
      }
      formData[field.key] = double.tryParse(_stepController.text) ?? 0;
    } else if (field.type == _InputType.dropdown) {
      if (_dropdownValue == null) {
        _showSnackBar('Please select ${field.label}');
        return;
      }
      formData[field.key] = _dropdownValue;
    }
    _stepController.clear();
    _dropdownValue = null;
    setState(() {
      currentStep++;
    });
    if (currentStep == inputFields.length) {
      _submitPrediction();
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: orange));
  }

  Future<void> _submitPrediction() async {
    setState(() => isLoading = true);
    // Prepare categorical fields as one-hot
    Map<String, int> locationMap = {
      'Location_Rural_Amanzi': 0,
      'Location_Rural_Hawassa': 0,
      'Location_Rural_Kilimani': 0,
      'Location_Rural_Sokoto': 0,
    };
    if (formData['Location'] != null) {
      locationMap['Location_${formData['Location']}'] = 1;
    }
    Map<String, int> soilTypeMap = {
      'Soil_type_Peaty': 0,
      'Soil_type_Rocky': 0,
      'Soil_type_Sandy': 0,
      'Soil_type_Silt': 0,
      'Soil_type_Volcanic': 0,
    };
    if (formData['Soil_type'] != null) {
      soilTypeMap['Soil_type_${formData['Soil_type']}'] = 1;
    }
    Map<String, int> cropTypeMap = {
      'Crop_type_cassava': 0,
      'Crop_type_cassava_': 0,
      'Crop_type_coffee': 0,
      'Crop_type_maize': 0,
      'Crop_type_potato': 0,
      'Crop_type_rice': 0,
      'Crop_type_tea': 0,
      'Crop_type_tea_': 0,
      'Crop_type_wheat': 0,
      'Crop_type_wheat_': 0,
    };
    if (formData['Crop_type'] != null) {
      cropTypeMap['Crop_type_${formData['Crop_type']}'] = 1;
    }
    final data = {
      "Elevation": formData['Elevation'] ?? 0,
      "Latitude": formData['Latitude'] ?? 0,
      "Longitude": formData['Longitude'] ?? 0,
      "Slope": formData['Slope'] ?? 0,
      "Rainfall": formData['Rainfall'] ?? 0,
      "Min_temperature_C": formData['Min_temperature_C'] ?? 0,
      "Max_temperature_C": formData['Max_temperature_C'] ?? 0,
      "Ave_temps": formData['Ave_temps'] ?? 0,
      "Soil_fertility": formData['Soil_fertility'] ?? 0,
      "pH": formData['pH'] ?? 0,
      "Pollution_level": formData['Pollution_level'] ?? 0,
      "Plot_size": formData['Plot_size'] ?? 0,
      "Annual_yield": formData['Annual_yield'] ?? 0,
      ...locationMap,
      ...soilTypeMap,
      ...cropTypeMap,
    };
    final prediction = await apiService.predict(data);
    print("Current step after prediction: $currentStep");
    print(prediction);
    print("Result after prediction: $prediction");
    setState(() {
      result = prediction;
      isLoading = false;
      currentStep++;
    });
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, size: 80, color: green),
            const SizedBox(height: 24),
            Text(
              'Welcome to Crop Yield Predictor',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Enter your field and crop details step by step to get a yield prediction.',
              style: TextStyle(fontSize: 18, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _startPrediction,
              child: const Text('Start Prediction'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepInput() {
    final field = inputFields[currentStep];
    return Center(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(field.icon, size: 48, color: green),
              const SizedBox(height: 16),
              Text(
                'Enter ${field.label}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: green,
                ),
              ),
              const SizedBox(height: 16),
              if (field.type == _InputType.number)
                TextField(
                  controller: _stepController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: field.label,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: orange, width: 2),
                    ),
                  ),
                  onSubmitted: (_) => _nextStep(),
                  autofocus: true,
                )
              else if (field.type == _InputType.dropdown)
                DropdownButtonFormField<String>(
                  value: _dropdownValue,
                  items: field.options!
                      .map(
                        (opt) => DropdownMenuItem(
                          value: opt,
                          child: Text(opt.replaceAll('_', ' ')),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _dropdownValue = val),
                  decoration: InputDecoration(
                    labelText: field.label,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: orange, width: 2),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentStep > 0)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: orange,
                        side: BorderSide(color: orange),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          currentStep--;
                          _stepController.clear();
                          _dropdownValue = null;
                        });
                      },
                      child: const Text('Back'),
                    ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: isLoading ? null : _nextStep,
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    return Center(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 64, color: green),
              const SizedBox(height: 16),
              Text(
                'Prediction Result',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: green,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                result,
                style: TextStyle(fontSize: 20, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => setState(() => currentStep = -1),
                child: const Text('Start Over'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text("Crop Yield Predictor"),
        backgroundColor: green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: currentStep == -1
            ? _buildWelcomeScreen()
            : (currentStep < inputFields.length
                  ? _buildStepInput()
                  : _buildResultScreen()),
      ),
    );
  }
}

// Helper classes for step-by-step input

enum _InputType { number, dropdown }

class _InputField {
  final String key;
  final String label;
  final IconData icon;
  final _InputType type;
  final List<String>? options;
  const _InputField({
    required this.key,
    required this.label,
    required this.icon,
    required this.type,
    this.options,
  });
}
