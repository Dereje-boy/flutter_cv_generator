import 'package:flutter/material.dart';

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

  bool _submitTapDown = false;

  var _valueFirstname = '';
  var _valueLastname = '';
  var _valuePhoneNumber = '';
  var _valueEmail = '';
  var _valueCity = '';
  var _valueState = '';
  var _valueAboutMe = '';

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
          child: TextFormField(
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

  @override
  Widget build(BuildContext context) {
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
            key: _formKey,
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

                //some gap between the last text field and the submit btn
                const SizedBox(height: 20),

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

  void submittingForm() {
    debugPrint('=== Submitting form... ===');

    PI_Object pi_object = PI_Object(_valueFirstname, _valueLastname,
        _valuePhoneNumber, _valueEmail, _valueCity, _valueState, _valueAboutMe);

    SendPersonalInformationToCVGenerator sender =
        SendPersonalInformationToCVGenerator();
    sender.sendDataToCVGenerator(pi_object);
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

  getInputType(WhichField field) {
    switch (field) {
      case WhichField.PhoneNumber:
        return TextInputType.phone;
        break;
      case WhichField.Email:
        return TextInputType.emailAddress;
        break;
      case WhichField.AboutMe:
        return TextInputType.multiline;
        break;
      default:
        return TextInputType.text;
    }
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
