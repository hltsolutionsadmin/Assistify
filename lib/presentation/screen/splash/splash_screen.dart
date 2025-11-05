import 'package:assistify/core/constants/colors.dart';
import 'package:assistify/core/constants/imgs_const.dart';
import 'package:assistify/presentation/screen/homescreen/home_screen.dart';
import 'package:assistify/presentation/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _checkSession(context);
  }

  Future<void> _checkSession(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('TOKEN') ?? '';
    print('token:$token');
    if (!mounted) return;
    if(token.isEmpty){
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => HomeScreen(
               
                ),
          ),
        );
      }
    }
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColor.white, AppColor.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      Logo,
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
