import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sportifind/screens/role_screen.dart';

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

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const RoleScreen(),
        )
      );
    });
  }

  late final _controller = AnimationController(
    duration: const Duration(seconds: 1),
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
          color: Color.fromRGBO(33, 33, 33, 1)
        ),
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            FadeTransition(
              opacity: _animation,
              child: const Image(
                image: AssetImage('lib/assets/logo.png'),
                height: 250,
              )
            )
          ]
        )
      )
    );
  }
}