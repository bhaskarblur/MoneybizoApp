import 'package:money_bizo/app_config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../widget/navigator.dart';
import '../tab_screens/tab_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Nav.pushAndRemoveAll(context, const TabScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(children: [
            Positioned(
                top: 100,
                right: 0,
                child:
                    SvgPicture.asset('assets/images/splash/decoration1.svg')),
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Image.asset(
                    'assets/images/splash/icon.png',
                  ),
                )),
            Positioned(
                bottom: 100,
                left: 0,
                child:
                    SvgPicture.asset('assets/images/splash/decoration2.svg')),
          ]),
        ));
  }
}
