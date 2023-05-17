import 'package:flutter/cupertino.dart';
import 'package:resnet/screens/ResnetScreen.dart';
import 'package:resnet/screens/SplashScreen.dart';

Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  ResnetScreen.routeName: (context) => ResnetScreen(),
};


