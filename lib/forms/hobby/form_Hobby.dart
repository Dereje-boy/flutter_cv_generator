import 'package:flutter/material.dart';
import 'package:flutter_cv/forms/hobby/sub_singleHobby.dart';
import 'dart:convert';

import 'logic_hobby.dart';

class FormHobby extends StatefulWidget {
  const FormHobby({super.key});

  @override
  State<FormHobby> createState() => _FormHobbyState();
}

class _FormHobbyState extends State<FormHobby> {
  bool _messageSubmitted = false;
  String _submitMessage = '';

  bool _firstTime = true;

  bool _submitTapDown = false;

  String _valueHobby = '';

  TextEditingController _cHobby = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (_firstTime == true) {
      hobbies();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Image(
            image: AssetImage(
              'images/Hobbies.jpg',
            ),
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          const Text(
            "Your Added Hobbies",
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),

          // Hobbies list
          Column(
            children: hobbyWidget,
          ),

          const SizedBox(height: 20),
          const Text(
            "Add Your Hobbies Here",
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 30),

          //hobby field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              onChanged: (newValue) {
                if (mounted) {
                  setState(() {
                    _valueHobby = newValue;
                  });
                }
              },
              controller: _cHobby,
              keyboardType: TextInputType.text,
              // controller: _cLanguageName,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.green),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Reading books, .....",
                prefixIcon: Icon(
                  Icons.circle,
                  color: Colors.green,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Visibility(
            visible: _messageSubmitted,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                _submitMessage,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, color: Colors.blue),
              ),
            ),
          ),

          //some gap between the last text field and the submit btn
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              submittingForm();
            },
            onTapDown: (detail) {
              if (mounted) {
                setState(() {
                  _submitTapDown = true;
                });
              }
            },
            onTapUp: (detail) {
              if (mounted) {
                setState(() {
                  _submitTapDown = false;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: _submitTapDown ? Colors.white : Colors.green,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: _submitTapDown ? Colors.green : Colors.white),
              ),
              child: Center(
                child: Text(
                  'Submit',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _submitTapDown ? Colors.green : Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  SendHobby sender = SendHobby();
  List<Widget> hobbyWidget = [];

  void submittingForm() async {
    debugPrint({'hobby': _cHobby.text}.toString());
    final thisHobby = Hobby("_id", _cHobby.text);

    try {
      String response = await sender.sendHobbyToCVGenerator(thisHobby);
      Map<String, dynamic> resultJson = jsonDecode(response);

      debugPrint('response: $response');
      debugPrint(' === Result Json === ');
      var operation = resultJson['operation'];
      var solution = resultJson['solution'];
      var reason = resultJson['reason'];
      var success = resultJson['success'];
      if (mounted) {
        setState(() {
          _messageSubmitted = true;
        });
        // debugPrint('success..');
        String message = '';
        if (success == true) {
          message = solution;
          setState(() {
            hobbies();
            //reset the input fields
            _cHobby.text = '';
          });
        } else {
          debugPrint('success == false');
          message = "Solution : $solution \nReason: $reason";
        }
        if (mounted) {
          setState(() {
            _submitMessage = message;
          });
        }
      }
    } catch (e) {
      debugPrint('Error in parsing json or making request to server: \n');
      debugPrint('$e\n=== Error =====');
      if (mounted) {
        setState(() {
          _messageSubmitted = true;
          _submitMessage =
              "Unable to continue your request. Please, retry with internet connection available or contact the developer";
        });
      }
    }
  }

  void hobbies() async {
    final thisUserHobbies = await sender.getHobbies();
    debugPrint('thisUser hobbies ${thisUserHobbies.toString()}');
    for (String h in thisUserHobbies) {
      Hobby hobby = Hobby("_id", h);
      hobbyWidget.add(singleHobbyWidget(sender, hobby));
    }
  }
}
