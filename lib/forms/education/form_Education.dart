import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cv/forms/education/logic_education.dart';
import 'package:flutter_cv/forms/education/sub_singleEducation.dart';

class FormEducation extends StatefulWidget {
  const FormEducation({super.key});

  @override
  State<FormEducation> createState() => _FormEducationState();
}

class _FormEducationState extends State<FormEducation> {
  SendEducation sender = SendEducation();

  final _formKey = GlobalKey<FormState>();

  bool _firstTime = true;

  String _submitMessage = '';

  bool _messageSubmitted = false;

  bool _submitTapDown = false;

  final TextEditingController _cUniversityName = TextEditingController();
  final TextEditingController _cDocumentTitle = TextEditingController();
  final TextEditingController _cYearOfGraduation = TextEditingController();
  final TextEditingController _cCGPA = TextEditingController();

  String _valueUniversityName = '';
  String _valueDocumentTitle = '';
  String _valueYearOfGraduation = '';
  String _valueCGPA = '';

  @override
  Widget build(BuildContext context) {
    if (_firstTime) {
      educations();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          const SizedBox(height: 30),
          const Image(
            image: AssetImage(
              'images/education.jpg',
            ),
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          const Text(
            "Your Added Educations",
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),

          // Educations list
          Column(
            children: educationsWidget,
          ),

          const SizedBox(height: 20),
          const Text(
            "Add Your Education Here",
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 30),
          Form(
            key: _formKey,
            child: Column(
              children: [
                //university name textfield
                _MyTextFormField(
                    "Name of University",
                    "example; Addis Abeba University",
                    const Icon(Icons.cast_for_education),
                    WhichField.nameOfUniversity),

                //document title textfield
                _MyTextFormField(
                    "Document Title",
                    "example; Bsc in Civil Engineering",
                    const Icon(Icons.document_scanner),
                    WhichField.documentTitle),

                //year of graduation textfield
                _MyTextFormField(
                    "Year of Graduation",
                    "example; 2022",
                    const Icon(Icons.calendar_month),
                    WhichField.yearOfGraduation),

                CalendarDatePicker(
                    initialDate: DateTime.now(),
                    lastDate: DateTime(2050),
                    firstDate: DateTime(1960),
                    onDateChanged: (changedToDateTime) {
                      setState(() {
                        final selectedDate =
                            '${changedToDateTime.year}/${changedToDateTime.month}/${changedToDateTime.day}';
                        _valueYearOfGraduation =
                            _cYearOfGraduation.text = selectedDate;
                      });
                    }),

                //cgpa textfield
                _MyTextFormField("CGPA", "example; 3.65",
                    const Icon(Icons.score), WhichField.CGPA),

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
                case WhichField.nameOfUniversity:
                  UniversityNameListener(newValue);
                  break;
                case WhichField.documentTitle:
                  DocumentTitleListener(newValue);
                  break;
                case WhichField.yearOfGraduation:
                  YearOfGraduationListener(newValue);
                  break;
                case WhichField.CGPA:
                  CGPAListener(newValue);
              }
            },
            keyboardType: getInputType(field),
            controller: setTextConroller(field),
            readOnly: field == WhichField.yearOfGraduation ? true : false,
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

  void submittingForm() async {
    debugPrint('=== Submitting form... ===');
    debugPrint("Name of University : ${_valueUniversityName}");
    debugPrint("Document Title : ${_valueDocumentTitle}");
    debugPrint("Year of Graduation : ${_valueYearOfGraduation}");
    debugPrint("CGPA : ${_valueCGPA}");

    final thisEdu = Education(_valueUniversityName, _valueDocumentTitle,
        _valueCGPA, _valueYearOfGraduation, '');

    try {
      String response = await sender.sendEducationToCVGenerator(thisEdu);

      Map<String, dynamic> resultJson = jsonDecode(response);
      // debugPrint('response: $response');

      debugPrint(' === Result Json === ');

      var operation = resultJson['operation'];
      var solution = resultJson['solution'];
      var reason = resultJson['reason'];
      var success = resultJson['success'];

      setState(() {
        _messageSubmitted = true;
      });

      // debugPrint('success..');
      String message = '';
      if (success == true) {
        message = solution;
        educations();
      } else
        // debugPrint('success == false');
        message = "Solution : $solution \nReason: $reason";

      setState(() {
        _submitMessage = message;
      });
      setState(() {
        //reset the input fields
        if (success == true) {
          _cUniversityName.text =
              _cCGPA.text = _cDocumentTitle.text = _cYearOfGraduation.text = '';
        }
      });
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

  //listener methods
  void UniversityNameListener(String newName) {
    setState(() {
      _valueUniversityName = newName;
    });
  }

  void DocumentTitleListener(String newTitle) {
    setState(() {
      _valueDocumentTitle = newTitle;
    });
  }

  void YearOfGraduationListener(String newYear) {
    setState(() {
      _valueYearOfGraduation = newYear;
    });
  }

  void CGPAListener(String newCGPA) {
    setState(() {
      _valueCGPA = newCGPA;
    });
  }

  getInputType(WhichField field) {
    switch (field) {
      case WhichField.nameOfUniversity:
      case WhichField.documentTitle:
        return TextInputType.text;

      case WhichField.yearOfGraduation:
      case WhichField.CGPA:
        return TextInputType.number;
    }
  }

  TextEditingController setTextConroller(WhichField field) {
    switch (field) {
      case WhichField.nameOfUniversity:
        return _cUniversityName;
      case WhichField.documentTitle:
        return _cDocumentTitle;
      case WhichField.yearOfGraduation:
        return _cYearOfGraduation;
      case WhichField.CGPA:
        return _cCGPA;
    }
  }

  List<Widget> educationsWidget = [];

  educations() async {
    List<Education> thisUserEducations = await sender.getEducations();
    educationsWidget = [];
    for (var education in thisUserEducations) {
      debugPrint(education.toString());
      // educationsWidget.add(await singleEducation(education));
      educationsWidget.add(singleEducationWidget(education, sender));
    }

    setState(() {
      _firstTime = false;
    });
    return Column(
      children: educationsWidget,
    );
  }

  Future<Widget> singleEducation(Education education) async {
    bool thisEduVisible = true;

    return Visibility(
      visible: thisEduVisible,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white54, width: 2)),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "From:\t",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  education.nameOfUniversity.toString().toUpperCase(),
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "By:\t",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  education.titleOfDocument.toString().toUpperCase(),
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "In:\t",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  education.yearOfGraduation
                      .toString()
                      .toUpperCase()
                      .substring(0, 10),
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "With:\t",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  "${education.CGPA.toString()}  CGPA",
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "_id:\t",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  education.id,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: () {
                sender.deleteEducation(education.id).then((response) {
                  try {
                    Map<String, dynamic> resultJson = jsonDecode(response);

                    var operation = resultJson['operation'];
                    var solution = resultJson['solution'];
                    var reason = resultJson['reason'];
                    var success = resultJson['success'];
                    if (success == true) {
                      setState(() {
                        thisEduVisible = false;
                      });
                    }
                  } catch (error) {
                    Map<String, dynamic> result = {
                      "operation": "delete",
                      "success": false,
                      "reason": " '''${error.toString().trim()}",
                      "solution": "Connect to Internet."
                    };
                  }
                });
              },
              child: const Text(
                "Delete",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum WhichField {
  nameOfUniversity,
  documentTitle,
  yearOfGraduation,
  CGPA,
}
