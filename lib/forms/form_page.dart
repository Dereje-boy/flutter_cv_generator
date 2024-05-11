import 'package:flutter/material.dart';
import './personalInformation/form_personal_information.dart';
import './Education/Form_Education.dart';

class FormWidget extends StatefulWidget {
  whichForm _title;
  FormWidget(this._title, {super.key});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_circle_left),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(interpretWhichForm(widget._title)),
      ),
      body: widget._title == whichForm.education
          ? const FormEducation()
          : const formPersonalInformation(),
    );
  }
}

enum whichForm {
  personalInformation,
  education,
  experience,
  languages,
  reference,
  hobbies;
}

String interpretWhichForm(whichForm form) {
  switch (form) {
    case whichForm.personalInformation:
      return "Personal Information";
    case whichForm.education:
      return "Education";
    case whichForm.experience:
      return "Experience";
    case whichForm.languages:
      return "Languages";
    case whichForm.reference:
      return "Reference";
    case whichForm.hobbies:
      return "Hobbies";
  }
}
