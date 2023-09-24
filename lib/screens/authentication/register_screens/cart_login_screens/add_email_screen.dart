import 'package:flutter/material.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/screens/authentication/register_screens/identification_scree.dart';
import 'package:money_bizo/widget/sahared_prefs.dart';

import '../../../../app_config/colors.dart';
import '../../../../widget/navigator.dart';
import '../../../../widget/widgets.dart';

class AddEmailScreen extends StatefulWidget {
  const AddEmailScreen({super.key});

  @override
  State<AddEmailScreen> createState() => _AddEmailScreenState();
}

class _AddEmailScreenState extends State<AddEmailScreen> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController email = TextEditingController();
  bool checked = false;

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
                  const Text('Add Your Email Address',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  gap(30),
                  customTextField(email, 'Email', fillColor: backgroundColor),
                  gap(10),
                  Row(children: [
                    Checkbox(
                        value: checked,
                        onChanged: (value) {
                          setState(() {
                            checked = value!;
                          });
                        }),
                    const Expanded(
                      child: Text(
                        'I would like to receive future communications &  marketing material from moneybizo',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ]),
                  gap(30),
                  fullWidthButton(
                      buttonName: 'Confirm',
                      onTap: () {
                        Prefs.getPrefs('loginId').then((value) {
                          _apiServices
                              .post(
                                  context: context,
                                  endpoint: 'updateEmail.php',
                                  body: {
                                    "email": email.text,
                                    "fem_user_login_id": value,
                                    "mode": "mobile"
                                  },
                                  progressBar: false)
                              .then((value) {
                            Nav.push(context, const IdentificationScreen());
                          });
                        });
                      }),
                ]))));
  }
}
