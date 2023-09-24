import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_bizo/api_services.dart';

import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/sahared_prefs.dart';
import '../../../widget/widgets.dart';
import 'download_document_screen.dart';

class PaymentSchedule extends StatefulWidget {
  final String pageName;
  const PaymentSchedule({super.key, required this.pageName});

  @override
  State<PaymentSchedule> createState() => _PaymentScheduleState();
}

class _PaymentScheduleState extends State<PaymentSchedule> {
  final ApiServices _apiServices = ApiServices();

  String selectedValue = 'Pay each shopping bill overnight';

  List<dynamic> list = [];

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
                  gap(10),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Nav.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back, size: 30)),
                      const Text('Payment Schedule',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  gap(10),
                  radioTile('Pay each shopping bill overnight'),
                  radioTile('Pay each shopping bill over 2 weeks'),
                  radioTile('Pay each shopping bill over 4 weeks'),
                  gap(30),
                  fullWidthButton(
                      buttonName: 'Submit',
                      onTap: () {
                        if (selectedValue != '') {
                          Prefs.getPrefs('token').then((token) {
                            Prefs.getPrefs('loginId').then((loginId) {
                              _apiServices.post(
                                  context: context,
                                  endpoint: 'index/payment_schedule.php',
                                  body: {
                                    "fem_user_login_id": loginId,
                                    "access_token": token,
                                    "type": "user",
                                    "mode": "mobile",
                                    "payment_schedule": selectedValue ==
                                            'Pay each shopping bill overnight'
                                        ? '1'
                                        : selectedValue ==
                                                'Pay each shopping bill over 2 weeks'
                                            ? '2'
                                            : '4',
                                  }).then((value) {
                                if (value['return'] == 'success') {
                                  if (widget.pageName == 'settings') {
                                    dialog(context, value['message'], () {
                                      Nav.pop(context);
                                    });
                                    if (value['logs'] != null &&
                                        value['logs'] != '') {
                                      for (int i = 0;
                                          i < value['logs'].length;
                                          i++) {
                                        list.add(value['logs'][i]);
                                      }
                                      setState(() {});
                                    }
                                  } else if (widget.pageName == 'home') {
                                    Nav.pop(context);
                                  } else {
                                    Nav.push(context, const DownloadDocument());
                                  }
                                } else {
                                  dialog(context,
                                      value['message'] ?? value['error'], () {
                                    Nav.pop(context);
                                  });
                                }
                              });
                            });
                          });
                        } else {
                          dialog(context, 'Select a Duration', () {
                            Nav.pop(context);
                          });
                        }
                      }),
                  gap(20),
                  if (list.isNotEmpty)
                    Column(children: [
                      const Text('Payment Setup Update Logs',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      gap(10),
                      Row(
                        children: [
                          Expanded(child: customDatePicker(context, 'Date')),
                          horGap(15),
                          Expanded(child: customDatePicker(context, 'To')),
                        ],
                      ),
                      gap(30),
                      fullWidthButton(
                          buttonName: 'Go',
                          onTap: () {},
                          width: 70,
                          height: 40),
                      gap(30),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade300)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Update to',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                                Text('Update on',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                              ]),
                        ),
                      ),
                      gap(10),
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: list.length,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) {
                          return gap(10);
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey.shade300)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Pay each shopping bill\nover ${list[index]['status']} weeks',
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        '${DateFormat('dd-MM-yyyy').format(DateTime.parse(list[index]['updated_date']))}\n${DateFormat('hh:mm:ss').format(DateTime.parse(list[index]['updated_date']))}',
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                            ),
                          );
                        },
                      )
                    ]),
                ]))));
  }

  Widget radioTile(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        clipBehavior: Clip.none,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 3,
                  spreadRadius: 3,
                  offset: const Offset(0, 2))
            ]),
        child: RadioListTile(
          groupValue: selectedValue,
          value: title,
          title: Text(title),
          activeColor: primaryColor,
          onChanged: (value) {
            selectedValue = value!;
            print(value);
            setState(() {});
          },
        ),
      ),
    );
  }
}
