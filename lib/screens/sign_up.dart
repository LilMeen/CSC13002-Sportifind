import 'package:flutter/material.dart';
import 'package:sportifind/widgets/information_box_with_header.dart';
import 'package:sportifind/widgets/green_white_button.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignupState();
  }
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
        body: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'lib/assets/images/logo.png',
                  width: 200,
                  color: const Color.fromARGB(150, 255, 255, 255),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sign up',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 450,
                    width: 400,
                    color: const Color.fromARGB(255, 232, 232, 232),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const InformationBoxWithHeader(
                            headerText: 'Email',
                            boxHeight: 50,
                            boxWidth: 350,
                            infoText: 'email@gmail.com',
                            prefixIcon: Icon(Icons.mail),
                          ),
                          const InformationBoxWithHeader(
                            headerText: 'Password',
                            boxHeight: 50,
                            boxWidth: 350,
                            infoText: 'At least 8 words',
                            prefixIcon: Icon(Icons.mail),
                          ),
                          const InformationBoxWithHeader(
                            headerText: 'Re-enter Password',
                            boxHeight: 50,
                            boxWidth: 350,
                            infoText: 'At least 8 words',
                            prefixIcon: Icon(Icons.mail),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GreenWhiteButton(
                            text: "Create account",
                            onTap: () {},
                            height: 50,
                            width: 300,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                RichText(
                  text: const TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Already has an account?',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: ' Sign in',
                        style: TextStyle(
                          color: Color.fromARGB(255, 7, 203, 148),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
