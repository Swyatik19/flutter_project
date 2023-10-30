import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/core/colors/colors.dart';
import 'package:flutter_project/core/dimensions/dimensions.dart';
import 'package:flutter_project/core/textStyle/textStyle.dart';
import 'package:flutter_project/search/ui/search_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Search App',
            style: splashText,
          ),
          SizedBox(
            height: size10,
          ),
          CupertinoActivityIndicator(
            color: Colors.grey,
          )
        ]),
      ),
    );
  }
}
