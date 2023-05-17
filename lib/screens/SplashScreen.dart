
import 'package:flutter/material.dart';
import 'package:resnet/screens/ResnetScreen.dart';
import 'package:sizer/sizer.dart';


class SplashScreen extends StatefulWidget {
  static String routeName = 'SplashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), (){

      Navigator.pushNamedAndRemoveUntil(context, ResnetScreen.routeName, (route) => false);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Resnet', style: Theme.of(context).textTheme.headline5),
                Text('by Danna', style: Theme.of(context).textTheme.headline5),
              ],
            ),
            Image.asset(
              'assets/images/logouv.png',
              height: 25.h,
              width: 50.w,
            ),
          ],
        ),
      ),
    );
  }
}
