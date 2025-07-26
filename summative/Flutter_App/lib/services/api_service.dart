import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://linear-regression-model-1-y26q.onrender.com";

  Future<String> predict(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/predict"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      // ignore: avoid_print
      var term = response.body;
      print("Status code: ${response.statusCode}");
      print("API response: ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final predictedYield = result['Predicted_yield'];
        print("Result: $predictedYield");
        return "$predictedYield";
      } else {
        return "Error: ${response.body}";
      }
    } catch (e) {
      print("Exception: $e");
      return "Exception: $e";
    }
  }
}
