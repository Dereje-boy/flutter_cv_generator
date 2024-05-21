import 'package:flutter/material.dart';

import 'logic_hobby.dart';

class singleHobbyWidget extends StatefulWidget {
  final SendHobby _sender;
  final Hobby _hobby;
  const singleHobbyWidget(this._sender, this._hobby, {super.key});

  @override
  State<singleHobbyWidget> createState() => _singleHobbyWidgetState();
}

class _singleHobbyWidgetState extends State<singleHobbyWidget> {
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
            Center(
              child: Expanded(
                child: Text(
                  widget._hobby.hobby.toString().toUpperCase(),
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {},
              child: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
