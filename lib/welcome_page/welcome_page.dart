import 'package:flutter/material.dart';
import 'package:flutter_cv/bottom_navigation_pages/home_page.dart';

//hive
import 'package:hive/hive.dart';

//login and signup page
import './login_page.dart';
import './sign_up_page.dart';

//home with bottom navigation bars
import '../home_page/home.dart';

class WelcomePage extends StatefulWidget {
  final bool _userLoggedIn;
  const WelcomePage(this._userLoggedIn, {super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

bool _tappedDown = false;

String _email = '', _password = '';

bool _userInfoFound = false;
bool userInfoChecked = false;

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    if (userInfoChecked == false) {
      debugPrint("checking existance of user ");
      getUserInfo().then((c) {
        debugPrint('.then function of getUserInfo method');
        if (_userInfoFound) {
          debugPrint("redirecting to home with nav bars");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return Home();
              },
            ),
          );
        }
      });
      userInfoChecked = true;
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("CV Generator"),
        leading: widget._userLoggedIn
            ? IconButton(
                icon: const Icon(Icons.arrow_circle_left),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                child: const Image(
                  image: AssetImage('images/cv_generator_log.png'),
                  height: 30,
                ),
              ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
        child: Center(
          child: Column(
            children: [
              const Text(
                "Welcome to the CV Generator",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.green),
              ),
              const Image(
                image: AssetImage('images/cv_generator_log.png'),
                height: 100,
              ),
              const ListTile(
                title: Text(
                  "Steps to have 'AMAZING CV'",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue),
                ),
              ),
              MyListTile("", '1. Create Account'),
              MyListTile("", '2. Fill Your Informations'),
              MyListTile("", '3. Click "My Cv" Button'),
              const SizedBox(
                height: 20.0, // Add vertical space
              ),
              // Descriptions for each and every step listed above
              //first step
              stepsWidget(
                "Create Account",
                "First create account your ur email and password. Then you will be able to fill your name, university and other required information. The email you used here will be used login next time you. Additionally it will be displayed on your cv under contact addresses section.",
              ),
              //second step
              stepsWidget("Fill Your Information",
                  "In this second step you are required to fill your information like name, phone No. , Email address, College or University, Experience if you have any, Languages you are able to speak and other required informations which are vital for you to have on your cv."),
              //third step
              stepsWidget("Download CV",
                  'After filling your personal information, you can click the "Download My Cv" button which will be displayed on the app screen. The CV will be provided for you in different design and you can download with your prefered design. Then after, The download CV will be put in the Download folder of your internal storage.'),
              //Good luck
              const Text(
                "=== Good Luck ===",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue),
              ),
              const SizedBox(
                height: 40.0, // Add vertical space
              ),
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  decoration: BoxDecoration(
                    color: _tappedDown
                        ? Colors.white
                        : Colors.blue, // Set your desired background color here
                    borderRadius: BorderRadius.circular(
                        10.0), // Optional: Set border radius
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Start Now.....",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: _tappedDown ? Colors.blue : Colors.white),
                      ),
                      Text(
                        "click Start Now button to login or signup",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: _tappedDown ? Colors.blue : Colors.white),
                      ),
                      const SizedBox(
                        height: 16.0, // Add vertical space
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  debugPrint('Showing login and signup widget/ page');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Scaffold(
                            appBar: AppBar(
                              title: const Text("Cv Generator"),
                              leading: IconButton(
                                icon: const Icon(Icons.arrow_circle_left),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            body: SignUpPage());
                      },
                    ),
                  );
                },
                onTapDown: (detail) {
                  setState(() {
                    _tappedDown = true;
                  });
                },
                onTapUp: (detail) {
                  setState(() {
                    _tappedDown = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile MyListTile(String leading, String title) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget stepsWidget(String stepName, String stepDesc) {
    return Column(
      children: [
        Text(
          stepName,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.w600, color: Colors.blue),
        ),
        Text(
          stepDesc,
          textAlign: TextAlign.justify,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 16.0, // Add vertical space
        ),
      ],
    );
  }

  Future<void> getUserInfo() async {
    try {
      final myBox = await Hive.openBox("myBox");

      final myEmail = await myBox.get('email');
      final myPassword = await myBox.get('password');
      debugPrint("email : $myEmail \npassword: $myPassword");

      if (myEmail.toString().length > 5 && myPassword.toString().length > 4) {
        setState(() {
          _email = myEmail;
          _password = myPassword;
          _userInfoFound = true;
          debugPrint('minimum requirement fullfilled');
        });
      } else {
        debugPrint('minimum requirement not fullfilled');
      }
    } catch (e) {
      debugPrint("Hive Error");
      debugPrint(e.toString());
    }
  }
}
