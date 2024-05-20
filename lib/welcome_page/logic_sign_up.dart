import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class logicSignUp {
  final email, password, repeatPassword;
  logicSignUp(this.email, this.password, this.repeatPassword);

  Future<dynamic> sendDataToCVGenerator() async {
    debugPrint("Sending data backend.....");

    final client = http.Client();

    const baseUrl = 'localhost:3000';
    // const url = 'http://localhost:3000/signup';

    final fullData = {
      'email': email,
      'password': password,
      'passwordRepeat': repeatPassword
    };

    try {
      final signupResponse =
          await client.post(Uri.http(baseUrl, 'signup'), body: fullData);
      // Handle response
      debugPrint('Response: ${signupResponse.body}');
      return signupResponse.body;
    } catch (e) {
      // Handle error
      debugPrint('Error: $e');
      return e;
    }
  }
}
