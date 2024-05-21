import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_cv/forms/reference/logic_reference.dart';

class singleReferenceWidget extends StatefulWidget {
  final SendReference _sender;
  final Reference _reference;

  const singleReferenceWidget(this._sender, this._reference, {super.key});

  @override
  State<singleReferenceWidget> createState() => _singleReferenceWidgetState();
}

class _singleReferenceWidgetState extends State<singleReferenceWidget> {
  bool deleted = false;

  @override
  Widget build(BuildContext context) {
    debugPrint('rendering \n${widget._reference.toString()}');
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
          children: [
            Row(
              children: [
                const Text(
                  "Fullname:\t",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: Text(
                    widget._reference.fullname.toString().toUpperCase(),
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Phone No.:\t",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: Text(
                    widget._reference.phoneNumber.toString().toUpperCase(),
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Email:\t",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: Text(
                    widget._reference.email.toString().toUpperCase(),
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Role:\t",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: Text(
                    widget._reference.role.toString().toUpperCase(),
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500),
                  ),
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
                  widget._reference.id,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: deleteReference,
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

  void deleteReference() async {
    widget._sender.deleteReference(widget._reference.id).then((response) {
      try {
        Map<String, dynamic> resultJson = jsonDecode(response);

        var operation = resultJson['operation'];
        var solution = resultJson['solution'];
        var reason = resultJson['reason'];
        var success = resultJson['success'];

        if (success == true) {
          debugPrint('success == true');
          Map<String, dynamic> solutionJson = jsonDecode(jsonEncode(solution));

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
        "solution": "Connect to Internet."
      };
    });
  }
}
