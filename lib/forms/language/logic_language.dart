//for only debugPrint
import 'package:flutter/material.dart';

//for conversion of json
import 'dart:convert';

//hive
import 'package:hive/hive.dart';

//http
import 'package:http/http.dart' as http;

class SendLanguage {
  Future<String> sendLanguageToCVGenerator(Language language) async {
    debugPrint("Sending Language to server ");

    try {
      final myBox = await Hive.openBox("myBox");
      final _token = await myBox.get('token');

      final fullData = {
        'language': language.language,
        'level': language.level.toString(),
        'cookie': _token
      };

      debugPrint(fullData.toString());

      final client = http.Client();
      final res = await client
          .post(Uri.http('localhost:3000', 'api/language/new'), body: fullData);
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

  Future<List<Language>> getLanguages() async {
    List<Language> thisUserLanguages = [];

    try {
      final myBox = await Hive.openBox("myBox");
      final _token = await myBox.get('token');

      debugPrint("Sending get LANGUAGE request to server");

      final client = http.Client();

      final Map<String, String> query = {'cookie': _token};

      final queryString = Uri(queryParameters: query).query;

      final res = await client.get(
          Uri.parse('http://localhost:3000/api/language/one?$queryString'));

      debugPrint(res.body);

      // debugPrint(' === Started encoding and decoding === ');

      Map<String, dynamic> resultJson = jsonDecode(res.body);

      // debugPrint(' === Result Json === ');

      var operation = resultJson['operation'];
      var solution = resultJson['solution'];
      var reason = resultJson['reason'];
      var success = resultJson['success'];

      // debugPrint('operation: $operation');
      // debugPrint('solution: $solution');
      // debugPrint('reason: $reason');
      // debugPrint('success: $success');

      if (success == true) {
        //there is some edu
        String solutionJsonEncode = jsonEncode(solution);
        List<dynamic> solutionJsonList = jsonDecode(solutionJsonEncode);

        List<Map<String, dynamic>> myLanguages =
            solutionJsonList.cast<Map<String, dynamic>>();
        // debugPrint('solutionJson: $solutionJsonList');

        for (var i = 0; i < solutionJsonList.length; i++) {
          Map<String, dynamic> thisLang = solutionJsonList[i];

          //this language, values
          final _id = thisLang['_id'];
          final language = thisLang['language'];
          final level = thisLang['level'][0];
          final user_id = thisLang['user_id'];

          // //storing on constructor
          Language constructor = Language(_id, language, level, user_id);

          thisUserLanguages.add(constructor);
        }

        return thisUserLanguages;
      } else {
        return thisUserLanguages;
      }
    } catch (e) {
      // Handle error
      String error = e.toString();
      debugPrint('Error: $error');
      return thisUserLanguages;
    }

    return thisUserLanguages;
  }

  Future<String> deleteLanguage(String langID) async {
    try {
      final myBox = await Hive.openBox("myBox");
      final _token = await myBox.get('token');

      debugPrint("Sending Delete LANGUAGE request to server");

      final client = http.Client();

      final Map<String, String> query = {
        '_id': langID.trim(),
        'cookie': _token
      };
      final queryString = Uri(queryParameters: query).query;

      final res = await client.delete(
          Uri.parse('http://localhost:3000/api/language/delete?$queryString'));

      debugPrint(res.body);
      return res.body;
    } catch (e) {
      // Handle error
      String error = e.toString();
      debugPrint('Delete Error: $error');

      // ignore: prefer_interpolation_to_compose_strings
      String result = '''{
        "operation":"delete",
        "success":false,
        "reason":" ''' +
          error.trim() +
          ''' ",
        "solution":"Connect to Internet."
      }''';
      return result;
    }
  }
}

class Language {
  String _id;
  String _language;
  String _level;
  String _user_id;

  Language(this._id, this._language, this._level, this._user_id);
  String get id => _id;
  String get language => _language;
  String get level => _level;
  String get user_id => _user_id;

  @override
  String toString() {
    final myString = ''' 
    _id : ${_id},
    language : ${_language},
    level : ${_level},
    user_id : ${user_id},
    ''';
    return myString;
  }
}
