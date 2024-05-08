// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';

//sign up page, when 'sign up' button clicked
import 'package:flutter_cv/welcome_page/sign_up_page.dart';

//home page with bottom nav bars, while logging in success
import '../home_page/home.dart';

//hive
import 'package:hive/hive.dart';

//dio
import 'package:dio/dio.dart';

//working with json
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _signUpButtonTapDown = false;
  bool _loginUpButtonTapDown = false;
  bool _forgotButtonTapDown = false;

  bool _errorFound = false;
  String _errorMessage = "  ";

  bool _stillSendingToBackend = false;

  var emailAddress = '';
  var password = '';

  var prefs;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('images/cv_generator_log.png'),
              height: 100,
            ),

            const SizedBox(
              height: 60,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Login",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.blue),
                ),
              ],
            ),

            // const SizedBox(
            //   height: 5,
            // ),
            // const Text(
            //   "Use your Email and Password to login",
            //   textAlign: TextAlign.center,
            // ),

            const SizedBox(
              height: 20,
            ),

            //email field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                onChanged: (newEmail) {
                  setState(() {
                    emailAddress = newEmail;
                  });
                },
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email",
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            //password field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                obscureText: true,
                onChanged: (newPassword) {
                  setState(() {
                    password = newPassword;
                  });
                },
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Password",
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),

            //error message
            Visibility(
              visible: _errorFound,
              child: Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w500),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            //login button
            GestureDetector(
              onTap: onTapLogin,
              onTapDown: (details) {
                setState(() {
                  _loginUpButtonTapDown = true;
                });
              },
              onTapUp: (details) {
                setState(() {
                  _loginUpButtonTapDown = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: _loginUpButtonTapDown ? Colors.white : Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color:
                          _loginUpButtonTapDown ? Colors.blue : Colors.white),
                ),
                child: Center(
                  child: Text(
                    _stillSendingToBackend ? "...." : "Login",
                    style: TextStyle(
                        color:
                            _loginUpButtonTapDown ? Colors.blue : Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //forgot password option
            GestureDetector(
              child: Column(
                children: [
                  Text(
                    "Forgot your password?",
                    style: TextStyle(
                      color: _forgotButtonTapDown ? Colors.black : Colors.blue,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              onTap: () {
                debugPrint('Forgot window');
              },
              onTapDown: (detail) {
                setState(() {
                  _forgotButtonTapDown = true;
                });
              },
              onTapUp: (detail) {
                setState(() {
                  _forgotButtonTapDown = false;
                });
              },
            ),

            const SizedBox(
              height: 20,
            ),

            //sign up option
            GestureDetector(
              child: Column(
                children: [
                  const Text(
                    "New to CV Generator?",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Sign Up now",
                    style: TextStyle(
                        color:
                            _signUpButtonTapDown ? Colors.black : Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2),
                  ),
                ],
              ),
              onTap: () {
                debugPrint('Show signUP Dialog');
                Navigator.pushReplacement(
                  context,
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
                          body: const SignUpPage());
                    },
                  ),
                );
              },
              onTapDown: (detail) {
                setState(() {
                  _signUpButtonTapDown = true;
                });
              },
              onTapUp: (detail) {
                setState(() {
                  _signUpButtonTapDown = false;
                });
              },
            )
          ],
        ),
      ),
    );
  }

  void onTapLogin() async {
    debugPrint("Email :$emailAddress \nPassword: $password");

    //checking all fields here....
    if (emailAddress.length < 6) {
      setState(() {
        _errorFound = true;
        _errorMessage = "Email shouldn't be less than six characters";
      });
      return;
    }

    if (!emailAddress.contains("@")) {
      setState(() {
        _errorFound = true;
        _errorMessage = "Email should contain @ symbol";
      });
      return;
    }

    if (!emailAddress.contains(".")) {
      setState(() {
        _errorFound = true;
        _errorMessage = "Email should contain . (dot) symbol";
      });
      return;
    }

    if (password.length < 5) {
      setState(() {
        _errorFound = true;
        _errorMessage = "Password shouldn't be less than five characters.";
      });
      return;
    }

    // no more error,
    setState(() {
      _errorFound = true;
      _errorMessage = "Sending to backend...";

      //for loading animation...
      _stillSendingToBackend = true;
    });

    //dio here

    final Dio _dio = Dio();

    const url = 'http://localhost:3000/login';
    // const url = 'http://cv.dere.com.et/login';
    final fullData = {
      'email': emailAddress,
      'password': password,
    };

    try {
      var loginResponse = await _dio.post(url, data: fullData);
      // Handle response
      debugPrint('Response: $loginResponse');

      /*
      what we get as a response

      response = {
          success, //which is true if success and false otherwise
          user, //the user's email we are passing to the server
          error //the reason for the failure
      }

      */

      Map<String, dynamic> jsonResponse = jsonDecode(loginResponse.toString());
      debugPrint('jsonResponse: $jsonResponse');
      // debugPrint(jsonResponse['message']);

      setState(() {
        _stillSendingToBackend = false;
      });

      //if success true = you are logged in
      if (jsonResponse['success'] == true) {
        setState(() {
          _errorFound = true;
          _errorMessage = 'Successfully logged in... Now redirecting';
        });

        const setCookie = 'set-cookie';

        List<String>? cookies = loginResponse.headers[setCookie];
        String actualToken = '';

        //check if it is not null and has a value(not empty)
        if (cookies != null && cookies.isNotEmpty) {
          for (var cookie in cookies) {
            //if it contains token we are fine to extract the cookie named token
            if (cookie.contains('token')) {
              actualToken = cookie.split(';')[0].split('=')[1];
              debugPrint(actualToken);
            }
          }
        }
        try {
          final myBox = await Hive.openBox("myBox");
          await myBox.put('email', emailAddress);
          await myBox.put('password', password);
          await myBox.put('token', actualToken);

          //not started working
          await getPi();

          debugPrint("Hived saved the data successfully");
          // final myEmail = await myBox.get('email');
          // debugPrint("email : $myEmail");
          // await myBox.clear();
        } catch (e) {
          debugPrint("Hive Error");
          debugPrint(e.toString());
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Home();
            },
          ),
        );
      } else if (jsonResponse['success'] == false) {
        setState(() {
          _errorFound = true;
          _errorMessage = jsonResponse['error'];
        });
      } else {
        setState(() {
          _errorFound = true;
          _errorMessage = 'Please check you internet connection';
        });
      }
    } catch (e) {
      // Handle error
      debugPrint('Error: $e');
      setState(() {
        _stillSendingToBackend = false;
        _errorFound = true;
        _errorMessage = 'Please check you internet connection';
      });
    }
  }

  //not working
  getPi() async {
    final Dio _dio = Dio();

    const url = 'http://localhost:3000/login';
  }
}
