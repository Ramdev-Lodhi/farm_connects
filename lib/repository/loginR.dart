import 'dart:convert';
import 'package:farm_connects/config/api_url.dart';
import 'package:http/http.dart' as http;

class LoginR {
  Future<Map<String, dynamic>> signup(String name, int phone, String address,
      int pincode, String password) async {
    // Endpoint URL
    final url = Uri.parse('$apiUrl/insertdata');
    print(url);
    // Request payload
    // final Map<String, dynamic> payload = {
    //   'name': name,
    //   'phone': phone,
    //   'address': address,
    //   'pincode': pincode,
    //   'password': password,
    // };
    // final url = Uri.parse('http://localhost:8080/api/insertdata');
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
      // final response = await http.post(
      //   url,
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({
      //     'name': 'John Doe',
      //     'phone': 1234567890,
      //     'address': '123 Main St',
      //     'pincode': 12345,
      //     'password': 'password'
      //   }),
      // );
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
  Future<Map<String, dynamic>> signin(int phone,String password) async {
    final url = Uri.parse('$apiUrl/getuserphone');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'phone': phone,
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
