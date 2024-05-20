import 'package:flutter/material.dart';
import 'package:flutter_cv/forms/Education/form_Education.dart';

//decode and encode json
import 'dart:convert';

//the logic part of this widget
import './logic_personal_Information.dart';

class formPersonalInformation extends StatefulWidget {
  const formPersonalInformation({super.key});

  @override
  State<formPersonalInformation> createState() =>
      formPersonalInformationState();
}

class formPersonalInformationState extends State<formPersonalInformation> {
  final _formKey = GlobalKey<FormState>();

  //first render track to get pi data from server
  bool _firstTime = true;

  bool _submitTapDown = false;

// to track the response from rest api
  bool _messageSubmitted = false;
  // the message coming from the rest api
  String _submitMessage = '';

  var _initialFirstname = '';
  var _initialLastname = '';
  var _initialPhoneNumber = '';
  var _initialEmail = '';
  var _initialCity = '';
  var _initialState = '';
  var _initialAboutMe = '';

  var _valueFirstname = '';
  var _valueLastname = '';
  var _valuePhoneNumber = '';
  var _valueEmail = '';
  var _valueCity = '';
  var _valueState = '';
  var _valueAboutMe = '';

  TextEditingController _controllerFirstname = TextEditingController();
  TextEditingController _controllerLastname = TextEditingController();
  TextEditingController _controllerPhoneNumber = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerCity = TextEditingController();
  TextEditingController _controllerState = TextEditingController();
  TextEditingController _controllerAboutMe = TextEditingController();

  SendPersonalInformationToCVGenerator sender =
      SendPersonalInformationToCVGenerator();

