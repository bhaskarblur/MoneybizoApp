import 'package:flutter/material.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/app_config/app_details.dart';
import 'package:money_bizo/providers/city_suburb_provider.dart';
import 'package:money_bizo/screens/tab_screens/profile_screens/qr_screen.dart';
import 'package:money_bizo/widget/navigator.dart';
import 'package:provider/provider.dart';
import '../../../app_config/colors.dart';
import '../../../widget/sahared_prefs.dart';
import '../../../widget/widgets.dart';

class QRGridScreen extends StatefulWidget {
  const QRGridScreen({super.key});

  @override
  State<QRGridScreen> createState() => _QRGridScreenState();
}

class _QRGridScreenState extends State<QRGridScreen> {
  final ApiServices _apiServices = ApiServices();

  dynamic qrList;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    Prefs.getPrefs('loginId').then((loginId) {
      Prefs.getToken().then((token) {
        _apiServices
            .post(context: context, endpoint: 'ClientQr_code.php', body: {
          "fem_company_login_id": loginId,
          "type": "company",
          "mode": "mobile",
          "access_token": token
        }).then((value) {
          qrList = value;
          setState(() {});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Consumer<CitySuburbProvider>(builder: (context, provider, _) {
        return Padding(
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
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Nav.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back)),
                      const Text('Your QR Code',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  gap(20),
                  if (qrList != null)
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: qrList['qr_array'].length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Nav.push(context,
                                QRScreen(data: qrList['qr_array'][index]));
                          },
                          child: Column(
                            children: [
                              Text(qrList['qr_array'][index]['lable'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              gap(2),
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 2),
                                ),
                                child: Image.network(
                                    baseUrl + qrList['qr_array'][index]['url'],
                                    fit: BoxFit.cover,
                                    height: 130),
                              ),
                              // gap(5),
                              // InkWell(
                              //   onTap: () {
                              //     Nav.push(context,
                              //         QRScreen(data: qrList['qr_array'][index]));
                              //   },
                              //   child: Container(
                              //     height: 24,
                              //     width: 80,
                              //     decoration: BoxDecoration(
                              //         color: Colors.black,
                              //         borderRadius: BorderRadius.circular(5)),
                              //     child: const Center(
                              //       child: Text('Print',
                              //           style: TextStyle(
                              //               color: Colors.white,
                              //               fontWeight: FontWeight.bold)),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        );
                      },
                    ),
                ])));
      }),
    );
  }
}
