import 'package:flutter/material.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/screens/authentication/register_screens/cart_login_screens/add_email_screen.dart';

import '../../../../app_config/colors.dart';
import '../../../../widget/navigator.dart';
import '../../../../widget/sahared_prefs.dart';
import '../../../../widget/widgets.dart';

class CreatePassword extends StatefulWidget {
  final String otp;
  const CreatePassword({super.key, required this.otp});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool newPassVisibility = false;
  bool conPassVisibility = false;

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
                  const Text('Create Password',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  gap(10),
                  const Text('Enter your password to access the app next time.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey)),
                  gap(30),
                  passTextField(_newPassword, 'New Password', newPassVisibility,
                      () {
                    setState(() {
                      newPassVisibility = !newPassVisibility;
                    });
                  }),
                  gap(25),
                  passTextField(
                      _confirmPassword, 'Confirm Password', conPassVisibility,
                      () {
                    setState(() {
                      conPassVisibility = !conPassVisibility;
                    });
                  }),
                  gap(30),
                  fullWidthButton(
                      buttonName: 'Submit',
                      onTap: () {
                        // Nav.push(context, const AddEmailScreen());

                        Prefs.getPrefs('loginId').then((loginId) {
                          _apiServices.post(
                              context: context,
                              endpoint: 'password.php',
                              body: {
                                "password": _newPassword.text,
                                "fem_user_login_id": loginId,
                                "mode": "mobile",
                                "otp": widget.otp,
                                "type": "user",
                              }).then((value) {
                            if (value['status'] == 200) {
                              Nav.push(context, const AddEmailScreen());
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
                ]))));
  }
}
