import 'package:flutter/material.dart';
import './personalInformation/form_personal_information.dart';
import './Education/Form_Education.dart';
import './Experience/form_experience.dart';
import './Language/form_Language.dart';

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
      body: widget_for_body(widget._title),
    );
  }

  Widget widget_for_body(whichForm form) {
    switch (form) {
      case whichForm.personalInformation:
        return formPersonalInformation();
      case whichForm.education:
        return FormEducation();
      case whichForm.experience:
        return FormExperience();
      case whichForm.languages:
        return FormLanguage();
      default:
        return formPersonalInformation();
    }
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
