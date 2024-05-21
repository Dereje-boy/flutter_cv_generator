//for only debugPrint
import 'package:flutter/material.dart';

//for conversion of json
import 'dart:convert';

//hive
import 'package:hive/hive.dart';

//http
import 'package:http/http.dart' as http;

class SendReference {
  Future<String> sendReferenceToCVGenerator(Reference reference) async {
    debugPrint("Sending Language to server ");

    try {
      final myBox = await Hive.openBox('myBox');
      final _token = await myBox.get('token');
      final fullData = {
        'fullname': reference.fullname,
        'phoneNumber': reference.phoneNumber,
        'email': reference.email,
        'role': reference.role,
        'cookie': _token
      };

      debugPrint(fullData.toString());

      final client = http.Client();
      final res = await client.post(
          Uri.http('localhost:3000', 'api/reference/new'),
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

  Future<List<Reference>> getReferences() async {
    List<Reference> thisUserReferences = [];

    try {
      final myBox = await Hive.openBox('myBox');
      final _token = await myBox.get('token');

      debugPrint("Sending get REFERENCE request to server");

      final client = http.Client();

      final Map<String, String> query = {'cookie': _token};

      final queryString = Uri(queryParameters: query).query;

      final res = await client.get(
          Uri.parse('http://localhost:3000/api/reference/one?$queryString'));

      debugPrint(res.body);

      final Map<String, dynamic> resultJson = jsonDecode(res.body);

      var operation = resultJson['operation'];
      var solution = resultJson['solution'];
      var reason = resultJson['reason'];
      var success = resultJson['success'];

      if (success == true) {
        String solutionJsonEncode = jsonEncode(solution);

        List<dynamic> solutionJsonList = jsonDecode(solutionJsonEncode);

        List<Map<String, dynamic>> myReferences =
            solutionJsonList.cast<Map<String, dynamic>>();

        for (var thisRef in myReferences) {
          final _id = thisRef['_id'];
          final _fullname = thisRef['fullname'];
          final _phoneNumber = thisRef['phoneNumber'];
          final _email = thisRef['email'];
          final _role = thisRef['role'];

          thisUserReferences
              .add(Reference(_id, _fullname, _phoneNumber, _email, _role));
        }
        return thisUserReferences;
      } else {
        return thisUserReferences;
      }
    } catch (e) {
      // Handle error
      String error = e.toString();
      debugPrint('Error: $error');
      return thisUserReferences;
    }
  }

  Future<String> deleteReference(String refID) async {
    try {
      final myBox = await Hive.openBox('myBox');
      final _token = await myBox.get('token');

      debugPrint("Sending Delete REFERENCE request to server");

      final client = http.Client();

      final Map<String, String> query = {'_id': refID.trim(), 'cookie': _token};

      final queryString = Uri(queryParameters: query).query;

      final res = await client.delete(
          Uri.parse('http://localhost:3000/api/reference/delete?$queryString'));

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

class Reference {
  final _id, _fullname, _phoneNumber, _email, _role;
  Reference(
      this._id, this._fullname, this._phoneNumber, this._email, this._role);

  dynamic get id => _id;
  dynamic get fullname => _fullname;
  dynamic get phoneNumber => _phoneNumber;
  dynamic get email => _email;
  dynamic get role => _role;

  @override
  String toString() {
    final myString = ''' 
    _id : ${_id},
    fullname : ${_fullname},
    phoneNumber : ${_phoneNumber},
    email : ${_email},
    role : ${_role},
    ''';
    return myString;
  }
}
