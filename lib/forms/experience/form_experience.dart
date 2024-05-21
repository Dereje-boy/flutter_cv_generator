import 'dart:convert';

import 'package:flutter/material.dart';

import './sub_singleExperience.dart';
import './logic_experience.dart';

class FormExperience extends StatefulWidget {
  const FormExperience({super.key});

  @override
  State<FormExperience> createState() => _FormExperienceState();
}

class _FormExperienceState extends State<FormExperience> {
  final _formKey = GlobalKey<FormState>();

  final sender = SendExperience();

  bool _firstTime = true;

  String _submitMessage = '';

  bool _messageSubmitted = false;

  bool _submitTapDown = false;

  final TextEditingController _cPOSITION = TextEditingController();
  final TextEditingController _cSTART_DATE = TextEditingController();
  final TextEditingController _cEND_DATE = TextEditingController();
  final TextEditingController _cCOMPANY_NAME = TextEditingController();
  final TextEditingController _cABOUT_EXPERIENCE = TextEditingController();

  String _valuePOSITION = '';
  String _valueSTART_DATE = '';
  bool _valueSTILL_HERE = false;
  String _valueEND_DATE = '';
  String _valueCOMPANY_NAME = '';
  String _valueABOUT_EXPERIENCE = '';

  @override
  Widget build(BuildContext context) {
    if (_firstTime) {
      experiences();
      _firstTime = false;
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Image(
            image: AssetImage(
              'images/experience.png',
            ),
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          const Text(
            "Your Added Experience",
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),

          // Educations list
          Column(
            children: experiencesWidget,
          ),

          const SizedBox(height: 20),
          const Text(
            "Add Your Experience Here",
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 30),
          Form(
            key: _formKey,
            child: Column(
              children: [
                //Position name textfield
                _MyTextFormField("Position", "example: Junior Civil Engineer",
                    const Icon(Icons.stairs), WhichField.POSITION),

                //Start Date textfield
                // _MyTextFormField("Start Date", "example; May 25, 2020",
                //     const Icon(Icons.calendar_today), WhichField.START_DATE),
                _START_DATE(),
                const SizedBox(height: 10),

                //Still Here textfield
                // _MyTextFormField("Still Here", "example; Yes",
                //     const Icon(Icons.time_to_leave), WhichField.STILL_HERE),
                _STILL_HERE(),
                const SizedBox(height: 10),

                //End Date textfield
                Visibility(
                  visible: _valueSTILL_HERE == true ? false : true,
                  child: _END_DATE(),
                ),
                const SizedBox(height: 10),

                //COMPANY NAME textfield
                _MyTextFormField(
                    "COMPANY NAME",
                    "example: X Construction Company",
                    const Icon(Icons.home),
                    WhichField.COMPANY_NAME),

                //ABOUT EXPERIENCE textfield
                _MyTextFormField(
                    "ABOUT EXPERIENCE",
                    "",
                    const Icon(Icons.rotate_90_degrees_ccw),
                    WhichField.ABOUT_EXPERIENCE),

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
                case WhichField.POSITION:
                  POSITION_Listener(newValue);
                  break;
                case WhichField.END_DATE:
                  END_DATE_Listener(newValue);
                  break;
                case WhichField.COMPANY_NAME:
                  COMPANY_NAME_Listener(newValue);
                  break;
                case WhichField.ABOUT_EXPERIENCE:
                  ABOUT_EXPERIENCE_Listener(newValue);
              }
            },
            keyboardType: getInputType(field),
            controller: setTextConroller(field),
            maxLines: field == WhichField.ABOUT_EXPERIENCE ? null : 1,
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

  Widget _START_DATE() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.calendar_today,
            color: Colors.green,
          ),
          const SizedBox(width: 10),
          Text(
            pickedStartDate.isEmpty
                ? "Start Date:____________"
                : pickedStartDate,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(width: 10),
          IconButton(
              onPressed: () {
                _selectStartDate(context);
              },
              icon: const Icon(
                Icons.date_range_outlined,
                color: Colors.green,
              )),
        ],
      ),
    );
  }

