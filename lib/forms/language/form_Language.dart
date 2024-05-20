import 'package:flutter/material.dart';
import 'package:flutter_cv/forms/language/sub_singleLanguage.dart';

import 'dart:convert';
import 'logic_language.dart';

class FormLanguage extends StatefulWidget {
  const FormLanguage({super.key});

  @override
  State<FormLanguage> createState() => _FormLanguageState();
}

class _FormLanguageState extends State<FormLanguage> {
  final TextEditingController _cLanguageName = TextEditingController();

  String _valueLanguageName = '';
  String _valueLanguageLevel = 'Native';

  String _submitMessage = '';
  bool _messageSubmitted = false;
  bool _submitTapDown = false;

  bool _firstTime = true;

  @override
  Widget build(BuildContext context) {
    if (_firstTime) {
      languages();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Image(
            image: AssetImage(
              'images/languages.jpg',
            ),
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          const Text(
            "Your Added Languages",
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),

          //languages list
          Column(
            children: languagesWidget,
          ),

          const SizedBox(height: 20),

          const Text(
            "Add Your Languages Here",
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 30),

          //language name field
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  onChanged: (newValue) {
                    setState(() {
                      _valueLanguageName = newValue;
                    });
                  },
                  controller: _cLanguageName,
                  keyboardType: TextInputType.text,
                  // controller: _cLanguageName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Amharic",
                    prefixIcon: Icon(
                      Icons.circle,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),

          //language level drop down
          Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.stairs,
                      color: Colors.green,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: DropdownButton(
                          items: const [
                            DropdownMenuItem(
                              value: "Native",
                              child: Text(
                                "Native",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ),
                            DropdownMenuItem(
                              value: "Fluent",
                              child: Text(
                                "Fluent",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ),
                            DropdownMenuItem(
                              value: "Advanced",
                              child: Text(
                                "Advanced",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ),
                            DropdownMenuItem(
                              value: "Beginner",
                              child: Text(
                                "Beginner",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ),
                          ],
                          value: _valueLanguageLevel,
                          onChanged: ((value) {
                            setState(() {
                              _valueLanguageLevel = value ?? '';
                            });
                          })),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),

          const SizedBox(height: 10),

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
              setState(() {
                _submitTapDown = true;
              });
            },
            onTapUp: (detail) {
              setState(() {
                _submitTapDown = false;
              });
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

  List<Widget> languagesWidget = [];

  languages() async {
    List<Language> thisUserLanguages = await sender.getLanguages();
    languagesWidget = [];

    if (thisUserLanguages.isEmpty) {
      languagesWidget.add(Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Column(
              children: [
                Text(
                  'NO LANGUAGE FOUND, ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.red[400]),
                ),
                const Text(
                  'After you added your languages, they will be displayed here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          )));
    }

    for (var language in thisUserLanguages) {
      languagesWidget.add(singleLanguageWidget(sender, language));
    }

    setState(() {
      _firstTime = false;
    });
  }

  final SendLanguage sender = SendLanguage();
  void submittingForm() async {
    debugPrint(
        {'name': _cLanguageName.text, 'level': _valueLanguageLevel}.toString());

    final thisLang =
        Language("_id", _cLanguageName.text, _valueLanguageLevel, "user_id");

    try {
      String response = await sender.sendLanguageToCVGenerator(thisLang);
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
          languages();

          //reset the input fields
          _cLanguageName.text = '';
        } else {
          debugPrint('success == false');
          message = "Solution : $solution \nReason: $reason";
        }
        setState(() {
          _submitMessage = message;
        });
      }
    } catch (e) {
      debugPrint('Error in parsing json or making request to server: \n');
      debugPrint('$e\n=== Error =====');
      setState(() {
        _messageSubmitted = true;
        _submitMessage =
            "Unable to continue your request. Please, retry with internet connection available or contact the developer";
      });
    }
  }
}
