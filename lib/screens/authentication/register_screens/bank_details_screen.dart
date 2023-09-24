import 'package:flutter/material.dart';
import 'package:money_bizo/widget/navigator.dart';
import 'package:provider/provider.dart';

import '../../../api_services.dart';
import '../../../app_config/colors.dart';
import '../../../providers/profile_provider.dart';
import '../../../widget/sahared_prefs.dart';
import '../../../widget/widgets.dart';
import 'download_document_screen.dart';
import 'setup_pin_screen.dart';

class BankDetailsScreen extends StatefulWidget {
  final String? pageName;
  const BankDetailsScreen({super.key, this.pageName});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final TextEditingController bankName = TextEditingController();
  final TextEditingController accountNo = TextEditingController();
  final TextEditingController retypeAccountNo = TextEditingController();
  final TextEditingController bankbranch = TextEditingController();
  final TextEditingController bankaddress = TextEditingController();
  final TextEditingController name = TextEditingController();

  final ApiServices _apiServices = ApiServices();

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    if (widget.pageName == 'settings') {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      Prefs.getBool('company').then((value) {
        Prefs.getPrefs('loginId').then((loginId) {
          Prefs.getToken().then((token) {
            _apiServices
                .post(
                    context: context,
                    endpoint: value! ? 'clientBankEdit.php' : 'indexPDF.php',
                    body: value
                        ? {
                            "fem_company_login_id": loginId,
                            "type": "company",
                            "mode": "mobile",
                            "action": 'getAccountDetails',
                            "access_token": token
                          }
                        : {
                            "fem_user_login_id": loginId,
                            "type": "user",
                            "mode": "mobile",
                            "action": 'getAccountDetails',
                            "access_token": token
                          })
                .then((value) {
              if (value['bank_details'] != null) {
                bankName.text = value['bank_details']['bank_name'];
                accountNo.text = value['bank_details']['bank_account_name'];
                bankbranch.text = value['bank_details']['bank_branch'];
                bankaddress.text = value['bank_details']['bank_address'];
                name.text = value['bank_details']['bank_account_name'];
              }

              setState(() {});

              provider.changeBankDetails(value['bank_details']);
            });
          });
        });
      });
    }
  }

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
                        'Bank Details',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  gap(10),
                  customTextField(bankName, 'Bank Name',
                      fillColor: backgroundColor),
                  gap(10),
                  customTextField(bankbranch, 'Bank Branch',
                      fillColor: backgroundColor),
                  gap(10),
                  customTextField(bankaddress, 'Bank Address',
                      fillColor: backgroundColor),
                  gap(10),
                  customTextField(name, 'Account Holder Name',
                      fillColor: backgroundColor),
                  gap(10),
                  customTextField(accountNo, 'Account Number',
                      fillColor: backgroundColor),
                  gap(10),
                  if (widget.pageName != 'settings')
                    customTextField(retypeAccountNo, 'Retype Account Number',
                        fillColor: backgroundColor),
                  gap(30),
                  Center(
                      child: InkWell(
                    onTap: () {
                      Nav.push(context, const SetupPinScreen());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: primaryColor),
                      child: fullWidthButton(
                          buttonName: 'Save',
                          onTap: () {
                            if (!accountNo.text.isNotEmpty ||
                                !bankaddress.text.isNotEmpty ||
                                !bankbranch.text.isNotEmpty ||
                                !bankName.text.isNotEmpty ||
                                !name.text.isNotEmpty) {
                              dialog(context, 'Please enter all the details',
                                  () {
                                Nav.pop(context);
                              });
                            } else if (accountNo.toString().length < 14) {
                              dialog(context,
                                  'Account number should be 14 digits.', () {
                                Nav.pop(context);
                              });
                            } else {
                              if (widget.pageName == 'settings') {
                                Prefs.getPrefs('token').then((token) {
                                  Prefs.getPrefs('loginId').then((loginId) {
                                    _apiServices.post(
                                        context: context,
                                        endpoint: 'indexPDF.php',
                                        body: {
                                          "fem_user_login_id": loginId,
                                          "type": "user",
                                          "mode": "mobile",
                                          "access_token": token,
                                          "submit_bank": "Confirm",
                                          "comments": "Activate my account",
                                          "bank_account_name": name.text,
                                          "bank_name": bankName.text,
                                          "bank_branch": bankbranch.text,
                                          "bank_address": bankaddress.text,
                                          "bank_account_0": accountNo
                                              .toString()
                                              .substring(0, 1),
                                          "bank_account_1": accountNo
                                              .toString()
                                              .substring(2, 5),
                                          "bank_account_2": accountNo
                                              .toString()
                                              .substring(6, 11),
                                          "bank_account_3": accountNo
                                              .toString()
                                              .substring(12, 14),
                                        }).then((value) {
                                      if (value['return'] == 'success') {
                                        dialog(context,
                                            'Bank details saved successfully',
                                            () {
                                          Nav.pop(context);
                                        });
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
                              } else {
                                Prefs.getPrefs('token').then((token) {
                                  Prefs.getPrefs('loginId').then((loginId) {
                                    _apiServices.post(
                                        context: context,
                                        endpoint: 'indexPDF.php',
                                        body: {
                                          "fem_user_login_id": loginId,
                                          "type": "user",
                                          "mode": "mobile",
                                          "access_token": token,
                                          "submit_bank": "Confirm",
                                          "comments": "Activate my account",
                                          "bank_account_name": name.text,
                                          "bank_name": bankName.text,
                                          "bank_branch": bankbranch.text,
                                          "bank_address": bankaddress.text,
                                          "bank_account_0": accountNo
                                              .toString()
                                              .substring(0, 1),
                                          "bank_account_1": accountNo
                                              .toString()
                                              .substring(2, 5),
                                          "bank_account_2": accountNo
                                              .toString()
                                              .substring(6, 11),
                                          "bank_account_3": accountNo
                                              .toString()
                                              .substring(12, 14),
                                        }).then((value) {
                                      print(value);
                                      if (value['return'] == 'success') {
                                        Nav.push(
                                            context, const DownloadDocument());
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
                            }
                          },
                          width: 150),
                    ),
                  ))
                ]))));
  }
}
