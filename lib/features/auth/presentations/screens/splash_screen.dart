// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sportifind/features/auth/presentations/bloc/auth_bloc.dart';
import 'package:sportifind/features/auth/presentations/screens/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

  @override  
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 5), () async{
      final isSignedIn = await AuthBloc(context).checkStoredCredentials();
      if (isSignedIn) {
        return;
      }
      Navigator.of(context).pushReplacement(SignInScreen.route());
    });
  }

  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override  
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration (
          color: Colors.white
        ),
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            FadeTransition(
              opacity: _animation,
              child: const Image(
                image: AssetImage('lib/assets/logo/logo_black_text.png'),
                height: 250,
              )
            )
          ]
        )
      )
    );
  }
}