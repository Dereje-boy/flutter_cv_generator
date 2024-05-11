import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:flutter_cv/forms/education/logic_education.dart';

class singleEducationWidget extends StatefulWidget {
  final Education education;
  final SendEducation _sender;
  const singleEducationWidget(this.education, this._sender, {super.key});

  @override
  State<singleEducationWidget> createState() => _singleEducationWidgetState();
}

class _singleEducationWidgetState extends State<singleEducationWidget> {
  bool deleted = false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !deleted,
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
                  widget.education.nameOfUniversity.toString().toUpperCase(),
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
                  widget.education.titleOfDocument.toString().toUpperCase(),
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
                  widget.education.yearOfGraduation
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
                  "${widget.education.CGPA.toString()}  CGPA",
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
                  widget.education.id,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: () {
                widget._sender
                    .deleteEducation(widget.education.id)
                    .then((response) {
                  try {
                    Map<String, dynamic> resultJson = jsonDecode(response);

                    var operation = resultJson['operation'];
                    var solution = resultJson['solution'];
                    var reason = resultJson['reason'];
                    var success = resultJson['success'];

                    if (success == true) {
                      debugPrint('success == true');
                      Map<String, dynamic> solutionJson =
                          jsonDecode(jsonEncode(solution));

                      //{ acknowledged: true, deletedCount: 1 }
                      debugPrint('solutionJson == $solutionJson');
                      if (solutionJson['acknowledged'] == true &&
                          solutionJson['deletedCount'] == 1) {
                        setState(() {
                          deleted = true;
                        });
                      }
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
