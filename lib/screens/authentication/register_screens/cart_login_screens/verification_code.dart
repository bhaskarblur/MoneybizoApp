import 'package:flutter/material.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/screens/authentication/register_screens/cart_login_screens/create_password.dart';
import 'package:money_bizo/widget/navigator.dart';

import '../../../../app_config/colors.dart';
import '../../../../widget/sahared_prefs.dart';
import '../../../../widget/widgets.dart';

class VerificationCode extends StatefulWidget {
  final String phone;
  const VerificationCode({super.key, required this.phone});

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  final ApiServices _apiServices = ApiServices();

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
                  const Text('Enter Verification Code Below',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  gap(10),
                  const Text('We\'ve sent you a code',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey)),
                  gap(60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Row(children: [
                      Expanded(
                          child: TextField(
                        controller: one,
                        cursorColor: Colors.grey,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: primaryTextColor),
                        decoration: inputDecoration(),
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            FocusScope.of(context).requestFocus(focus);
                          }
                        },
                      )),
                      horGap(20),
                      Expanded(
                          child: TextField(
                        controller: two,
                        cursorColor: Colors.grey,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: primaryTextColor),
                        decoration: inputDecoration(),
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        focusNode: focus,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            FocusScope.of(context).requestFocus(focus1);
                          }
                        },
                      )),
                      horGap(20),
                      Expanded(
                          child: TextField(
                        controller: three,
                        cursorColor: Colors.grey,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: primaryTextColor),
                        decoration: inputDecoration(),
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        focusNode: focus1,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            FocusScope.of(context).requestFocus(focus2);
                          }
                        },
                      )),
                      horGap(20),
                      Expanded(
                          child: TextField(
                        controller: four,
                        cursorColor: Colors.grey,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: primaryTextColor),
                        decoration: inputDecoration(),
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        focusNode: focus2,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            FocusScope.of(context).requestFocus(focus3);
                          }
                        },
                      )),
                      horGap(20),
                      Expanded(
                          child: TextField(
                        controller: five,
                        cursorColor: Colors.grey,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: primaryTextColor),
                        decoration: inputDecoration(),
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        focusNode: focus3,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            FocusScope.of(context).requestFocus(focus4);
                          }
                        },
                      )),
                      horGap(20),
                      Expanded(
                          child: TextField(
                        controller: six,
                        cursorColor: Colors.grey,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: primaryTextColor),
                        decoration: inputDecoration(),
                        autofocus: true,
                        focusNode: focus4,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            FocusScope.of(context).unfocus();
                          }
                        },
                      )),
                    ]),
                  ),
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
                              "phone": widget.phone,
                              "submit_otp": "Submit",
                              "mode": "mobile",
                              "otp": otp,
                              "type": "user",
                            }).then((value) {
                          if (value['status'] == 200) {
                            Prefs.setPrefs('loginId',
                                value['fem_user_login_id'].toString());
                            // Nav.pop(context);
                            Nav.push(context, CreatePassword(otp: otp));
                            // createPasswordBottomSheet(context);
                            // _apiServices.post(
                            //     context: context,
                            //     endpoint: 'updateEmail.php',
                            //     body: {
                            //       "email": _email.text,
                            //       "fem_user_login_id":
                            //           value['fem_user_login_id'].toString(),
                            //       "mode": "mobile"
                            //     },
                            //     progressBar: false);
                          } else {
                            dialog(context, value['error'] ?? value['message'],
                                () {
                              Nav.pop(context);
                            });
                          }
                        });
                      }),
                ]))));
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
