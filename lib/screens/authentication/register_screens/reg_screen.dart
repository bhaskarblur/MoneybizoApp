import 'dart:io';

import 'package:flutter/material.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/screens/authentication/register_screens/identification_scree.dart';
import 'package:money_bizo/widget/navigator.dart';
import 'package:money_bizo/widget/sahared_prefs.dart';

import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key});

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final ApiServices _apiServices = ApiServices();

  // final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool visibility = false;
  bool newPassVisibility = false;
  bool conPassVisibility = false;

  final TextEditingController one = TextEditingController();
  final TextEditingController two = TextEditingController();
  final TextEditingController three = TextEditingController();
  final TextEditingController four = TextEditingController();
  final TextEditingController five = TextEditingController();
  final TextEditingController six = TextEditingController();

  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            statusBar(context),
            SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Image.asset('assets/icons/banner_icon.png')),
            gap(30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                      color: bannerColor,
                      border: Border.all(color: borderColor),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("Let's ",
                                    style: TextStyle(
                                        color: primaryTextColor,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold)),
                                const Text("Get Started",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            gap(5),
                            Text('Please Use the form below to Sign Up.',
                                style: TextStyle(
                                    color: primaryTextColor,
                                    fontWeight: FontWeight.w400)),
                            gap(25),
                            // customTextField(_username, 'Username'),
                            // gap(25),
                            customTextField(_email, 'Email'),
                            gap(25),
                            customTextField(_phone, 'Phone',
                                keyboard: TextInputType.phone),
                            gap(40),
                            fullWidthButton(
                                buttonName: 'Sign Up',
                                onTap: () {
                                  Prefs.getDeviceToken().then((value) {
                                    _apiServices.post(
                                        context: context,
                                        endpoint: 'register.php',
                                        body: {
                                          "phone": _phone.text,
                                          "submit_phone": "Let's go",
                                          "mode": "mobile",
                                          "type": "user",
                                          "device_token": value,
                                          "device_type": Platform.isIOS
                                              ? "IOS"
                                              : "Android",
                                        }).then((value) {
                                      if (value['status'] == 200) {
                                        if (value['user_data'] != null) {
                                          dialog(context, 'User Already Exists',
                                              () {
                                            Nav.pop(context);
                                          });
                                        } else {
                                          emailPhoneSheet();
                                        }
                                      } else {
                                        dialog(context,
                                            value['error'] ?? value['message'],
                                            () {
                                          Nav.pop(context);
                                        });
                                      }
                                    });
                                  });
                                }),
                            gap(40),
                            // Center(
                            //   child: SizedBox(
                            //       width:
                            //           MediaQuery.of(context).size.width / 1.5,
                            //       child: Stack(
                            //         children: [
                            //           SvgPicture.asset(
                            //               'assets/icons/social_icons.svg'),
                            //           Row(children: [
                            //             Expanded(
                            //                 child: InkWell(
                            //                     onTap: () {
                            //                       print('1');
                            //                     },
                            //                     child: const SizedBox(
                            //                         height: 70))),
                            //             Expanded(
                            //                 child: InkWell(
                            //                     onTap: () {
                            //                       print('2');
                            //                     },
                            //                     child: const SizedBox(
                            //                         height: 70))),
                            //             Expanded(
                            //                 child: InkWell(
                            //                     onTap: () {
                            //                       print('3');
                            //                     },
                            //                     child: const SizedBox(
                            //                         height: 70))),
                            //           ]),
                            //         ],
                            //       )),
                            // ),
                            // gap(10),
                            // Center(
                            //   child: InkWell(
                            //     onTap: () {
                            //       Nav.push(context, const TabScreen());
                            //     },
                            //     child: const Text('Skip for now',
                            //         style: TextStyle(
                            //             fontWeight: FontWeight.w700,
                            //             decoration: TextDecoration.underline)),
                            //   ),
                            // ),
                            gap(20),
                            Center(
                                child: Text('Already Member? ',
                                    style: TextStyle(
                                        color: primaryTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18))),
                            gap(20),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  Nav.pop(context);
                                },
                                child: const Text('Login',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  emailPhoneSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        barrierColor: Colors.black87,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(children: [
                        Row(
                          children: [
                            Text("Enter ",
                                style: TextStyle(
                                    color: primaryTextColor,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold)),
                            const Text("OTP",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        gap(10),
                        Text(
                            "Please enter your 6 digit code which was sent on your phone below",
                            style: TextStyle(
                                color: primaryTextColor, fontSize: 16)),
                        Text(_phone.text,
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 16)),
                        gap(60),
                        Row(children: [
                          Expanded(
                              child: TextField(
                            controller: one,
                            cursorColor: Colors.grey,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: primaryTextColor),
                            keyboardType: TextInputType.number,
                            decoration: inputDecoration(),
                            autofocus: true,
                            onChanged: (value) {
                              FocusScope.of(context).requestFocus(focus);
                            },
                          )),
                          horGap(20),
                          Expanded(
                              child: TextField(
                            controller: two,
                            cursorColor: Colors.grey,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: primaryTextColor),
                            keyboardType: TextInputType.number,
                            decoration: inputDecoration(),
                            autofocus: true,
                            focusNode: focus,
                            onChanged: (value) {
                              FocusScope.of(context).requestFocus(focus1);
                            },
                          )),
                          horGap(20),
                          Expanded(
                              child: TextField(
                            controller: three,
                            cursorColor: Colors.grey,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: primaryTextColor),
                            keyboardType: TextInputType.number,
                            decoration: inputDecoration(),
                            autofocus: true,
                            focusNode: focus1,
                            onChanged: (value) {
                              FocusScope.of(context).requestFocus(focus2);
                            },
                          )),
                          horGap(20),
                          Expanded(
                              child: TextField(
                            controller: four,
                            cursorColor: Colors.grey,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: primaryTextColor),
                            keyboardType: TextInputType.number,
                            decoration: inputDecoration(),
                            autofocus: true,
                            focusNode: focus2,
                            onChanged: (value) {
                              FocusScope.of(context).requestFocus(focus3);
                            },
                          )),
                          horGap(20),
                          Expanded(
                              child: TextField(
                            controller: five,
                            cursorColor: Colors.grey,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: primaryTextColor),
                            keyboardType: TextInputType.number,
                            decoration: inputDecoration(),
                            autofocus: true,
                            focusNode: focus3,
                            onChanged: (value) {
                              FocusScope.of(context).requestFocus(focus4);
                            },
                          )),
                          horGap(20),
                          Expanded(
                              child: TextField(
                            controller: six,
                            cursorColor: Colors.grey,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: primaryTextColor),
                            keyboardType: TextInputType.number,
                            decoration: inputDecoration(),
                            autofocus: true,
                            focusNode: focus4,
                            onChanged: (value) {
                              FocusScope.of(context).unfocus();
                            },
                          )),
                        ]),
                        gap(40),
                        fullWidthButton(
                            buttonName: 'Submit',
                            onTap: () {
                              String otp = one.text +
                                  two.text +
                                  three.text +
                                  four.text +
                                  five.text +
                                  six.text;
                              _apiServices.post(
                                  context: context,
                                  endpoint: 'register.php',
                                  body: {
                                    "phone": _phone.text,
                                    "submit_otp": "Submit",
                                    "mode": "mobile",
                                    "otp": otp,
                                    "type": "user",
                                  }).then((value) {
                                if (value['status'] == 200) {
                                  Prefs.setPrefs('loginId',
                                      value['fem_user_login_id'].toString());
                                  Nav.pop(context);
                                  createPasswordBottomSheet(context);
                                  _apiServices.post(
                                      context: context,
                                      endpoint: 'updateEmail.php',
                                      body: {
                                        "email": _email.text,
                                        "fem_user_login_id":
                                            value['fem_user_login_id']
                                                .toString(),
                                        "mode": "mobile"
                                      },
                                      progressBar: false);
                                } else {
                                  dialog(context,
                                      value['error'] ?? value['message'], () {
                                    Nav.pop(context);
                                  });
                                }
                              });
                            }),
                        gap(30),
                        const Text("Don't Have An Account?",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        gap(10),
                        InkWell(
                          onTap: () {
                            Nav.pop(context);
                            Nav.push(context, const RegScreen());
                          },
                          child: const Text("Sign Up",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ]))));
        }).whenComplete(() {
      one.clear();
      two.clear();
      three.clear();
      four.clear();
      five.clear();
      six.clear();
    });
  }

  createPasswordBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        barrierColor: Colors.black87,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Create Password",
                              style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold)),
                          const Text("to complete registration",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold)),
                          const Text(
                              "Enter your password to access the app next time."),
                          gap(10),
                          gap(25),
                          passTextField(
                              _newPassword, 'New Password', newPassVisibility,
                              () {
                            state(() {
                              newPassVisibility = !newPassVisibility;
                            });
                          }),
                          gap(25),
                          passTextField(_confirmPassword, 'Confirm Password',
                              conPassVisibility, () {
                            state(() {
                              conPassVisibility = !conPassVisibility;
                            });
                          }),
                          gap(30),
                          fullWidthButton(
                              buttonName: 'Submit',
                              onTap: () {
                                String otp = one.text +
                                    two.text +
                                    three.text +
                                    four.text +
                                    five.text;
                                Prefs.getPrefs('loginId').then((loginId) {
                                  _apiServices.post(
                                      context: context,
                                      endpoint: 'password.php',
                                      body: {
                                        "password": _newPassword.text,
                                        "fem_user_login_id": loginId,
                                        "mode": "mobile",
                                        "otp": otp,
                                        "type": "user",
                                      }).then((value) {
                                    if (value['status'] == 200) {
                                      Nav.push(context,
                                          const IdentificationScreen());
                                    } else {
                                      dialog(context,
                                          value['error'] ?? value['message'],
                                          () {
                                        Nav.pop(context);
                                      });
                                    }
                                  });
                                });
                              }),
                        ],
                      ),
                    )));
          });
        });
  }

  InputDecoration inputDecoration() {
    return const InputDecoration(
      border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      disabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    );
  }
}