  Widget _STILL_HERE() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.location_pin,
            color: Colors.green,
          ),
          const SizedBox(width: 10),
          const Text(
            "Still In the Same Position ?",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(width: 10),
          // TextFormField(
          //   onChanged: (newValue) {},
          //   style: const TextStyle(
          //       fontWeight: FontWeight.bold, color: Colors.green),
          //   decoration: const InputDecoration(
          //     border: InputBorder.none,
          //     prefixIcon: Icon(
          //       Icons.location_pin,
          //       color: Colors.green,
          //     ),
          //   ),
          //   readOnly: true,
          // ),
          Checkbox(
              value: _valueSTILL_HERE,
              onChanged: (value) {
                STILL_HERE_Listener(value != null ? value : false);
              }),
        ],
      ),
    );
  }

  Widget _END_DATE() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.calendar_today,
            color: Colors.green,
          ),
          const SizedBox(width: 10),
          Text(
            pickedEndDate.isEmpty ? "End Date:____________" : pickedEndDate,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(width: 10),
          IconButton(
              onPressed: () {
                _selectEndDate(context);
              },
              icon: const Icon(
                Icons.date_range_outlined,
                color: Colors.green,
              )),
        ],
      ),
    );
  }

  List<Widget> experiencesWidget = [];
  experiences() async {
    List<Experience> thisUserExperience = await sender.getExperience();

    experiencesWidget = [];
    if (thisUserExperience.isEmpty) {
      experiencesWidget.add(Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Column(
              children: [
                Text(
                  'NO EXPERIENCE FOUND, ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.red[400]),
                ),
                const Text(
                  'After you added your experiences, they will be displayed here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          )));
    }

    if (mounted) {
      setState(() {
        debugPrint("looping over exp...");
        for (var experience in thisUserExperience) {
          debugPrint(experience.toString());
          experiencesWidget.add(singleExperienceWidget(experience, sender));
        }
      });
    }

    return Column(
      children: experiencesWidget,
    );
  }

  //listener methods
  void POSITION_Listener(String POSITION) {
    if (mounted) {
      setState(() {
        _valuePOSITION = POSITION;
      });
    }
  }

  void STILL_HERE_Listener(bool STILL_HERE) {
    if (mounted) {
      setState(() {
        _valueSTILL_HERE = STILL_HERE;
      });
    }
  }

  void END_DATE_Listener(String END_DATE) {
    if (mounted) {
      setState(() {
        _valueEND_DATE = END_DATE;
      });
    }
  }

  void COMPANY_NAME_Listener(String COMPANY_NAME) {
    if (mounted) {
      setState(() {
        _valueCOMPANY_NAME = COMPANY_NAME;
      });
    }
  }

  void ABOUT_EXPERIENCE_Listener(String ABOUT_EXPERIENCE) {
    if (mounted) {
      setState(() {
        _valueABOUT_EXPERIENCE = ABOUT_EXPERIENCE;
      });
    }
  }

  getInputType(WhichField field) {
    switch (field) {
      case WhichField.ABOUT_EXPERIENCE:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  TextEditingController setTextConroller(WhichField field) {
    switch (field) {
      case WhichField.POSITION:
        return _cPOSITION;
      case WhichField.START_DATE:
        return _cSTART_DATE;
      case WhichField.STILL_HERE:
        return TextEditingController();
      case WhichField.END_DATE:
        return _cEND_DATE;
      case WhichField.COMPANY_NAME:
        return _cCOMPANY_NAME;
      case WhichField.ABOUT_EXPERIENCE:
        return _cABOUT_EXPERIENCE;
    }
  }

  void submittingForm() async {
    Experience experience = Experience(
        "_id",
        _valuePOSITION,
        _valueCOMPANY_NAME,
        _valueABOUT_EXPERIENCE,
        _valueSTART_DATE,
        _valueSTILL_HERE,
        _valueEND_DATE);

    debugPrint(experience.toString());

    String result = await sender.sendExperienceToCVGenerator(experience);

    debugPrint("submit exp form");
    Map<String, dynamic> resultJson = jsonDecode(result);
    if (resultJson['success'] == true) {
      //exp inserted successfully
      if (mounted) {
        setState(() {
          _messageSubmitted = true;
          _submitMessage = resultJson['solution'];
          experiences();

          //resetting
          pickedEndDate = 'End Date: ';
          pickedStartDate = 'Start Date: ';

          _cPOSITION.text = '';
          _cCOMPANY_NAME.text = '';
          _cABOUT_EXPERIENCE.text = '';

          _valuePOSITION = '';
          _valueCOMPANY_NAME = '';
          _valueABOUT_EXPERIENCE = '';
        });
      }
    } else {
      setState(() {
        _messageSubmitted = true;
        _submitMessage =
            "Solution: ${resultJson['solution']} \nReason: ${resultJson['reason']}";
      });
    }
    debugPrint(result);
  }

  String pickedStartDate = '';
  String pickedEndDate = '';

  void _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        lastDate: DateTime(2050),
        firstDate: DateTime(1960));
    if (picked != null) {
      if (mounted) {
        setState(() {
          pickedStartDate =
              'Start Date: ${picked.year} / ${picked.month} / ${picked.day}';
          _valueSTART_DATE = '${picked.year} / ${picked.month} / ${picked.day}';
        });
      }
    }
  }

  void _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        lastDate: DateTime(2050),
        firstDate: DateTime(1960));
    if (picked != null) {
      if (mounted) {
        setState(() {
          pickedEndDate =
              'End Date: ${picked.year} / ${picked.month}/ ${picked.day}';

          _valueEND_DATE = '${picked.year} / ${picked.month} / ${picked.day}';
        });
      }
    }
  }
}

enum WhichField {
  POSITION,
  START_DATE,
  STILL_HERE,
  END_DATE,
  COMPANY_NAME,
  ABOUT_EXPERIENCE,
}
