import 'package:flutter/material.dart';
import '../forms/form_page.dart';

class formListWidgets extends StatelessWidget {
  const formListWidgets({super.key});

  void _gestureTapped(whichForm formName, BuildContext context) {
    debugPrint(interpretWhichForm(formName) + ' Tapped');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return FormWidget(formName);
        },
      ),
    );
  }

  Widget renderForms(String imagePath, String title, String text,
      whichForm whichForm, BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 1),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            Image(
                image: AssetImage(
                  imagePath,
                ),
                width: 100,
                fit: BoxFit.cover),
            Expanded(
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(5, 2, 5, 5),
                        child: Center(
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        _gestureTapped(whichForm, context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First List  = PERSONAL INFORMATION
        renderForms(
            'images/personal_information.png',
            "Personal Information ",
            'Fill your personal informations like name, phone number, email and others',
            whichForm.personalInformation,
            context),
        // Second List  = EDUCATION
        renderForms(
            'images/education.jpg',
            "Education",
            'Add your Education detail : Department, University or graduation, CGPA and Year of graduation. It is mendatory...',
            whichForm.education,
            context),
        // Third List  = EXPERIENCE
        renderForms(
            'images/experience.png',
            "Experience",
            'Add all of your relevant Experiences to be visible to employers',
            whichForm.experience,
            context),
        // Third List  = LANGUAGES
        renderForms(
            'images/languages.jpg',
            "Languages",
            'Being multiple language speaker has more chance to get job. List all of languages you know with their level.',
            whichForm.languages,
            context),
        // Third List  = REFERENCE
        renderForms(
            'images/reference.jpg',
            "Reference",
            'Always it is better to have reference who knows you very well, to express you in the way that gives you better chance for further assessement.',
            whichForm.reference,
            context),
        // Third List  = HOBBIES
        renderForms(
            'images/Hobbies.jpg',
            "Hobbies",
            'Hobbies are optoinal to have on cv or resume. Just add some to let the Hiring Managers knows you more.',
            whichForm.hobbies,
            context),
      ],
    );
  }
}
