import 'package:flutter/material.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/screens/tab_screens/home_screens/pay_screen.dart';
import 'package:money_bizo/widget/navigator.dart';
import '../../../app_config/colors.dart';
import '../../../widget/sahared_prefs.dart';
import '../../../widget/widgets.dart';

class UpcomingPaymentsScreen extends StatefulWidget {
  const UpcomingPaymentsScreen({super.key});

  @override
  State<UpcomingPaymentsScreen> createState() => _UpcomingPaymentsScreenState();
}

class _UpcomingPaymentsScreenState extends State<UpcomingPaymentsScreen> {
  final ApiServices _apiServices = ApiServices();

  List<dynamic> upcommingPayments = [];

  @override
  void initState() {
    Prefs.getBool('company').then((company) {
      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getToken().then((token) {
          if (token != null) {
            _apiServices
                .post(
                    context: context,
                    endpoint: 'index/UserPayment_ctrl.php',
                    body: company!
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
              if (value != null) {
                for (int i = 0; i < value['payment_data'].length; i++) {
                  if (value['payment_data'][i]['transaction_paid'] == 'N') {
                    upcommingPayments.add(value['payment_data'][i]);
                  }
                }

                for (int i = 0; i < value.length; i++) {
                  if (value['payment_data'][i]['transaction_paid'] == 'Y') {
                    upcommingPayments.add(value['payment_data'][i]);
                  }
                }
              }
              setState(() {});
            });
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
            padding: const EdgeInsets.all(10),
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
                  Row(children: [
                    IconButton(
                        onPressed: () {
                          Nav.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back)),
                    const Text('Upcoming payments',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20))
                  ]),
                  gap(20),
                  upcommingPayments.isEmpty
                      ? const Center(
                          child: Text('No Upcomming Payments yet!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)))
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: upcommingPayments.length,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                          itemBuilder: (context, index) {
                            return Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${upcommingPayments[index]['gen_company_name']}',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            gap(5),
                                            Row(children: [
                                              const Text('Due date: ',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  '${upcommingPayments[index]['post_date']}'),
                                            ]),
                                            gap(5),
                                            Row(children: [
                                              const Text('Due amount: ',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  '\$${upcommingPayments[index]['amount_debit']}'),
                                            ]),
                                          ])),
                                  Expanded(
                                      child: InkWell(
                                    onTap: () {
                                      if (upcommingPayments[index]
                                              ['date_paid'] ==
                                          '') {
                                        Nav.push(
                                            context,
                                            PayScreen(
                                                companyName:
                                                    upcommingPayments[index]
                                                        ['gen_company_name'],
                                                companyDescription:
                                                    '${upcommingPayments[index]['gen_street']}, ${upcommingPayments[index]['gen_suburb']}, ${upcommingPayments[index]['gen_city']}, ${upcommingPayments[index]['gen_postal']}, ${upcommingPayments[index]['gen_country']}',
                                                amount: upcommingPayments[index]
                                                    ['amount_debit'],
                                                qr: upcommingPayments[index]
                                                    ['qr_code']));
                                      }
                                    },
                                    child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: upcommingPayments[index]['transaction_paid'] == 'N'
                                                ? Colors.blue
                                                : Colors.white,
                                            border: Border.all(
                                                color:
                                                    upcommingPayments[index]['transaction_paid'] == 'N'
                                                        ? Colors.transparent
                                                        : Colors.black
                                                        ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                            child: Text(upcommingPayments[index]['transaction_paid'] == 'N' ? 'Pay Now' : 'Paid',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        upcommingPayments[index]['transaction_paid'] == 'N'
                                                            ? Colors.white
                                                            : Colors.black,
                                                    fontSize: 16)))),
                                  ))
                                ]);
                          },
                        )
                ]))));
  }
}
