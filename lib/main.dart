import 'package:flutter/material.dart';
import 'package:resnet/routes.dart';
import 'package:resnet/screens/SplashScreen.dart';
import 'package:sizer/sizer.dart';
import 'package:resnet/theme.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return Sizer(builder: (context, orientation, device){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Resnet-Danna',
        theme: CustomTheme().baseTheme,


        initialRoute: SplashScreen.routeName,

        routes: routes,
      );
    });
  }
}
