import 'package:flutter/material.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/screens/authentication/register_screens/payement_schedule.dart';
import 'package:money_bizo/widget/navigator.dart';
import 'package:money_bizo/widget/sahared_prefs.dart';

import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

class SetupPinScreen extends StatefulWidget {
  final String? pageName;
  const SetupPinScreen({super.key, this.pageName});

  @override
  State<SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends State<SetupPinScreen> {
  final ApiServices _apiServices = ApiServices();

  List<String> pin = [];

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
                        child: Image.asset('assets/icons/banner_icon.png')),
                  ),
                  gap(20),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Nav.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 30,
                          )),
                      const Text(
                        'Setup Pin',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  gap(50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      numberTile(0),
                      horGap(10),
                      numberTile(1),
                      horGap(10),
                      numberTile(2),
                      horGap(10),
                      numberTile(3),
                    ],
                  ),
                  gap(50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: GridView.builder(
                        itemCount: 12,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 7,
                                crossAxisSpacing: 7,
                                childAspectRatio: 1.8),
                        itemBuilder: (context, index) {
                          return index == 11
                              ? InkWell(
                                  onTap: () {
                                    pin.clear();
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black),
                                    child: const Icon(Icons.backspace_outlined,
                                        color: Colors.white, size: 30),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    if (pin.length < 4) {
                                      if (index == 10) {
                                        pin.add('0');
                                      } else if (index == 9) {
                                        pin.add('.');
                                      } else {
                                        pin.add((index + 1).toString());
                                      }
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey.shade100),
                                      child: Center(
                                          child: Text(
                                              index == 10
                                                  ? '0'
                                                  : index == 9
                                                      ? '.'
                                                      : (index + 1).toString(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.bold)))),
                                );
                        }),
                  ),
                  gap(40),
                  Center(
                      child: fullWidthButton(
                          buttonName: 'Submit',
                          onTap: () {
                            if (widget.pageName == 'settings') {
                              dialog(context, 'Pin changes successfully', () {
                                Nav.pop(context);
                              });
                            } else {
                              Prefs.getPrefs('token').then((token) {
                                Prefs.getPrefs('loginId').then((loginId) {
                                  _apiServices.post(
                                      context: context,
                                      endpoint: 'index/setPin.php',
                                      body: {
                                        "fem_user_login_id": loginId,
                                        "type": "user",
                                        "mode": "mobile",
                                        "access_token": token,
                                        "submit": "submit",
                                        "pin":
                                            pin[0] + pin[1] + pin[2] + pin[3],
                                      }).then((value) {
                                    if (value['return'] == 'success') {
                                      Nav.push(context,
                                          const PaymentSchedule(pageName: ''));
                                    } else {
                                      dialog(context,
                                          value['message'] ?? value['error'],
                                          () {
                                        Nav.pop(context);
                                      });
                                    }
                                  });
                                });
                              });
                            }
                          },
                          width: 150))
                ]))));
  }

  Widget numberTile(int index) {
    return Container(
        height: 50,
        width: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.black26),
        child: Center(
            child: Text(pin.length > (index) ? pin[index] : '',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20))));
  }
}
