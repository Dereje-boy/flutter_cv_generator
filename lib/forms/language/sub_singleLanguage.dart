import 'package:flutter/material.dart';
import 'dart:convert';

class singleLanguageWidget extends StatefulWidget {
  final _sender, _language;
  const singleLanguageWidget(this._sender, this._language, {super.key});

  @override
  State<singleLanguageWidget> createState() => _singlLanguagenWidgetState();
}

class _singlLanguagenWidgetState extends State<singleLanguageWidget> {
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
          children: [
            Row(
              children: [
                const Text(
                  "Language:\t",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  widget._language.language.toString().toUpperCase(),
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
                  "Level:\t",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  widget._language.level.toString().toUpperCase(),
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
                  widget._language.id,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: deleteLanguage,
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

  void deleteLanguage() {
    widget._sender.deleteLanguage(widget._language.id).then((response) {
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
    }).catchError((error) {});
  }
}
