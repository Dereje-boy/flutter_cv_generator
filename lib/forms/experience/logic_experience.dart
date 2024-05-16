//for only debugPrint
import 'package:flutter/material.dart';

//for conversion of json
import 'dart:convert';

//hive
import 'package:hive/hive.dart';

//http
import 'package:http/http.dart' as http;

class SendExperience {
  void sendExperienceToCVGenerator(Experience experience) {}
  Future<List<Experience>> getExperience() async {
    List<Experience> experiences = [];
    try {
      final myBox = await Hive.openBox("myBox");
      final _token = await myBox.get('token');

      debugPrint("Sending get EXPERIENCE request to server");

      final client = http.Client();

      final Map<String, String> query = {'cookie': _token};

      final queryString = Uri(queryParameters: query).query;

      final res = await client.get(
          Uri.parse('http://localhost:3000/api/experience/one?$queryString'));

      // debugPrint("res.body ${res.body}");

      Map<String, dynamic> resultJson = jsonDecode(res.body);

      var operation = resultJson['operation'];
      var solution = resultJson['solution'];
      var reason = resultJson['reason'];
      var success = resultJson['success'];

      if (success == true) {
        //there is some exp
        String solutionJsonEncode = jsonEncode(solution);
        List<dynamic> solutionJsonList = jsonDecode(solutionJsonEncode);

        List<Map<String, dynamic>> myExperiences =
            solutionJsonList.cast<Map<String, dynamic>>();

        //facilitating for return, storing on list of 'Experience'
        for (var i = 0; i < myExperiences.length; i++) {
          // debugPrint('${i + 1} Experience');

          //this Experience, values
          final _id = myExperiences[i]['_id'];
          final position = myExperiences[i]['position'];
          final companyName = myExperiences[i]['companyName'];
          final aboutExperience = myExperiences[i]['aboutExperience'];
          final startDate = myExperiences[i]['startDate'];
          final endDate = myExperiences[i]['endDate'];

          //storing on constructor
          Experience thisExp = Experience(_id, position, companyName,
              aboutExperience, startDate, '', endDate);

          experiences.add(thisExp);
        }

        return experiences;
      } else {
        return experiences;
      }
    } catch (e) {
      debugPrint("Exp Error: ${e.toString()}");
      return experiences;
    }
  }

  void deleteExperience(String expID) {}
}

class Experience {
  final _id,
      _position,
      _companyName,
      _aboutExperience,
      _startDate,
      _stilleHere,
      _endDate;
  Experience(this._id, this._position, this._companyName, this._aboutExperience,
      this._startDate, this._stilleHere, this._endDate);

  String get id => _id;
  String get position => _position;
  String get companyName => _companyName;
  String get aboutExperience => _aboutExperience;
  String get startDate => _startDate;
  String get stilleHere => _stilleHere;
  String? get endDate => _endDate;

  @override
  String toString() {
    return '''
  'id' : '${_id}'
  'position' : '${_position}'
  'companyName' : '${_companyName}'
  'aboutExperience' : '${_aboutExperience}'
  'startDate' : '${_startDate}'
  'stilleHere' : '${_stilleHere}'
  'endDate' : '${_endDate}'
''';
  }
}
