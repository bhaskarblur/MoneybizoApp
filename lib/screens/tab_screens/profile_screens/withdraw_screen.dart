import 'package:flutter/material.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/widget/navigator.dart';
import 'package:money_bizo/widget/sahared_prefs.dart';

import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final ApiServices _apiServices = ApiServices();

  String amount = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  statusBar(context),
                  gap(10),
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Nav.pop(context);
                          },
                          child: const Icon(Icons.arrow_back, size: 28)),
                      horGap(10),
                      const Text('Withdraw',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold))
                    ],
                  ),
                  gap(30),
                  const Center(
                      child: Text('Enter Amount',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 22))),
                  gap(20),
                  Text('\$$amount',
                      style: const TextStyle(
                          fontSize: 40,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold)),
                  Container(
                      color: Colors.grey.shade300,
                      height: 2,
                      width: MediaQuery.of(context).size.width / 1.5),
                  gap(30),
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
                                      // amount = '0';
                                      if (amount.isNotEmpty) {
                                        amount = amount.substring(
                                            0, amount.length - 1);
                                        if (amount.isEmpty) {
                                          amount = '0';
                                        }
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.black),
                                      child: const Icon(Icons.arrow_back,
                                          color: Colors.white, size: 30),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      if (amount == '0') {
                                        amount = '';
                                      }
                                      if (amount.length < 10) {
                                        if (index == 9) {
                                          amount = '$amount.';
                                        } else if (index == 10) {
                                          amount = '${amount}0';
                                        } else {
                                          amount =
                                              amount + (index + 1).toString();
                                        }
                                      }
                                      setState(() {});
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
                                                        : (index + 1)
                                                            .toString(),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)))),
                                  );
                          })),
                  gap(50),
                  fullWidthButton(
                      buttonName: 'Confirm',
                      onTap: () {
                        if (amount != '0') {
                          Prefs.getToken().then((token) {
                            Prefs.getPrefs('loginId').then((loginId) {
                              _apiServices.post(
                                  context: context,
                                  endpoint: 'ClientPayment_withdraw.php',
                                  body: {
                                    "fem_company_login_id": loginId,
                                    "type": "company",
                                    "mode": "mobile",
                                    "access_token": token,
                                    "submit": "Withdraw",
                                    "amount": amount,
                                  }).then((value) {
                                dialog(context, value['message'], () {
                                  Nav.pop(context);
                                });
                              });
                            });
                          });
                        } else {
                          dialog(context, 'Enter a valid amount.', () {
                            Nav.pop(context);
                          });
                        }
                      },
                      width: 150,
                      height: 40)
                ]))));
  }
}
