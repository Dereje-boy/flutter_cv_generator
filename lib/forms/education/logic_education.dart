//for only debugPrint
import 'package:flutter/material.dart';

//for conversion of json
import 'dart:convert';

//hive
import 'package:hive/hive.dart';

//http
import 'package:http/http.dart' as http;

class SendEducation {
  Future<String> sendEducationToCVGenerator(Education thisEdu) async {
    try {
      final myBox = await Hive.openBox("myBox");
      final _token = await myBox.get('token');

      final fullData = {
        'nameOfUniversity': thisEdu.nameOfUniversity.trim(),
        'titleOfDocument': thisEdu.titleOfDocument.trim(),
        'CGPA': thisEdu.CGPA.trim(),
        'yearOfGraduation': thisEdu.yearOfGraduation.trim(),
        'cookie': _token
      };

      debugPrint("Sending Education to server");

      final client = http.Client();

      final res = await client.post(
          Uri.http('localhost:3000', 'api/education/new'),
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

  Future<List<Education>> getEducations() async {
    List<Education> thisUserEducations = [];

    try {
      final myBox = await Hive.openBox("myBox");
      final _token = await myBox.get('token');

      debugPrint("Sending get EDUCATION request to server");

      final client = http.Client();

      /*
      {
    "operation": "one-pi-get",
    "success": true,
    "reason": null,
    "solution": 
}
**/

      final Map<String, String> query = {'cookie': _token};

      final queryString = Uri(queryParameters: query).query;

      final res = await client.get(
          Uri.parse('http://localhost:3000/api/education/one?$queryString'));

      // debugPrint(res.body);

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

        List<Map<String, dynamic>> myEducations =
            solutionJsonList.cast<Map<String, dynamic>>();
        // debugPrint('solutionJson: $solutionJson');

        // debugPrint('looping');
        // for (var i = 0; i < myEducations.length; i++) {
        //   debugPrint('${i + 1} Education');
        //   for (var key in myEducations[i].keys) {
        //     var thisValue = myEducations[i][key];
        //     debugPrint('$key : ${thisValue}');
        //   }
        // }

        //facilitating for return, storing on list of 'Education'
        for (var i = 0; i < myEducations.length; i++) {
          debugPrint('${i + 1} Education');

          //this edu, values
          final nameOfUniversity = myEducations[i]['nameOfUniversity'];
          final titleOfDocument = myEducations[i]['titleOfDocument'];
          final CGPA = myEducations[i]['CGPA'];
          final yearOfGraduation = myEducations[i]['yearOfGraduation'];
          final id = myEducations[i]['_id'];

          //storing on constructor
          Education thisEdu = Education(
              nameOfUniversity, titleOfDocument, CGPA, yearOfGraduation, id);

          thisUserEducations.add(thisEdu);
        }

        return thisUserEducations;

        // debugPrint('=== The EDU ===');

        // debugPrint(' === Result Json === ');
      } else {
        return thisUserEducations;
      }
    } catch (e) {
      // Handle error
      String error = e.toString();
      debugPrint('Error: $error');
      return thisUserEducations;
    }
  }

  Future<String> deleteEducation(String eduID) async {
    try {
      final myBox = await Hive.openBox("myBox");
      final _token = await myBox.get('token');

      debugPrint("Sending Delete EDUCATION request to server");

      final client = http.Client();

      final Map<String, String> query = {'_id': eduID.trim(), 'cookie': _token};
      final queryString = Uri(queryParameters: query).query;

      final res = await client.delete(
          Uri.parse('http://localhost:3000/api/education/delete?$queryString'));

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

class Education {
  final _nameOfUniversity, _titleOfDocument, _CGPA, _yearOfGraduation, _id;
  Education(this._nameOfUniversity, this._titleOfDocument, this._CGPA,
      this._yearOfGraduation, this._id);

  String get nameOfUniversity => _nameOfUniversity;
  String get titleOfDocument => _titleOfDocument;
  String get CGPA => _CGPA.toString();
  String get yearOfGraduation => _yearOfGraduation;
  String get id => _id;

  @override
  String toString() {
    final myString = ''' 
    nameOfUniversity : ${_nameOfUniversity},
    titleOfDocument : ${_titleOfDocument},
    CGPA : ${_CGPA},
    yearOfGraduation : ${_yearOfGraduation},
    ''';
    return myString;
  }
}