  Widget _MyTextFormField(
      String name, String example, Icon icon, WhichField field) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            readOnly: field == WhichField.Email ? true : false,
            controller: getController(field),
            maxLines: field == WhichField.AboutMe ? null : 1,
            onChanged: (newValue) {
              switch (field) {
                case WhichField.Firstname:
                  listenerFirstname(newValue);
                  break;
                case WhichField.Lastname:
                  listenerLastname(newValue);
                  break;
                case WhichField.PhoneNumber:
                  listenerPhoneNumber(newValue);
                  break;
                case WhichField.Email:
                  listenerEmail(newValue);
                  break;
                case WhichField.City:
                  listenerCity(newValue);
                  break;
                case WhichField.State:
                  listenerState(newValue);
                  break;
                case WhichField.AboutMe:
                  listenerAboutMe(newValue);
                  break;
              }
            },
            keyboardType: getInputType(field),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.green),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: name,
              prefixIcon: Icon(
                icon.icon,
                color: Colors.green,
              ),
            ),
          ),
        ),

        // TextFormField(
        //   decoration: InputDecoration(
        //     icon: icon,
        //     labelText: name,
        //     hintText: example,
        //   ),
        //   // keyboardType: TextInputType.phone,
        //   style: const TextStyle(
        //     color: Colors.blue,
        //     fontSize: 20,
        //     fontWeight: FontWeight.w600,
        //   ),
        //   onChanged: (newValue) {
        //     switch (field) {
        //       case WhichField.Firstname:
        //         listenerFirstname(newValue);
        //         break;
        //       case WhichField.Lastname:
        //         listenerLastname(newValue);
        //         break;
        //       case WhichField.PhoneNumber:
        //         listenerPhoneNumber(newValue);
        //         break;
        //       case WhichField.Email:
        //         listenerEmail(newValue);
        //         break;
        //       case WhichField.City:
        //         listenerCity(newValue);
        //         break;
        //       case WhichField.State:
        //         listenerState(newValue);
        //         break;
        //       case WhichField.AboutMe:
        //         listenerAboutMe(newValue);
        //         break;
        //     }
        //   },
        // ),
        Visibility(
          //for now I am hidden, but for future I will be visible if any error raised in the passed field(WhichField)
          visible: false,
          child: Text(
            textAlign: TextAlign.center,
            "This is erro message for $field",
            style: const TextStyle(color: Colors.red),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  //for the first time
  bool _forTheFirstTime = true;

  @override
  Widget build(BuildContext context) {
    if (_forTheFirstTime) {
      getDataFromCVGenerator();
      _forTheFirstTime = false;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          const SizedBox(height: 30),
          const Image(
            image: AssetImage(
              'images/personal_information.png',
            ),
            fit: BoxFit.cover,
          ),
          const Text(
            "Add Your Personal Information",
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 30),
          Form(
            child: Column(
              children: [
                //firstname textfield
                _MyTextFormField("Firstname", "example; Abebe",
                    const Icon(Icons.person), WhichField.Firstname),

                //lastname textfield
                _MyTextFormField("Lastname", "example: Bekele",
                    const Icon(Icons.person), WhichField.Lastname),

                //phoneNumber textfield
                _MyTextFormField("Phone No.", "example: 0922002200",
                    const Icon(Icons.phone), WhichField.PhoneNumber),

                //email textfield
                _MyTextFormField("Email", "example: someone@gmail.com",
                    const Icon(Icons.email), WhichField.Email),

                //city textfield
                _MyTextFormField("City", "example: Addis Abeba",
                    const Icon(Icons.location_city), WhichField.City),

                //state textfield
                _MyTextFormField("State or Region", "example: Addis Abeba",
                    const Icon(Icons.map_outlined), WhichField.State),

                //aboutMe textfield
                _MyTextFormField(
                    "About Me",
                    "",
                    const Icon(Icons.rotate_90_degrees_ccw),
                    WhichField.AboutMe),

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

                //some gap between the last text field and the submit btn
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
                        informationAlreadyExist
                            ? 'Update The Information'
                            : 'Save The Information',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color:
                                _submitTapDown ? Colors.green : Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          )
        ],
      ),
    );
  }

  void submittingForm() async {
    debugPrint('=== Submitting form... ===');
    setState(() {
      _valueFirstname = _controllerFirstname.text;
      _valueLastname = _controllerLastname.text;
      _valuePhoneNumber = _controllerPhoneNumber.text;
      _valueEmail = _controllerEmail.text;
      _valueCity = _controllerCity.text;
      _valueState = _controllerState.text;
      _valueAboutMe = _controllerAboutMe.text;

      _messageSubmitted = true;
    });
    PI_Object pi_object = PI_Object(_valueFirstname, _valueLastname,
        _valuePhoneNumber, _valueEmail, _valueCity, _valueState, _valueAboutMe);

    // debugPrint("firstname : $_valueFirstname ");
    // debugPrint("lastname : $_valueLastname ");
    // debugPrint("phoneNumber : $_valuePhoneNumber ");
    // debugPrint("email : $_valueEmail ");
    // debugPrint("city : $_valueCity ");
    // debugPrint("state : $_valueState ");
    // debugPrint("aboutMe : $_valueAboutMe ");

    String result = await sender.sendDataToCVGenerator(pi_object);

    try {
      Map<String, dynamic> resultJson = jsonDecode(result.toString());

      debugPrint(' === Result Json === ');

      var operation = resultJson['operation'];
      var solution = resultJson['solution'];
      var reason = resultJson['reason'];
      var success = resultJson['success'];

      if (success == true) {
        debugPrint('success..');
        setState(() {
          _submitMessage = solution;
        });
      } else {
        debugPrint('success == false');
        setState(() {
          _submitMessage = "Solution : $solution \nReason: $reason";
        });
      }
    } catch (e) {
      debugPrint('Error in parsing json or making request to server: \n');
      debugPrint('$e\n=== Error =====');
      setState(() {
        _submitMessage =
            "Unable to continue your request. Please, retry with available internet connection or contact the developer";
      });
    }
  }

  getInputType(WhichField field) {
    switch (field) {
      case WhichField.PhoneNumber:
        return TextInputType.phone;
      case WhichField.Email:
        return TextInputType.emailAddress;
      case WhichField.AboutMe:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  bool informationAlreadyExist = false;
  //
  Future<PI_Object> getDataFromCVGenerator() async {
    PI_Object PI = await sender.getDataFromCVGenerator();

    if (mounted) {
      setState(() {
        _controllerFirstname.text = PI.firstname.toUpperCase();
        _controllerLastname.text = PI.lastname.toUpperCase();
        _controllerPhoneNumber.text = PI.phoneNumber.toUpperCase();
        _controllerEmail.text = PI.email.toUpperCase();
        _controllerCity.text = PI.city.toUpperCase();
        _controllerState.text = PI.state.toUpperCase();
        _controllerAboutMe.text = PI.aboutMe.toUpperCase();

        if (PI.firstname.isNotEmpty) informationAlreadyExist = true;
      });
    }

    // debugPrint("$_valueFirstname : ${PI.firstname}");
    // debugPrint("$_valueLastname : ${PI.lastname}");
    // debugPrint("$_valuePhoneNumber : ${PI.phoneNumber}");
    // debugPrint("$_valueEmail : ${PI.email}");
    // debugPrint("$_valueCity : ${PI.city}");
    // debugPrint("$_valueState : ${PI.state}");
    // debugPrint("$_valueAboutMe : ${PI.aboutMe}");

    return PI;
  }

  TextEditingController getController(WhichField field) {
    TextEditingController thisController = TextEditingController();
    switch (field) {
      case WhichField.Firstname:
        thisController = _controllerFirstname;
        break;
      case WhichField.Lastname:
        thisController = _controllerLastname;
        break;
      case WhichField.PhoneNumber:
        thisController = _controllerPhoneNumber;
        break;
      case WhichField.Email:
        thisController = _controllerEmail;
        break;
      case WhichField.City:
        thisController = _controllerCity;
        break;
      case WhichField.State:
        thisController = _controllerState;
        break;
      case WhichField.AboutMe:
        thisController = _controllerAboutMe;
        break;
    }
    return thisController;
  }

  void listenerFirstname(String newFirstname) {
    setState(() {
      _valueFirstname = newFirstname;
    });
  }

  void listenerLastname(String newLastname) {
    setState(() {
      _valueLastname = newLastname;
    });
  }

  void listenerPhoneNumber(String newPhoneNumber) {
    setState(() {
      _valuePhoneNumber = newPhoneNumber;
    });
  }

  void listenerEmail(String newEmail) {
    setState(() {
      _valueEmail = newEmail;
    });
  }

  void listenerCity(String newCity) {
    setState(() {
      _valueCity = newCity;
    });
  }

  void listenerState(String newState) {
    setState(() {
      _valueState = newState;
    });
  }

  void listenerAboutMe(String newAboutMe) {
    setState(() {
      _valueAboutMe = newAboutMe;
    });
  }
}

enum WhichField {
  Firstname,
  Lastname,
  Email,
  PhoneNumber,
  City,
  State,
  AboutMe;
}
