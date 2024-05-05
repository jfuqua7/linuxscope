import 'dart:convert';
import 'package:http/http.dart' as http;

// Function to search for Ubuntu packages by name
Future<void> searchUbuntuPackage(String packageName) async {
  // URL to the Launchpad API endpoint
  var url = Uri.parse('https://api.launchpad.net/devel/ubuntu/+archive/primary?ws.op=getPublishedSources&source_name=$packageName');

  try {
    // Send a GET request to the API
    var response = await http.get(url);
    if (response.statusCode == 200) {
      // Parse the JSON data
      var jsonResponse = jsonDecode(response.body);
      var entries = jsonResponse['entries'] as List<dynamic>;

      if (entries.isEmpty) {
        print('No package found with the name $packageName.');
      } else {
        // Print details of the found packages
        for (var entry in entries) {
          print('Package Name: ${entry['source_package_name']}');
          print('Version: ${entry['source_package_version']}');
          print('Published on: ${entry['date_published']}');
          print('----------------------------------------');
        }
      }
    } else {
      print('Failed to load package data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}
