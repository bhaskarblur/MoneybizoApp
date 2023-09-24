import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/providers/transaction_provider.dart';
import 'package:money_bizo/screens/tab_screens/history_screens/history_details.dart';
import 'package:money_bizo/widget/navigator.dart';
import 'package:money_bizo/widget/sahared_prefs.dart';
import 'package:provider/provider.dart';
import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';
import '../../authentication/login_screen.dart';

class TxHistoryScreen extends StatefulWidget {
  const TxHistoryScreen({super.key});

  @override
  State<TxHistoryScreen> createState() => _TxHistoryScreenState();
}

class _TxHistoryScreenState extends State<TxHistoryScreen> {
  final ApiServices _apiServices = ApiServices();

  bool company = false;

  bool purchaseHistory = true;

  @override
  void initState() {
    final provider = Provider.of<TransactionProvider>(context, listen: false);

    Prefs.getPrefs("loginId").then((loginId) {
      Prefs.getToken().then((token) {
        Prefs.getBool('company').then((value) {
          if (token != null) {
            company = value!;
            _apiServices
                .post(
                    context: context,
                    endpoint: value
                        ? 'clientOnlineHistory_mob.php'
                        : 'userTransactions.php',
                    body: company
                        ? {
                            "fem_company_login_id": loginId,
                            // "type": "user",
                            "mode": "mobile",
                            "access_token": token,
                          }
                        : {
                            "fem_user_login_id": loginId,
                            "type": "user",
                            "mode": "mobile",
                            "access_token": token,
                          })
                .then((value) {
              if (value['message'] == 'No Transactions Found') {
                provider.changeTransaction([]);
                dialog(context, value['message'], () {
                  Nav.pop(context);
                });
              } else {
                provider.changeTransaction(value['transactions']);
              }
            });

            if (company) {
              _apiServices.post(
                  context: context,
                  endpoint: 'clientOnlineHistory_mob.php',
                  body: {
                    "fem_company_login_id": loginId,
                    "type": "company",
                    "mode": "mobile",
                    "access_token": token,
                  }).then((value) {
                provider.changeSalesHistory(value['transactions_details']);
              });
            }
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
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SingleChildScrollView(child:
                Consumer<TransactionProvider>(builder: (context, provider, _) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    statusBar(context),
                    Center(
                        child: SizedBox(
                            width: 100,
                            child:
                                Image.asset('assets/icons/banner_icon.png'))),
                    gap(10),
                    const Text('Transaction/Reward History',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    gap(20),
                    if (company)
                      Row(children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              purchaseHistory = true;
                              setState(() {});
                            },
                            child: Column(
                              children: [
                                Text('Purchase History',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: purchaseHistory
                                            ? Colors.blue
                                            : Colors.black,
                                        fontWeight: FontWeight.bold)),
                                gap(10),
                                Container(
                                    height: 2,
                                    color: purchaseHistory
                                        ? Colors.blue
                                        : Colors.transparent)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              purchaseHistory = false;
                              setState(() {});
                            },
                            child: Column(
                              children: [
                                Text('Sales History',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: purchaseHistory
                                            ? Colors.black
                                            : Colors.blue,
                                        fontWeight: FontWeight.bold)),
                                gap(10),
                                Container(
                                    height: 2,
                                    color: purchaseHistory
                                        ? Colors.transparent
                                        : Colors.blue)
                              ],
                            ),
                          ),
                        ),
                      ]),
                    gap(10),
                    Container(
                      color:
                          Colors.white, // <-- Red color provided to below Row
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade400)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              divider(),
                              tile(Colors.black54, 14, "Date", "Company   ",
                                  "Debit", "Credit", "Particulars"),
                            ]),
                      ),
                    ),
                    purchaseHistory
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                gap(10),
                                provider.transactions == null
                                    ? gap(0)
                                    : provider.transactions.length < 1
                                        ? emptyMessage('Transactions')
                                        : ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.all(0),
                                            itemCount:
                                                provider.transactions.length,
                                            separatorBuilder: (context, index) {
                                              return gap(10);
                                            },
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  Nav.push(
                                                      context,
                                                      HistoryDetailsScreen(
                                                          details: provider
                                                                  .transactions[
                                                              index]));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade400)),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        divider(),
                                                        if (provider.transactions[index]['action_debit'] == "1" &&
                                                            provider.transactions[index]['message'] !=
                                                                "CREDIT BY ADMIN")
                                                          tile(
                                                              Colors.black54,
                                                              12,
                                                              DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(provider.transactions[index][
                                                                  'datetime'])),
                                                              provider.transactions[index]['gen_company_name'] ??
                                                                  '',
                                                              provider.transactions[index][''] ??
                                                                  '',
                                                              "\$" + provider.transactions[index]['amount_reward_user'] ??
                                                                  '',
                                                              'REWARD (10.00% on Purchase of \$' + provider.transactions[index]['amount'] + ')' ??
                                                                  '')
                                                        else if (provider.transactions[index]['action_debit'] ==
                                                            "0")
                                                          tile(
                                                              Colors.black54,
                                                              12,
                                                              DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(provider.transactions[index]['datetime'])),
                                                              provider.transactions[index]['gen_company_name'] ?? '',
                                                              "\$" + provider.transactions[index]['amount'] ?? '',
                                                              "" ?? '',
                                                              '  PURCHASE')
                                                        else if (provider.transactions[index]['message'] == "CREDIT BY ADMIN")
                                                          tile(Colors.black54, 12, DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(provider.transactions[index]['datetime'])), provider.transactions[index]['gen_company_name'] ?? '', '' ?? '', "\$" + provider.transactions[index]['amount_reward_user'] ?? '', 'CREDITED'),
                                                      ]),
                                                ),
                                              );
                                            },
                                          )
                              ])
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                gap(10),
                                provider.salesHistory == null
                                    ? gap(0)
                                    : provider.salesHistory.length < 1
                                        ? emptyMessage('Sales History')
                                        : ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.all(0),
                                            itemCount:
                                                provider.salesHistory.length,
                                            separatorBuilder: (context, index) {
                                              return gap(10);
                                            },
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  Nav.push(
                                                      context,
                                                      HistoryDetailsScreen(
                                                          details: provider
                                                                  .salesHistory[
                                                              index]));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade400)),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        divider(),
                                                        if (provider.salesHistory[index]['action_debit'] == "1" &&
                                                            provider.salesHistory[index]['message'] !=
                                                                "CREDIT BY ADMIN")
                                                          tile(
                                                              Colors.black54,
                                                              12,
                                                              DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(provider.salesHistory[index][
                                                                  'datetime'])),
                                                              provider.salesHistory[index]['gen_company_name'] ??
                                                                  '',
                                                              provider.salesHistory[index][''] ??
                                                                  '',
                                                              "\$" + provider.salesHistory[index]['amount_reward_user'] ??
                                                                  '',
                                                              'REWARD (10.00% on Purchase of \$' + provider.salesHistory[index]['amount'] + ')' ??
                                                                  '')
                                                        else if (provider.salesHistory[index]['action_debit'] ==
                                                            "0")
                                                          tile(
                                                              Colors.black54,
                                                              12,
                                                              DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(provider.salesHistory[index]['datetime'])),
                                                              provider.salesHistory[index]['gen_company_name'] ?? '',
                                                              "\$" + provider.salesHistory[index]['amount'] ?? '',
                                                              "" ?? '',
                                                              '  PURCHASE')
                                                        else if (provider.salesHistory[index]['message'] == "CREDIT BY ADMIN")
                                                          tile(Colors.black54, 12, DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(provider.salesHistory[index]['datetime'])), provider.salesHistory[index]['gen_company_name'] ?? '', '' ?? '', "\$" + provider.salesHistory[index]['amount_reward_user'] ?? '', 'CREDITED'),
                                                      ]),
                                                ),
                                              );
                                            },
                                          )
                              ])
                  ]);
            }))));
  }

  Widget tile(Color color, double size, String one, String two, String three,
      String four, String reward) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 2,
              child: Text(one,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: size,
                      color: color,
                      fontWeight: FontWeight.bold))),
          Expanded(
              flex: 3,
              child: Wrap(
                children: [
                  Text(two,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: size,
                          color: color,
                          fontWeight: FontWeight.bold)),
                  Text(reward,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: size,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold)),
                ],
              )),
          Expanded(
              flex: 1,
              child: Text(
                three,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: size, color: color, fontWeight: FontWeight.bold),
              )),
          Expanded(
              flex: 1,
              child: Text(
                four,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: size, color: color, fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }
}
