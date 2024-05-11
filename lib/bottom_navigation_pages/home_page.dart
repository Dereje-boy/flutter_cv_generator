import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

//hive
import 'package:hive/hive.dart';

//the page after we click any of the forms
import '../forms/form_page.dart';
import 'form_list_widget.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  final bool formElementTapDown = false;

  String? _email = '', _password = "";

  bool _userInfoLoaded = false;

  @override
  Widget build(BuildContext context) {
    if (_userInfoLoaded == false) {
      getUserInfo();
      _userInfoLoaded = true;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 90,
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const Text(
                        "Welcome,",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ),
                      Text(
                        _email ?? "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          formListWidgets(),
        ],
      ),
    );
  }

  void getUserInfo() async {
    // final prefs = await SharedPreferences.getInstance();

    try {
      final myBox = await Hive.openBox("myBox");

      final myEmail = await myBox.get('email');
      final myPassword = await myBox.get('password');
      debugPrint("email : $myEmail \npassword: $myPassword");

      setState(() {
        _email = myEmail;
        _password = myPassword;
      });
    } catch (e) {
      debugPrint("Hive Error");
      debugPrint(e.toString());
    }
  }
}
