import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/app_config/colors.dart';
import 'package:money_bizo/screens/authentication/register_screens/reg_screen.dart';
import 'package:money_bizo/screens/tab_screens/tab_screen.dart';
import 'package:money_bizo/widget/navigator.dart';
import 'package:money_bizo/widget/widgets.dart';
import 'package:flutter/material.dart';

import '../../widget/sahared_prefs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiServices _apiServices = ApiServices();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final TextEditingController _forgotEmail = TextEditingController();
  final TextEditingController _forgotPhone = TextEditingController();

  final TextEditingController one = TextEditingController();
  final TextEditingController two = TextEditingController();
  final TextEditingController three = TextEditingController();
  final TextEditingController four = TextEditingController();

  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();

  bool visibility = false;
  bool newPassVisibility = false;
  bool conPassVisibility = false;

  bool emailOrPhone = true;

  bool otpSent = false;

  bool keepLoggedIn = false;

  bool createPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          statusBar(context),
          SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Image.asset('assets/icons/banner_icon.png')),
          gap(10),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Login',
                              style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold)),
                          gap(5),
                          Text('Please Use the form below to login.',
                              style: TextStyle(
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.w400)),
                          gap(25),
                          Form(
                            key: _key,
                            child: Column(children: [
                              customTextField(_email, 'Email'),
                              gap(25),
                              passTextField(
                                _password,
                                'Password',
                                visibility,
                                () {
                                  setState(() {
                                    visibility = !visibility;
                                  });
                                },
                              ),
                            ]),
                          ),
                          gap(10),
                          Row(children: [
                            Checkbox(
                                value: keepLoggedIn,
                                onChanged: (value) {
                                  setState(() {
                                    keepLoggedIn = value!;
                                  });
                                }),
                            const Text(
                              'Keep me logged in.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ]),
                          gap(30),
                          fullWidthButton(
                              buttonName: 'Login',
                              onTap: () {
                                print('............');
                                _apiServices.post(
                                    context: context,
                                    endpoint: 'indexLogin.php',
                                    body: {
                                      "username": _email.text,
                                      "password": _password.text,
                                      "mode": "mobile"
                                    }).then((value) {
                                  print(2);
                                  if (value['return'] == 'success') {
                                    if (value['company_all_details'] != null) {
                                      Prefs.setPrefs(
                                          'loginId',
                                          value['company_all_details']
                                              ['fem_company_login_id']);
                                      Prefs.setBool('company', true);
                                    } else {
                                      Prefs.setPrefs(
                                          'loginId',
                                          value['user_all_details']
                                              ['fem_user_login_id']);
                                      Prefs.setBool('company', false);
                                    }
                                    // if (keepLoggedIn) {
                                    Prefs.setPrefs(
                                        'token', value['access_token']);

                                    // }
                                    Nav.pushAndRemoveAll(
                                        context, const TabScreen());
                                  } else {
                                    dialog(context, value['message'], () {
                                      Nav.pop(context);
                                    });
                                  }
                                });
                              }),
                          gap(30),
                          Center(
                            child: InkWell(
                              onTap: () {
                                passResetSheet(context);
                              },
                              child: const Text('Forgot Password? ',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                          ),
                          // gap(30),
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
                          gap(30),
                          Center(
                            child: Text('Don\'t Have An Account? ',
                                style: TextStyle(
                                    color: primaryTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ),
                          gap(20),
                          Center(
                            child: InkWell(
                              onTap: () {
                                Nav.push(context, const RegScreen());
                              },
                              child: const Text('Sign Up',
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
    );
  }

  passResetSheet(BuildContext context) {
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
                  child: Column(children: [
                    SizedBox(
                        height: 30,
                        child: Image.asset('assets/icons/banner_icon.png')),
                    gap(10),
                    Column(children: [
                      Row(
                        children: [
                          Text("Forgot ",
                              style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold)),
                          const Text("Password",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      gap(10),
                      RichText(
                          text: TextSpan(
                        children: [
                          TextSpan(
                              text:
                                  "Enter your email for new password, We’ll send you the ",
                              style: TextStyle(
                                  color: primaryTextColor, fontSize: 16)),
                          const TextSpan(
                              text: "One-Time Password,",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16)),
                        ],
                      )),
                      gap(60),
                      if (emailOrPhone)
                        Form(child: customTextField(_forgotEmail, 'Email')),
                      if (!emailOrPhone)
                        customTextField(_forgotPhone, 'Phone',
                            keyboard: TextInputType.phone),
                      gap(40),
                      fullWidthButton(
                          buttonName: 'Send',
                          onTap: () {
                            _apiServices.post(
                                context: context,
                                endpoint: 'indexForgot.php',
                                body: {
                                  "myemail": emailOrPhone
                                      ? _forgotEmail.text
                                      : _forgotPhone.text,
                                  "submit": "I want my password!",
                                  "mode": "mobile"
                                }).then((value) {
                              if (value['status'] == 200) {
                                dialog(context,
                                    'password has been sent to your gmail.',
                                    () {
                                  Nav.pop(context);
                                  Nav.pop(context);
                                });
                              }
                            });
                          }),
                      gap(30),
                    ]),
                  ]),
                ),
              ),
            );
          });
        });
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
                            Text("Forgot ",
                                style: TextStyle(
                                    color: primaryTextColor,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold)),
                            const Text("Password",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        gap(10),
                        Text(
                            "Please enter your 4 digit code which was sent on your email below ",
                            style: TextStyle(
                                color: primaryTextColor, fontSize: 16)),
                        Text(_email.text,
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
                            decoration: inputDecoration(),
                            autofocus: true,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                FocusScope.of(context).requestFocus(focus);
                              }
                            },
                          )),
                          horGap(50),
                          Expanded(
                              child: TextField(
                            controller: two,
                            cursorColor: Colors.grey,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: primaryTextColor),
                            decoration: inputDecoration(),
                            autofocus: true,
                            focusNode: focus,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                FocusScope.of(context).requestFocus(focus1);
                              }
                            },
                          )),
                          horGap(50),
                          Expanded(
                              child: TextField(
                            controller: three,
                            cursorColor: Colors.grey,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: primaryTextColor),
                            decoration: inputDecoration(),
                            autofocus: true,
                            focusNode: focus1,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                FocusScope.of(context).requestFocus(focus2);
                              }
                            },
                          )),
                          horGap(50),
                          Expanded(
                              child: TextField(
                            controller: four,
                            cursorColor: Colors.grey,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: primaryTextColor),
                            decoration: inputDecoration(),
                            autofocus: true,
                            focusNode: focus2,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                FocusScope.of(context).unfocus();
                              }
                            },
                          )),
                        ]),
                        gap(40),
                        fullWidthButton(
                            buttonName: 'Submit',
                            onTap: () {
                              Nav.pop(context);
                              dialog(context, 'Code verification Successful',
                                  () {
                                Nav.pop(context);
                              });
                              createPasswordBottomSheet(context);
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
                                dialog(
                                    context, 'Password changed successfully.',
                                    () {
                                  Nav.push(context, const LoginScreen());
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
