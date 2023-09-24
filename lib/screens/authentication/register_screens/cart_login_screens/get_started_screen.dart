import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/screens/authentication/login_screen.dart';
import 'package:money_bizo/widget/navigator.dart';

import '../../../../app_config/colors.dart';
import '../../../../widget/sahared_prefs.dart';
import '../../../../widget/widgets.dart';
import 'verification_code.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final ApiServices _apiServices = ApiServices();
  PhoneNumber? phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  statusBar(context),
                  Center(
                      child: SizedBox(
                          width: 100,
                          child: Image.asset('assets/icons/banner_icon.png'))),
                  gap(10),
                  const Text('Let\'s get you started.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  gap(10),
                  const Text('Enter Mobile Number to join moneybizo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey)),
                  gap(30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InternationalPhoneNumberInput(
                        countries: const ['NZ'],
                        onInputChanged: (value) {
                          phone = value;
                        }),
                  ),
                  gap(30),
                  fullWidthButton(
                      buttonName: 'Let\'s go',
                      onTap: () {
                        Prefs.getDeviceToken().then((value) {
                          _apiServices.post(
                              context: context,
                              endpoint: 'register.php',
                              body: {
                                "phone": phone!.phoneNumber,
                                "submit_phone": "Let's go",
                                "mode": "mobile",
                                "type": "user",
                                "device_token": value,
                                "device_type":
                                    Platform.isIOS ? "IOS" : "Android",
                              }).then((value) {
                            if (value['status'] == 200) {
                              if (value['user_data'] != null) {
                                dialog(context, 'User Already Exists', () {
                                  Nav.pop(context);
                                });
                              } else {
                                Nav.push(
                                    context,
                                    VerificationCode(
                                        phone: phone!.phoneNumber!));
                              }
                            } else {
                              dialog(
                                  context, value['error'] ?? value['message'],
                                  () {
                                Nav.pop(context);
                              });
                            }
                          });
                        });
                      }),
                  gap(10),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Row(children: []),
                        const Text('Already Member?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        gap(10),
                        InkWell(
                          onTap: () {
                            Nav.pushAndRemoveAll(context, const LoginScreen());
                          },
                          child: const Text('Login',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.blue)),
                        ),
                      ]),
                ]))));
  }
}
