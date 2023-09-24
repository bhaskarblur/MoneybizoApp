import 'package:flutter/material.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/app_config/app_details.dart';
import 'package:money_bizo/screens/tab_screens/home_screens/pay_screen.dart';

import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/sahared_prefs.dart';
import '../../../widget/widgets.dart';
import 'buy_now_screen.dart';

class CompanyDetails extends StatefulWidget {
  final String? companyId;
  const CompanyDetails({super.key, required this.companyId});

  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  final ApiServices _apiServices = ApiServices();

  dynamic data;

  @override
  void initState() {
    Prefs.getBool('company').then((company) {
      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getToken().then((token) {
          if (token != null) {
            _apiServices
                .post(context: context, endpoint: 'viewClient.php', body: {
              "mode": "mobile",
              "type": "user",
              "access_token": token,
              "fem_company_login_id": widget.companyId,
            }).then((value) {
              data = value;
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
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Nav.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back, size: 30)),
                    const Text('About Company',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold))
                  ],
                ),
                gap(20),
                if (data != null)
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          child: data['company_detail']['profile_logo'] == null
                              ? Image.asset('assets/images/homeImage.png',
                                  fit: BoxFit.cover)
                              : Image.network(
                                  baseUrl + 'images/clients/' +
                                      data['company_detail']['profile_logo'],
                                  errorBuilder: (z, x, c) {
                                    return Image.asset(
                                        'assets/images/homeImage.png',
                                        fit: BoxFit.contain);
                                  },
                                ),
                        ),
                        gap(10),
                        Text(data['company_detail']['gen_company_name'],
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        gap(10),
                        Wrap(children: [
                          Text(data['company_detail']['gen_street'] + ', ',
                              style: const TextStyle(color: Colors.grey)),
                          Text(data['company_detail']['gen_suburb'] + ', ',
                              style: const TextStyle(color: Colors.grey)),
                          Text(data['company_detail']['gen_city'] + ', ',
                              style: const TextStyle(color: Colors.grey)),
                          Text(data['company_detail']['gen_postal'] + ', ',
                              style: const TextStyle(color: Colors.grey)),
                          Text(data['company_detail']['gen_country'],
                              style: const TextStyle(color: Colors.grey)),
                        ]),
                        gap(10),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                const Icon(Icons.phone, color: Colors.blue),
                                horGap(10),
                                Text(data['company_detail']['contact_public'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))
                              ]),
                              gap(10),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child:
                                          Icon(Icons.email, color: Colors.blue),
                                    ),
                                    horGap(10),
                                    Expanded(
                                      child: Text(
                                          data['company_detail']['mymy_loggme'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                    )
                                  ]),
                            ]),
                        gap(30),
                        RichText(
                            text: TextSpan(children: [
                          const TextSpan(
                              text: 'About the company: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: data['company_detail']['profile_about'],
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 18)),
                        ])),
                        gap(20),
                        RichText(
                            text: TextSpan(children: [
                          const TextSpan(
                              text: 'Business category: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: data['company_detail']
                                  ['profile_business_category'],
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 18)),
                        ])),
                        gap(30),
                      ])
              ]))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Nav.push(
                    context,
                    BuyNowScreen(
                        companyId: widget.companyId!,
                        companyName: data['company_detail']
                            ['gen_company_name']));
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue),
                child: const Center(
                  child: Text('See all products',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ),
          ),
          horGap(20),
          Expanded(
            child: InkWell(
              onTap: () {
                Nav.push(
                    context,
                    PayScreen(
                      email: data['company_detail']['mymy_loggme'],
                      companyName: data['company_detail']['gen_company_name'],
                      qr: data['company_detail']['qr_code'],
                      companyDescription:
                          '${data['company_detail']['gen_street']}, ${data['company_detail']['gen_suburb']}, ${data['company_detail']['gen_city']}, ${data['company_detail']['gen_postal']}, ${data['company_detail']['gen_country']}',
                    ));
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black),
                child: const Center(
                  child: Text('Make payment',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
