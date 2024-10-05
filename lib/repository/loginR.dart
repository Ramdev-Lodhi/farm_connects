import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:farm_connects/config/api_url.dart';

class LoginR {
  Future<Map<String, dynamic>> signup(String name, int phone, String address,
      int pincode, String password) async {
    // Endpoint URL
    final url = Uri.parse('$apiUrl/insertdata');
    print(url);
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'name': name,
      'phone': phone,
      'address': address,
      'pincode': pincode,
      'password': password
    });
    try {
      print(body);
      // Send POST request
      final response = await http.post(url, headers: headers, body: body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print(response);
      // Check the status code and parse the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'status': '200',
          'data': json.decode(response.body),
        };
      } else {
        return {
          'status': '500',
          'message': 'Failed to sign up: ${response.statusCode}',
        };
      }
    } catch (e) {
      // Handle any errors that occur during the request
      return {
        'status': '500',
        'message': 'An error occurred: $e',
      };
    }
  }
  Future<Map<String, dynamic>> signin(String email,String password) async {
    final url = Uri.parse('$apiUrl/login');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'email': email,
      'password': password
    });
    try {
      // Send POST request
      final response = await http.post(url, headers: headers, body: body);
      // Check the status code and parse the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'status':'200',
          'success': true,
          'data': json.decode(response.body),
        };
      } else {
        return {
          'status':'500',
          'success': false,
          'message': 'Failed to sign up: ${response.statusCode}',
        };
      }
    } catch (e) {
      // Handle any errors that occur during the request
      return {
        'status':'500',
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }
}
