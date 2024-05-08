import 'package:flutter/material.dart';

//pages
import '../bottom_navigation_pages/home_page.dart';
import '../bottom_navigation_pages/my_cv_page.dart';

import 'package:flutter_cv/welcome_page/welcome_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _counter = 0;

  //pages widget
  static const homePage = Home_Page();
  static const myCvPage = CV_Page();
  //track the selected bottom bar
  bool firstBottomBarSelected = true;
  int previousSelectedIndex = 0;

  void _navigationBarChanger(value) {
    if (previousSelectedIndex == value) return;
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      firstBottomBarSelected = !firstBottomBarSelected;
      debugPrint("changing bottom bar $value.toString()");
    });
    previousSelectedIndex = value;
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      debugPrint(_counter.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("CV Generator"),
        leading: Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
          child: const Image(
            image: AssetImage('images/cv_generator_log.png'),
            height: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const Scaffold(
                      body: WelcomePage(true),
                    );
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            tooltip: "How to use Me?",
          ),
        ],
      ),
      // body: Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.

      // Column is also a layout widget. It takes a list of children and
      // arranges them vertically. By default, it sizes itself to fit its
      // children horizontally, and tries to be as tall as its parent.
      //
      // Invoke "debug painting" (press "p" in the console, choose the
      // "Toggle Debug Paint" action from the Flutter Inspector in Android
      // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
      // to see the wireframe for each widget.
      //
      // Column has various properties to control how it sizes itself and
      // how it positions its children. Here we use mainAxisAlignment to
      // center the children vertically; the main axis here is the vertical
      // axis because Columns are vertical (the cross axis would be
      // horizontal).

      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       const Text(
      //         'You have pushed the button this many times:',
      //       ),
      //       Text(
      //         '$_counter',
      //         style: Theme.of(context).textTheme.headlineMedium,
      //       ),
      //     ],
      //   ),
      // ),

      body: firstBottomBarSelected
          ? homePage
          : myCvPage, // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person_2), label: "My CV"),
        ],
        onTap: _navigationBarChanger,
        currentIndex: firstBottomBarSelected ? 0 : 1,
      ),
    );
  }
}
