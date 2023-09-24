import 'package:flutter/material.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/screens/authentication/login_screen.dart';
import 'package:money_bizo/widget/navigator.dart';
import 'package:money_bizo/widget/sahared_prefs.dart';
import 'package:provider/provider.dart';
import '../../../app_config/colors.dart';
import '../../../providers/profile_provider.dart';
import '../../../widget/widgets.dart';

class MyBalanceScreen extends StatefulWidget {
  const MyBalanceScreen({super.key});

  @override
  State<MyBalanceScreen> createState() => _MyBalanceScreenState();
}

class _MyBalanceScreenState extends State<MyBalanceScreen> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _enterAmount = TextEditingController();
  bool? com;

  @override
  void initState() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    Prefs.getBool('company').then((company) {
      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getToken().then((token) {
          if (token != null) {
            provider.changeCompany(company!);
            _apiServices
                .post(
                    context: context,
                    endpoint: company ? 'clientBankEdit.php' : 'indexPDF.php',
                    body: company
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
              provider.changeBankDetails(value['bank_details']);
            });

            _apiServices
                .post(
                    context: context,
                    endpoint: company
                        ? 'ClientPayment_withdraw.php'
                        : 'userBalance.php',
                    body: company
                        ? {
                            "fem_company_login_id": loginId,
                            "type": "user",
                            "mode": "mobile",
                            "access_token": token
                          }
                        : {
                            "fem_user_login_id": loginId,
                            "type": "user",
                            "mode": "mobile",
                            "access_token": token
                          },
                    progressBar: true)
                .then((value) {
              provider.changeBalance(value);
            });
          } else {
            showYesNoButton(context, 'You have to login first.', () {
              Nav.pop(context);
            }, () {
              Nav.pop(context);
              Nav.push(context, const LoginScreen());
            }, button1: 'Cancel', button2: 'Login');
          }
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Consumer<ProfileProvider>(builder: (context, provider, _) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: SingleChildScrollView(
                  child: provider.balance == null
                      ? gap(0)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              statusBar(context),
                              Center(
                                  child: SizedBox(
                                      width: 100,
                                      child: Image.asset(
                                          'assets/icons/banner_icon.png'))),
                              const Text('My Balances',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              gap(20),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Total Balance',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        Text(
                                            provider.company
                                                ? '\$${provider.balance['available_balance_to_withdraw']}'
                                                : '\$${provider.balance['user_balances']['total_available_spendings']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white)),
                                      ]),
                                ),
                              ),
                              gap(20),
                              provider.company
                                  ? Column(children: [
                                      tile('Your Available Balance',
                                          '\$${provider.balance['advance_issued'] ?? 0.00}'),
                                      tile('Your purchase',
                                          '\$${provider.balance['your_purchases'] ?? 0.00}'),
                                      tile('Your sales',
                                          '\$${provider.balance['your_sales'] ?? 0.00}'),
                                      tile('Your rewards available',
                                          '\$${provider.balance['your_rewards'] ?? 0.00}'),
                                      tile('Your available balance to withdraw',
                                          '\$${provider.balance['available_balance_to_withdraw'] ?? 0.00}'),
                                    ])
                                  : Column(children: [
                                      tile('Your Available Balance',
                                          '\$${provider.balance['user_balances']['total_available_spendings'] ?? 0.00}'),
                                      tile('Your rewards received',
                                          '\$${provider.balance['user_balances']['total_reward_received'] ?? 0.00}'),
                                      tile('Your rewards used',
                                          '\$${provider.balance['user_balances']['user_reward_used'] ?? 0.00}'),
                                      tile('Your rewards available',
                                          '\$${provider.balance['user_balances']['general_reward'] ?? 0.00}'),
                                      tile('Your total spendings',
                                          '\$${provider.balance['user_balances']['user_total_spendings'] ?? 0.00}'),
                                    ]),
                              gap(20),
                              if (provider.bankDetails != null)
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Bank Details',
                                            style: TextStyle(fontSize: 18)),
                                        gap(10),
                                        Row(
                                          children: [
                                            const Text("Account holder name: ",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                "${provider.bankDetails['bank_account_name']}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        gap(5),
                                        Row(
                                          children: [
                                            const Text("Bank name: ",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                "${provider.bankDetails['bank_name']}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        gap(5),
                                        Row(
                                          children: [
                                            const Text("Bank brach: ",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                "${provider.bankDetails['bank_branch']}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              gap(20),
                              FutureBuilder(
                                  future: Prefs.getBool('company'),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data == true) {
                                        return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                  'Enter amount to withdraw',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16)),
                                              gap(10),
                                              Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Center(
                                                  child: IntrinsicWidth(
                                                    child: TextFormField(
                                                      controller: _enterAmount,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 20),
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                      decoration: const InputDecoration(
                                                          prefixText: "\$",
                                                          hintText: '0',
                                                          filled: true,
                                                          fillColor: Colors
                                                              .transparent,
                                                          border:
                                                              OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide
                                                                          .none)),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Please enter an amount';
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // TextFormField(
                                              //   controller: _enterAmount,
                                              //   keyboardType:
                                              //       TextInputType.number,
                                              //   decoration: InputDecoration(
                                              //       filled: true,
                                              //       fillColor:
                                              //           Colors.grey.shade300,
                                              //       border: OutlineInputBorder(
                                              //         borderSide:
                                              //             BorderSide.none,
                                              //         borderRadius:
                                              //             BorderRadius.circular(
                                              //                 10),
                                              //       )),
                                              //   validator: (value) {
                                              //     if (value!.isEmpty) {
                                              //       return 'Please enter an amount';
                                              //     } else {
                                              //       return null;
                                              //     }
                                              //   },
                                              // ),
                                              gap(20),
                                              newFullButton(() {
                                                if (_enterAmount
                                                    .text.isNotEmpty) {
                                                  Prefs.getPrefs('loginId')
                                                      .then((loginId) {
                                                    Prefs.getToken()
                                                        .then((token) {
                                                      _apiServices.post(
                                                          context: context,
                                                          endpoint:
                                                              'ClientPayment_withdraw.php',
                                                          body: {
                                                            "fem_company_login_id":
                                                                loginId,
                                                            "type": "company",
                                                            "mode": "mobile",
                                                            "access_token":
                                                                token,
                                                            "submit":
                                                                'Withdraw',
                                                            "amount":
                                                                _enterAmount
                                                                    .text,
                                                          }).then((value) {
                                                        dialog(context,
                                                            value['message'],
                                                            () {
                                                          Nav.pop(context);
                                                        });
                                                      });
                                                    });
                                                  });
                                                } else {
                                                  dialog(
                                                      context, 'Enter amount',
                                                      () {
                                                    Nav.pop(context);
                                                  });
                                                }
                                              }, 'Withdraw amount')
                                            ]);
                                      } else {
                                        return gap(0);
                                      }
                                    } else {
                                      return gap(0);
                                    }
                                  }),
                            ])));
        }));
  }

  Widget tile(String title, String value) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ]),
        gap(5)
      ],
    );
  }

  customTile(String text, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade100,
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(1, 2))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(text,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ]),
          )),
    );
  }
}
