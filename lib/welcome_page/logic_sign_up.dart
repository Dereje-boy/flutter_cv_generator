import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class logicSignUp {
  final email, password, repeatPassword;
  logicSignUp(this.email, this.password, this.repeatPassword);

  Future<dynamic> sendDataToCVGenerator() async {
    debugPrint("Sending data backend.....");
    final Dio _dio = Dio();

    const url = 'http://localhost:3000/signup';
    final fullData = {
      'email': email,
      'password': password,
      'passwordRepeat': repeatPassword
    };

    try {
      var response = await _dio.post(url, data: fullData);
      // Handle response
      debugPrint('Response: $response');
      return response;
    } catch (e) {
      // Handle error
      debugPrint('Error: $e');
      return e;
    }
  }
}
