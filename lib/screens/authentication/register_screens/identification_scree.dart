import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:money_bizo/app_config/colors.dart';
import 'package:money_bizo/screens/authentication/register_screens/license_passport_details.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';

class IdentificationScreen extends StatefulWidget {
  const IdentificationScreen({super.key});

  @override
  State<IdentificationScreen> createState() => _IdentificationScreenState();
}

class _IdentificationScreenState extends State<IdentificationScreen> {
  bool checkbox = false;
  bool driverLicense = false;
  bool passport = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          statusBar(context),
          Center(
            child: SizedBox(
                width: 100, child: Image.asset('assets/icons/banner_icon.png')),
          ),
          gap(20),
          const Text(
            'Choose Your Prefered Identification',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          gap(10),
          const Text(
              'To open an account we need some details of your New Zeland ID. Please choose one form of ID listed below.'),
          gap(20),
          Row(children: [
            Checkbox(
                activeColor: primaryColor,
                value: checkbox,
                onChanged: (value) {
                  setState(() {
                    checkbox = value!;
                  });
                }),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                    "I agree and accept moneybizo's Privacy Policy and Terms and Conditions."),
              ),
            )
          ]),
          gap(20),
          InkWell(
            onTap: () {
              setState(() {
                driverLicense = true;
                passport = false;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: driverLicense ? primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [BoxShadow(color: Colors.grey.shade400)]),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(children: [
                  SvgPicture.asset('assets/icons/driver_license.svg'),
                  horGap(20),
                  Text('New Zealand Driver License',
                      style: TextStyle(
                          fontSize: 16,
                          color: driverLicense ? Colors.white : Colors.black))
                ]),
              ),
            ),
          ),
          gap(20),
          InkWell(
            onTap: () {
              setState(() {
                driverLicense = false;
                passport = true;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: passport ? primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [BoxShadow(color: Colors.grey.shade400)]),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(children: [
                  SvgPicture.asset('assets/icons/passport.svg'),
                  horGap(20),
                  Text('New Zealand Passport',
                      style: TextStyle(
                          fontSize: 16,
                          color: passport ? Colors.white : Colors.black))
                ]),
              ),
            ),
          ),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: fullWidthButton(
            buttonName: 'Next',
            onTap: () {
              if (driverLicense == false && passport == false) {
                dialog(context, 'Please Select License Or Passport.', () {
                  Nav.pop(context);
                });
              } else {
                if (checkbox) {
                  Nav.push(
                      context,
                      LicensePassportScreen(
                          documentType: passport ? 'passport' : 'license'));
                } else {
                  dialog(context, 'Agree terms and conditions.', () {
                    Nav.pop(context);
                  });
                }
              }
            }),
      ),
    );
  }
}
