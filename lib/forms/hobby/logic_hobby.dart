//for only debugPrint
import 'package:flutter/material.dart';

//for conversion of json
import 'dart:convert';

//hive
import 'package:hive/hive.dart';

//http
import 'package:http/http.dart' as http;

class SendHobby {
  Future<String> sendHobbyToCVGenerator(Hobby hobby) async {
    debugPrint('Sending hobby to server');
    try {
      final myBox = await Hive.openBox('myBox');
      final _token = await myBox.get('token');

      final fullData = {'hobby': hobby.hobby, 'cookie': _token};

      final client = http.Client();
      final res = await client.post(Uri.http('localhost:3000', 'api/hobby/new'),
          body: fullData);
      debugPrint(res.body);
      return res.body;
    } catch (e) {
      // Handle error
      String error = e.toString();
      debugPrint('Error: $e');

      // ignore: unused_local_variable, prefer_interpolation_to_compose_strings
      String result = '''{
        "operation":"Insert",
        "success":false,
        "reason":" ''' +
          error.trim() +
          ''' ",
        "solution":"Connect to Internet."
      }''';

      return result;
    }
  }

  Future<List<String>> getHobbies() async {
    List<String> hobbies = [];
    try {
      final myBox = await Hive.openBox("myBox");
      final _token = await myBox.get('token');

      debugPrint('Sending get HOBBY request to server');

      final client = http.Client();

      final Map<String, String> query = {'cookie': _token};

      final queryString = Uri(queryParameters: query).query;

      final res = await client
          .get(Uri.parse('http://localhost:3000/api/hobby/one?$queryString'));
      Map<String, dynamic> resultJson = jsonDecode(res.body);

      var operation = resultJson['operation'];
      var solution = resultJson['solution'];
      var reason = resultJson['reason'];
      var success = resultJson['success'];

      debugPrint('operation: $operation');
      debugPrint('solution: $solution');
      debugPrint('reason: $reason');
      debugPrint('success: $success');

      if (success == true) {
        //there is hobby
        String solutionJsonEncode = jsonEncode(solution);
        Map<String, dynamic> solutionJson = jsonDecode(solutionJsonEncode);

        debugPrint('sjsonlist \t: ${solutionJson.toString()}');
        final _id = solutionJson['_id'];
        final user_id = solutionJson['user_id'];
        final thisUserHobbies = solutionJson['hobby'];
        for (var hobby in thisUserHobbies) {
          hobbies.add(hobby);
        }
      }
    } catch (e) {
      // Handle error
      String error = e.toString();
      debugPrint('Error: $error');
    }

    return hobbies;
  }
}

class Hobby {
  final String _hobby, _id;
  Hobby(
    this._id,
    this._hobby,
  );

  String get id => _id;
  String get hobby => _hobby;
}
