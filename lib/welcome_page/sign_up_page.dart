// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:client_cookie/src/client_cookie_base.dart';

//hive
import 'package:hive/hive.dart';

import 'package:flutter_cv/bottom_navigation_pages/home_page.dart';
import 'package:jaguar_resty/jaguar_resty.dart';

//home page with bottom nav bars
import '../home_page/home.dart';

//login page
import './login_page.dart';

//convert of json <=  and =>
import 'dart:convert';

//my logic
import './logic_sign_up.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _signUpButtonTapDown = false;
  bool _loginButtonTapDown = false;
  bool _forgotButtonTapDown = false;

  bool _errorFound = true;
  String _errorMessage = "";

  bool _stillSendingToBackend = false;

  var emailAddress = '';
  var password = '';
  var passwordRepeat = '';

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
                  "Sign Up",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.blue),
                ),
              ],
            ),

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
                onChanged: onChangedEmail,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
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

            //password field 1
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                obscureText: true,
                onChanged: onChangedPassword1,
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

            const SizedBox(
              height: 10,
            ),

            //password field 2 or repeat password
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                obscureText: true,
                onChanged: onChangedPassword2,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Repeat Password",
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

            //sign up button
            GestureDetector(
              onTap: onTapSignUpButton,
              onTapDown: (details) {
                setState(() {
                  _signUpButtonTapDown = true;
                });
              },
              onTapUp: (details) {
                setState(() {
                  _signUpButtonTapDown = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: _signUpButtonTapDown ? Colors.white : Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: _signUpButtonTapDown ? Colors.white : Colors.blue),
                ),
                child: Center(
                  child: Text(
                    style: TextStyle(
                        color:
                            _signUpButtonTapDown ? Colors.blue : Colors.white,
                        fontWeight: FontWeight.bold),
                    _stillSendingToBackend ? "...." : "Sign Up",
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            //login option
            GestureDetector(
              child: Column(
                children: [
                  const Text(
                    "Have an existing account?",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Login",
                    style: TextStyle(
                        color: _loginButtonTapDown ? Colors.black : Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2),
                  ),
                ],
              ),
              onTap: () {
                debugPrint('Show login Dialog');
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
                          body: const LoginPage());
                    },
                  ),
                );
              },
              onTapDown: (detail) {
                setState(() {
                  _loginButtonTapDown = true;
                });
              },
              onTapUp: (detail) {
                setState(() {
                  _loginButtonTapDown = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void onChangedPassword1(newPassword1) {
    setState(() {
      password = newPassword1;
    });

    if (newPassword1.length < 5) {
      const message = "Password shouldn't be less than five characters.";
      setState(() {
        _errorFound = true;
        _errorMessage = message;
      });
    } else {
      setState(() {
        _errorFound = false;
        _errorMessage = '';
      });
    }
  }

  void onChangedPassword2(newPassword2) {
    setState(() {
      passwordRepeat = newPassword2;
    });
    if (newPassword2.length < 5) {
      const message = "Password Repeat shouldn't be less than five characters.";
      setState(() {
        _errorFound = true;
        _errorMessage = message;
      });
    } else {
      setState(() {
        _errorFound = false;
        _errorMessage = '';
      });
    }
  }

  void onChangedEmail(newEmail) {
    setState(() {
      emailAddress = newEmail;
    });

    if (newEmail.length < 6) {
      const message = 'Email should be more than five characters';
      debugPrint(message);
      return setState(() {
        _errorFound = true;
        _errorMessage = message;
      });
    }

    if (!newEmail.contains('@')) {
      const message = "Email should contain @ symbol";
      debugPrint(message);
      return setState(() {
        _errorFound = true;
        _errorMessage = message;
      });
    }

    if (!newEmail.contains('.')) {
      const message = 'Email should contain . (dot) symbol';
      debugPrint(message);
      return setState(() {
        _errorFound = true;
        _errorMessage = message;
      });
    }

    debugPrint(" i am valid email address");
    setState(() {
      _errorFound = false;
      _errorMessage = '';
    });
  }

  void onTapSignUpButton() async {
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

    if (passwordRepeat.length < 5) {
      setState(() {
        _errorFound = true;
        _errorMessage =
            "Password Repeat shouldn't be less than five characters.";
      });
      return;
    }

    if (password != passwordRepeat) {
      setState(() {
        _errorFound = true;
        _errorMessage = "Passwords should be similar";
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

    debugPrint(
        "Email :$emailAddress \nPassword: $password \nPasswordRepeat: $passwordRepeat");

    //do another things here...
    debugPrint("Sending data backend.....");
    final client = http.Client();

    const baseUrl = 'localhost:3000';
    // const url = 'http://localhost:3000/signup';

    final fullData = {
      'email': emailAddress,
      'password': password,
      'passwordRepeat': passwordRepeat
    };

    try {
      final signupResponse =
          await client.post(Uri.http(baseUrl, 'signup'), body: fullData);
      // Handle response
      debugPrint('Response: ${signupResponse.body}');

      Map<String, dynamic> jsonResponse = jsonDecode(signupResponse.body);
      //debugPrint('jsonResponse: $jsonResponse[\'message\']');
      debugPrint('message: ' + jsonResponse['message']);

      setState(() {
        _stillSendingToBackend = false;
      });

      //status == false, everything is alright
      if (jsonResponse['status'] != false) {
        setState(() {
          _errorFound = true;
          _errorMessage = jsonResponse['message'];
        });
      } else if (jsonResponse['status'] == false) {
        //if everything is alright and new account created successfully
        // status = false
        setState(() {
          _errorFound = true;
          _errorMessage = 'Successfully Registered';
        });

        String actualToken = '';
        ClientCookie? tokenClientCookie = signupResponse.cookies['token'];
        if (tokenClientCookie != null) {
          actualToken = tokenClientCookie.value;
          debugPrint("tokenClientCookie = $actualToken");
        }

        try {
          final myBox = await Hive.openBox("myBox");
          await myBox.put('email', emailAddress);
          await myBox.put('password', password);
          await myBox.put('token', actualToken);

          debugPrint("Hived saved the data successfully");
          // final myEmail = await myBox.get('email');
          // debugPrint("email : $myEmail");
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
      }
    } catch (e) {
      // Handle error
      debugPrint('Error: $e');
      if (mounted) {
        setState(() {
          _stillSendingToBackend = false;
          _errorFound = true;
          _errorMessage = ' $e Please check your internet connection';
        });
      }
    }
  }
}
