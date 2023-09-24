import 'package:money_bizo/app_config/colors.dart';
import 'package:money_bizo/widget/widgets.dart';
import 'package:flutter/material.dart';

import '../../../widget/navigator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          statusBar(context),
          Center(
              child: SizedBox(
                  width: 100,
                  child: Image.asset('assets/icons/banner_icon.png'))),
          gap(10),
          Row(children: [
            InkWell(
                onTap: () {
                  Nav.pop(context);
                },
                child: const Icon(Icons.arrow_back)),
            horGap(10),
            Text('Forgot Password?',
                style: TextStyle(fontSize: 18, color: primaryTextColor)),
          ]),
          gap(20),
          gap(10),
          Text('Don’t worry, we can help you recover it.',
              style: TextStyle(fontSize: 12, color: primaryTextColor)),
          gap(30),
          TextFormField(
            controller: _email,
            decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: const Icon(Icons.email),
                filled: true,
                fillColor: Colors.grey.shade300,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10))),
            onTap: () {},
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter an email';
              } else {
                return null;
              }
            },
          ),
          gap(30),
          fullWidthButton(buttonName: 'Send Recovery Link', onTap: () {})
        ]),
      ),
    );
  }
}
