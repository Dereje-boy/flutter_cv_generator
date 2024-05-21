import 'package:flutter/material.dart';

import 'dart:convert';

import './logic_experience.dart';

class singleExperienceWidget extends StatefulWidget {
  final Experience experience;
  final SendExperience _sender;
  const singleExperienceWidget(this.experience, this._sender, {super.key});

  @override
  State<singleExperienceWidget> createState() => _singleExperienceWidgetState();
}

class _singleExperienceWidgetState extends State<singleExperienceWidget> {
  bool deleted = false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !deleted,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white54, width: 2)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Position",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  widget.experience.position.toString().toUpperCase(),
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Company Name ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  widget.experience.companyName.toString().toUpperCase(),
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Start Date",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  widget.experience.startDate
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
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "End Date",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  "${widget.experience.endDate.toString().toLowerCase() == 'null' ? " -- " : widget.experience.startDate.toString().toUpperCase().substring(0, 10)} ",
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "About Experience ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  widget.experience.aboutExperience.toString().toUpperCase(),
                  textAlign: TextAlign.center,
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
                  "_id: ",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  widget.experience.id,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.red),
                  child: OutlinedButton(
                    onPressed: () {
                      widget._sender
                          .deleteExperience(widget.experience.id)
                          .then((response) {
                        try {
                          Map<String, dynamic> resultJson =
                              jsonDecode(response);

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
                      }).catchError((error) {
                        Map<String, dynamic> result = {
                          "operation": "delete",
                          "success": false,
                          "reason": " '''${error.toString().trim()}",
                          "solution": "Connect to Internet or Retry Later"
                        };
                      });
                    },
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
