import 'package:flutter/material.dart';
import 'package:flutter_cv/welcome_page/welcome_page.dart';

class CV_Page extends StatelessWidget {
  const CV_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Image(
              image: AssetImage('images/cv_generator_log.png'),
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "👍 Click The Button Below 👍 \n⬇️ To Download Your CV ⬇️ \n📄 In PDF Format 📄",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint('Downloading the cv');
                SnackBar(
                  content: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child:
                        Text("Please wait until the pdf is being downloaded"),
                  ),
                  action: SnackBarAction(
                    label: "Cancel",
                    onPressed: () {
                      debugPrint("Cancelling the download");
                    },
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Download CV",
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
