//for only debugPrint
import 'package:flutter/material.dart';

//for conversion of json
import 'dart:convert';

//hive
import 'package:hive/hive.dart';

//jaguar_resty http client
// import 'package:jaguar_resty/jaguar_resty.dart';

//http
import 'package:http/http.dart' as http;

//sending information gathered to backend service
class SendPersonalInformationToCVGenerator {
  Future<String> sendDataToCVGenerator(PI_Object payload) async {
    // const baseUrl = 'cv.dere.com.et';
    const baseUrl = 'localhost:3000';

    try {
      final myBox = await Hive.openBox("myBox");
      final _token = await myBox.get('token');

      final fullData = {
        'firstname': payload.firstname,
        'lastname': payload.lastname,
        'phoneNumber': payload.phoneNumber,
        'email': payload.email,
        'city': payload.city,
        'state': payload.state,
        'aboutMe': payload.aboutMe,
        'cookie': _token
      };

      debugPrint('token: $_token');

      debugPrint("Sending actual PI data");

      final Map<String, String> cookieMap = {'cookie': 'token = $_token'};

      final client = http.Client();

      final res = await client.post(
          Uri.http(baseUrl, 'api/basicInformation/new'),
          body: fullData,
          headers: cookieMap);

      debugPrint(res.body);
      return res.body;
    } catch (e) {
      // Handle error
      String error = e.toString();
      debugPrint('Error: $error');

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

  String _email = '';
  Future<PI_Object> getDataFromCVGenerator() async {
    try {
      final myBox = await Hive.openBox("myBox");
      final _token = await myBox.get('token');
      _email = await myBox.get('email');

      debugPrint("Sending get PI request to server");

      final client = http.Client();

      /*
      {
    "operation": "one-pi-get",
    "success": true,
    "reason": null,
    "solution": {
        "_id": "663c810d40b579464a1445f0",
        "firstname": "der",
        "lastname": "gezahegn",
        "phoneNumber": "0988776655",
        "email": "dere@gmail.com",
        "city": "addis abeba",
        "state": "addis abeba",
        "aboutMe": "it is all about me",
        "user_id": "663c7f7540b579464a1445ec",
        "__v": 0
    }
}
**/

      final Map<String, String> query = {'cookie': _token};

      final queryString = Uri(queryParameters: query).query;

      final res = await client.get(Uri.parse(
          'http://localhost:3000/api/basicInformation/one?$queryString'));

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
        //there is pi
        String solutionJsonEncode = jsonEncode(solution);
        Map<String, dynamic> solutionJson = jsonDecode(solutionJsonEncode);
        // debugPrint('solutionJson: $solutionJson');

        // debugPrint('=== The PI ===');

        final firstname = solutionJson['firstname'];
        final lastname = solutionJson['lastname'];
        final phoneNumber = solutionJson['phoneNumber'];
        final city = solutionJson['city'];
        final state = solutionJson['state'];
        final aboutMe = solutionJson['aboutMe'];

        // debugPrint('firstname: $firstname');
        // debugPrint('lastname: $lastname');
        // debugPrint('phoneNumber: $phoneNumber');
        // debugPrint('city: $city');
        // debugPrint('state: $state');
        // debugPrint('aboutMe: $aboutMe');

        // debugPrint(' === Result Json === ');

        return PI_Object(
            firstname, lastname, phoneNumber, _email, city, state, aboutMe);
      } else {
        return PI_Object("", "", "", _email, "", "", "");
      }
    } catch (e) {
      // Handle error
      String error = e.toString();
      debugPrint('Error: $error');
      return PI_Object("", "", "", _email, "", "", "");
    }
  }
}

class PI_Object {
  var _aboutMe;
  var _city;
  var _email;
  var _firstname;
  var _lastname;
  var _phoneNumber;
  var _state;

  PI_Object(this._firstname, this._lastname, this._phoneNumber, this._email,
      this._city, this._state, this._aboutMe) {
    // debugPrint("I have recieved your data");
    // debugPrint("Firstname: $firstname");
    // debugPrint("Lastname: $lastname");
    // debugPrint("PhoneNumber: $phoneNumber");
    // debugPrint("Email: $email");
    // debugPrint("City: $city");
    // debugPrint("State: $state");
    // debugPrint("AboutMe: $aboutMe");
  }

  String get firstname => _firstname;
  String get lastname => _lastname;
  String get phoneNumber => _phoneNumber;
  String get email => _email;
  String get city => _city;
  String get state => _state;
  String get aboutMe => _aboutMe;
}
