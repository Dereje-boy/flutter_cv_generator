// ignore_for_file: use_build_context_synchronously

//http
import 'package:http/http.dart' as http;
import 'package:client_cookie/src/client_cookie_base.dart';
import 'package:flutter/material.dart';

//sign up page, when 'sign up' button clicked
import 'package:flutter_cv/welcome_page/sign_up_page.dart';
import 'package:jaguar_resty/jaguar_resty.dart';

//home page with bottom nav bars, while logging in success
import '../home_page/home.dart';

//hive
import 'package:hive/hive.dart';

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
                  if (mounted) {
                    setState(() {
                      emailAddress = newEmail;
                    });
                  }
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
                  if (mounted) {
                    setState(() {
                      password = newPassword;
                    });
                  }
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
                if (mounted) {
                  setState(() {
                    _loginUpButtonTapDown = true;
                  });
                }
              },
              onTapUp: (details) {
                if (mounted) {
                  setState(() {
                    _loginUpButtonTapDown = false;
                  });
                }
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
                if (mounted) {
                  setState(() {
                    _forgotButtonTapDown = true;
                  });
                }
              },
              onTapUp: (detail) {
                if (mounted) {
                  setState(() {
                    _forgotButtonTapDown = false;
                  });
                }
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
                if (mounted) {
                  setState(() {
                    _signUpButtonTapDown = true;
                  });
                }
              },
              onTapUp: (detail) {
                if (mounted) {
                  setState(() {
                    _signUpButtonTapDown = false;
                  });
                }
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
      if (mounted) {
        setState(() {
          _errorFound = true;
          _errorMessage = "Email shouldn't be less than six characters";
        });
      }
      return;
    }

    if (!emailAddress.contains("@")) {
      if (mounted) {
        setState(() {
          _errorFound = true;
          _errorMessage = "Email should contain @ symbol";
        });
      }
      return;
    }

    if (!emailAddress.contains(".")) {
      if (mounted) {
        setState(() {
          _errorFound = true;
          _errorMessage = "Email should contain . (dot) symbol";
        });
      }
      return;
    }

    if (password.length < 5) {
      if (mounted) {
        setState(() {
          _errorFound = true;
          _errorMessage = "Password shouldn't be less than five characters.";
        });
      }
      return;
    }

    // no more error,
    if (mounted) {
      setState(() {
        _errorFound = true;
        _errorMessage = "Sending to backend...";

        //for loading animation...
        _stillSendingToBackend = true;
      });
    }

    final client = http.Client();

    const baseUrl = 'localhost:3000';

    final fullData = {
      'email': emailAddress,
      'password': password,
    };

    try {
      final loginResponse =
          await client.post(Uri.http(baseUrl, 'login'), body: fullData);
      // Handle response
      debugPrint('Response: ${loginResponse.body}');

      /*
      what we get as a response

      response = {
          success, //which is true if success and false otherwise
          user, //the user's email we are passing to the server
          error //the reason for the failure
      }

      */

      Map<String, dynamic> jsonResponse =
          jsonDecode(loginResponse.body.toString());
      debugPrint('jsonResponse: $jsonResponse');
      // debugPrint(jsonResponse['message']);

      if (mounted) {
        setState(() {
          _stillSendingToBackend = false;
        });
      }

      //if success true = you are logged in
      if (jsonResponse['success'] == true) {
        if (mounted) {
          setState(() {
            _errorFound = true;
            _errorMessage = 'Successfully logged in... Now redirecting';
          });
        }

        String actualToken = '';

        ClientCookie? tokenClientCookie = loginResponse.cookies['token'];
        if (tokenClientCookie != null) {
          actualToken = tokenClientCookie.value;
          debugPrint("tokenClientCookie = $actualToken");
        }

        try {
          final myBox = await Hive.openBox("myBox");
          await myBox.put('email', emailAddress);
          await myBox.put('password', password);
          await myBox.put('token', actualToken);

          //not started working
          // await getPi();

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
        if (mounted) {
          setState(() {
            _errorFound = true;
            _errorMessage = jsonResponse['error'];
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _errorFound = true;
            _errorMessage = 'Please check your internet connection';
          });
        }
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

  //not working
  getPi() async {
    // final Dio _dio = Dio();

    // const url = 'http://localhost:3000/login';
  }
}
