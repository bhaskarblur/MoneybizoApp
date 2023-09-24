import 'package:flutter/material.dart';
import 'package:money_bizo/widget/navigator.dart';

import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

class HistoryDetailsScreen extends StatefulWidget {
  final dynamic details;
  const HistoryDetailsScreen({super.key, this.details});

  @override
  State<HistoryDetailsScreen> createState() => _HistoryDetailsScreenState();
}

class _HistoryDetailsScreenState extends State<HistoryDetailsScreen> {
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
                          child: Image.asset('assets/icons/banner_icon.png'))),
                  gap(10),
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Nav.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            size: 26,
                          )),
                      horGap(10),
                      const Text('Break Down',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  gap(10),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade400)),
                    child: Column(children: [
                      tileCard(
                          'Amount used from account', widget.details['amount']),
                      divider(),
                      tileCard('Reward Used',
                          widget.details['amount_reward_deduction']),
                      divider(),
                      tileCard(
                          'Your Purchase Total',
                          (double.parse(widget.details['amount']) -
                                  double.parse(widget
                                      .details['amount_reward_deduction']))
                              .toStringAsFixed(2)),
                    ]),
                  ),
                  gap(30),
                  Center(
                      child: fullWidthButton(
                          buttonName: 'Back',
                          onTap: () {
                            Nav.pop(context);
                          },
                          width: 100))
                ]))));
  }

  Widget tileCard(String text, String price) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(price,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ]),
    );
  }
}
