import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_cv/forms/reference/logic_reference.dart';
import 'package:flutter_cv/forms/reference/sub_singleReference.dart';

class FormReference extends StatefulWidget {
  const FormReference({super.key});

  @override
  State<FormReference> createState() => _FormReferenceState();
}

class _FormReferenceState extends State<FormReference> {
  bool _firstTime = true;

  bool _messageSubmitted = false;
  String _submitMessage = '';

  bool _submitTapDown = false;

  String _valueFullname = '';
  String _valuePhoneNumber = '';
  String _valueEmail = '';
  String _valueRole = '';

  TextEditingController _cFullname = TextEditingController();
  TextEditingController _cPhoneNumber = TextEditingController();
  TextEditingController _cEmail = TextEditingController();
  TextEditingController _cRole = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (_firstTime) {
      references();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Image(
            image: AssetImage(
              'images/reference.jpg',
            ),
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          const Text(
            "Your Added References",
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),

          //languages list
          Column(
            children: referencesWidget,
          ),

          const SizedBox(height: 20),

          const Text(
            "Add Your Reference Here",
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 30),

          //full name field
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
                    _valueFullname = newValue;
                  });
                }
              },
              controller: _cFullname,
              keyboardType: TextInputType.text,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.green),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Fullname: Abebe Kebede",
                prefixIcon: Icon(
                  Icons.circle,
                  color: Colors.green,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          //phone number field
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
                    _valuePhoneNumber = newValue;
                  });
                }
              },
              controller: _cPhoneNumber,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.green),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Phone: +25191100....",
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.green,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          //email field
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
                    _valueEmail = newValue;
                  });
                }
              },
              controller: _cEmail,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.green),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Email: some_one@gmail.com",
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.green,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          //email field
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
                    _valueRole = newValue;
                  });
                }
              },
              controller: _cRole,
              keyboardType: TextInputType.text,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.green),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Role: Senior Professional",
                prefixIcon: Icon(
                  Icons.arrow_upward,
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

  List<Widget> referencesWidget = [];
  SendReference sender = SendReference();

  references() async {
    List<Reference> thisUserReferences = await sender.getReferences();
    referencesWidget = [];

    if (thisUserReferences.isEmpty) {
      referencesWidget.add(Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Column(
              children: [
                Text(
                  'NO REFERENCE FOUND, ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.red[400]),
                ),
                const Text(
                  'After you added your references, they will be displayed here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          )));
    }

    for (var reference in thisUserReferences) {
      referencesWidget.add(singleReferenceWidget(sender, reference));
    }

    if (mounted) {
      setState(() {
        _firstTime = false;
      });
    }
  }

  void submittingForm() async {
    debugPrint('submitting form');
    debugPrint(''' 
    Fullname: $_valueFullname,
    phoneNumber: $_valuePhoneNumber,
    Email: $_valueEmail,
    Role: $_valueRole,
    ''');
    try {
      String response = await sender.sendReferenceToCVGenerator(Reference(
          '_id', _valueFullname, _valuePhoneNumber, _valueEmail, _valueRole));

      Map<String, dynamic> resultJson = jsonDecode(response);

      var operation = resultJson['operation'];
      var solution = resultJson['solution'];
      var reason = resultJson['reason'];
      var success = resultJson['success'];

      String message = '';
      if (success == true) {
        message = solution;
        references();
        if (mounted) {
          //reset the input fields
          _cFullname.text =
              _cPhoneNumber.text = _cEmail.text = _cRole.text = '';
        }
      } else {
        message = "Solution : $solution \nReason: $reason";
      }
      if (mounted) {
        setState(() {
          _messageSubmitted = true;
          _submitMessage = message;
        });
      }
    } catch (e) {
      debugPrint('Error in parsing json or making request to server: \n');
      debugPrint('$e\n=== Error =====');
      setState(() {
        _messageSubmitted = true;
        _submitMessage =
            "Unable to continue your request. Please, retry with available internet connection or contact the developer";
      });
    }
  }
}
