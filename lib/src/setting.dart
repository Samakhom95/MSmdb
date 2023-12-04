import 'package:flutter/material.dart';
import 'package:movie_silver/webApp/terms.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          InkWell(
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                  width: 30.0,
                  height: 60.0,
                ),
                Text(
                  '- See More',
                  style: TextStyle(),
                ),
              ]),
              onTap: () => {
                    launchUrlString(
                        'https://rateraters.github.io/index.html')
                  }),
          InkWell(
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                  width: 30.0,
                  height: 60.0,
                ),
                Text(
                  '- Terms and Conditions',
                  style: TextStyle(),
                ),
              ]),
              onTap: () => {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: const TermsSrc()))
                  }),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Developed with love ❤️ by:',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () => launchUrlString(
                    'https://www.instagram.com/phil_nattawoot/'),
                child: const Text('@phil_nattawoot',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                        fontSize: 12)),
              ),
            ],
          ),
           Center(
            child: Padding(
              padding: const EdgeInsets.only(top:15),
              child: GestureDetector(
                onTap: () =>launchUrlString(
                    'https://rateraters.github.io/'),
                child: const Text(
                      'version: 0.1.7+8',
                      style: TextStyle(fontSize: 12,color: Colors.grey),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}