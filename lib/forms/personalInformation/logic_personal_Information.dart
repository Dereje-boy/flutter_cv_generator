//for only debugPrint
import 'package:flutter/material.dart';

//hive
import 'package:hive/hive.dart';

//jaguar_resty http client
import 'package:jaguar_resty/jaguar_resty.dart';

//http
import 'package:http/http.dart' as http;
import 'package:client_cookie/client_cookie.dart';

//sending information gathered to backend service
class SendPersonalInformationToCVGenerator {
  Future<void> sendDataToCVGenerator(PI_Object payload) async {
    var fullData = {
      'firstname': payload.firstname,
      'lastname': payload.lastname,
      'phoneNumber': payload.phoneNumber,
      'email': payload.email,
      'city': payload.city,
      'state': payload.state,
      'aboutMe': payload.aboutMe,
      'cookie': 'this is my cookie'
    };

    try {
      final myBox = await Hive.openBox("myBox");
      final _token = await myBox.get('token');

      debugPrint('token: $_token');

      debugPrint("Sending actual PI data");
      const url = 'http://localhost:3000/basicInformation';

      final Map<String, String> cookieMap = {'cookie': 'token = $_token'};

      final client = http.Client();

      final res = await client.post(
          Uri.http('localhost:3000', 'basicInformation'),
          body: fullData,
          headers: cookieMap);

      debugPrint(res.body);
    } catch (e) {
      // Handle error
      String error = e.toString();
      debugPrint('Error: $error');
    }
  }
}

class PI_Object {
  var aboutMe;
  var city;
  var email;
  var firstname;
  var lastname;
  var phoneNumber;
  var state;

  PI_Object(this.firstname, this.lastname, this.phoneNumber, this.email,
      this.city, this.state, this.aboutMe) {
    debugPrint("I have recieved your data");
    debugPrint("Firstname: $firstname");
    debugPrint("Lastname: $lastname");
    debugPrint("PhoneNumber: $phoneNumber");
    debugPrint("Email: $email");
    debugPrint("City: $city");
    debugPrint("State: $state");
    debugPrint("AboutMe: $aboutMe");
  }
}
