import 'package:flutter/material.dart';

class FormEducation extends StatefulWidget {
  const FormEducation({super.key});

  @override
  State<FormEducation> createState() => _FormEducationState();
}

class _FormEducationState extends State<FormEducation> {
  final _formKey = GlobalKey<FormState>();

  bool _submitTapDown = false;

  var _valueUniversityName = '';
  var _valueDocumentTitle = '';
  var _valueYearOfGraduation = '';
  var _valueCGPA = '';

  @override
  Widget build(BuildContext context) {
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

                //cgpa textfield
                _MyTextFormField("CGPA", "example; 3.65",
                    const Icon(Icons.score), WhichField.CGPA),

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

  void submittingForm() {
    debugPrint('=== Submitting form... ===');
    debugPrint("Name of University : $_valueUniversityName");
    debugPrint("Document Title : $_valueDocumentTitle");
    debugPrint("Year of Graduation : $_valueYearOfGraduation");
    debugPrint("CGPA : $_valueCGPA");
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
}

enum WhichField {
  nameOfUniversity,
  documentTitle,
  yearOfGraduation,
  CGPA,
}
