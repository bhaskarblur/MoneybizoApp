import 'package:money_bizo/app_config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../app_config/app_details.dart';
import 'navigator.dart';

Widget gap(double height) {
  return SizedBox(height: height);
}

Widget horGap(double width) {
  return SizedBox(width: width);
}

Widget fullWidthButton(
    {required String buttonName,
    required void Function() onTap,
    double fontSize = 18,
    double width = double.infinity,
    double height = 50}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: height,
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 2,
                offset: Offset(0, 2),
                spreadRadius: 2)
          ]),
      child: Center(
          child: Text(buttonName,
              style: TextStyle(
                  color: backgroundColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold))),
    ),
  );
}

newFullButton(void Function()? onTap, String title) {
  return InkWell(
    onTap: onTap,
    child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.blue),
        child: Center(
          child: Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        )),
  );
}

Widget borderedButton(
    {required String buttonName, required void Function() onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.circular(5)),
        child: Center(
            child: Text(buttonName,
                style: TextStyle(color: primaryColor, fontSize: 16)))),
  );
}

Widget customTextField(TextEditingController controller, String hintText,
    {Color fillColor = Colors.white,
    TextInputType keyboard = TextInputType.emailAddress}) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(5)),
    child: TextFormField(
        controller: controller,
        cursorColor: primaryTextColor,
        style: TextStyle(color: primaryTextColor),
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: hintText,
          fillColor: fillColor,
          filled: true,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        )),
  );
}

Widget customTextField3(TextEditingController controller, String hintText,
    {Color fillColor = Colors.white,
    TextInputType keyboard = TextInputType.datetime}) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(5)),
    child: TextFormField(
        controller: controller,
        cursorColor: primaryTextColor,
        style: TextStyle(color: primaryTextColor),
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: hintText,
          fillColor: fillColor,
          filled: true,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        )),
  );
}

Widget customTextField2(TextEditingController controller, String hintText,
    {Color fillColor = Colors.white,
    TextInputType keyboard = TextInputType.number}) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(5)),
    child: TextFormField(
        controller: controller,
        cursorColor: primaryTextColor,
        style: TextStyle(color: primaryTextColor),
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: hintText,
          fillColor: fillColor,
          filled: true,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        )),
  );
}

loader(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          contentPadding: const EdgeInsets.all(15),
          content: Row(
            children: [
              CircularProgressIndicator(color: primaryColor),
              horGap(20),
              Text('Loading...',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryColor))
            ],
          ),
        );
      });
}

dialog(BuildContext context, String message, void Function()? onok,
    {String title = 'MoneyBizo'}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(15),
          title: Text(title),
          content: Text(message, maxLines: 5),
          actions: [
            InkWell(
              onTap: onok,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: primaryColor),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Ok',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
              ),
            ),
          ],
        );
      });
}

internetBanner(BuildContext context, String message, void Function()? onOk) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          contentPadding: const EdgeInsets.all(15),
          title: const Text('Alert',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 100, color: Colors.white),
              Text(message,
                  maxLines: 5,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10),
              child: InkWell(
                onTap: onOk,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: primaryColor),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('Ok',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        );
      });
}

showYesNoButton(BuildContext context, String message, void Function()? onYes,
    void Function()? onNo,
    {String button1 = 'Yes', String button2 = 'No'}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(15),
          title: Text(appName, style: TextStyle(color: primaryTextColor)),
          content: Text(message,
              maxLines: 5, style: TextStyle(color: primaryTextColor)),
          actions: [
            InkWell(
              onTap: onYes,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(button1,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: backgroundColor)),
                ),
              ),
            ),
            horGap(10),
            InkWell(
              onTap: onNo,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(button2,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: backgroundColor)),
                ),
              ),
            ),
          ],
        );
      });
}

dateFormetterFromString(String date) {
  return DateFormat('yyyy-MM-dd').format(DateTime.parse(date)).toString();
}

Widget actionButton(Color color, IconData icon, void Function()? onTap) {
  return Expanded(
      child: InkWell(
    onTap: onTap,
    child: Container(
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: color)),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(name,
          //     style: TextStyle(
          //         fontWeight: FontWeight.bold, color: color, fontSize: 14)),
          // SizedBox(width: 5),
          Icon(icon, color: color, size: 24)
        ],
      )),
    ),
  ));
}

statusBar(BuildContext context) {
  return SizedBox(height: MediaQuery.of(context).viewPadding.top);
}

Widget tile(String title, String image, void Function()? onTap) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            SizedBox(height: 30, width: 30, child: Image.asset(image)),
            horGap(20),
            Text(title,
                style: TextStyle(
                    fontSize: 16,
                    color: primaryTextColor,
                    fontWeight: FontWeight.normal)),
          ]),
          Icon(Icons.keyboard_arrow_right_rounded,
              color: primaryTextColor, size: 36),
        ],
      ),
    ),
  );
}

Widget customTile(
    {String? image, String? title, String? subtitle, void Function()? onTap}) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(5)),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.black87, borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            if (image != null)
              SizedBox(height: 20, width: 20, child: SvgPicture.asset(image)),
            if (image != null) horGap(20),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title!,
                        style: TextStyle(color: primaryColor, fontSize: 18)),
                    if (subtitle != null) gap(5),
                    if (subtitle != null)
                      Text(subtitle,
                          style:
                              TextStyle(color: primaryTextColor, fontSize: 16)),
                  ]),
            )
          ]),
        ),
      ),
    ),
  );
}

Widget settingsAppBar(BuildContext context, String title,
    {Widget? actionButton}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Column(children: [
      statusBar(context),
      Stack(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
                onTap: () {
                  Nav.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.keyboard_arrow_left,
                        color: primaryColor, size: 24),
                    horGap(3),
                    Text('Settings',
                        style: TextStyle(color: primaryColor, fontSize: 16)),
                  ],
                )),
            actionButton ?? gap(0)
          ],
        ),
        Align(
            alignment: Alignment.center,
            child: Text(title,
                style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))),
      ]),
      gap(20),
    ]),
  );
}

Widget card(String title, String subtitle, String image, bool border,
    void Function()? onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: border ? primaryColor : Colors.transparent),
          borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child:
                    SizedBox(height: 40, width: 40, child: Image.asset(image))),
            Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    gap(5),
                    Text(subtitle, style: TextStyle(color: primaryTextColor)),
                  ],
                ))
          ],
        ),
      ),
    ),
  );
}

Widget friendsTile(String image, String title, String subtitle,
    {String? buttonName}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(children: [
        SizedBox(height: 40, width: 40, child: Image.asset(image)),
        horGap(10),
        Column(
          children: [
            Text(title, style: TextStyle(color: primaryTextColor)),
            Text(subtitle, style: TextStyle(color: primaryColor))
          ],
        ),
      ]),
      buttonName == null
          ? gap(0)
          : Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: primaryColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(buttonName,
                    style: const TextStyle(color: Colors.black)),
              ))
    ],
  );
}

passTextField(TextEditingController controller, String labelText,
    bool visibility, void Function()? onTap) {
  return TextFormField(
      controller: controller,
      cursorColor: primaryTextColor,
      style: TextStyle(color: primaryTextColor),
      obscureText: !visibility,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: InkWell(
          onTap: onTap,
          child: Icon(visibility ? Icons.visibility : Icons.visibility_off,
              color: visibility ? primaryColor : Colors.grey),
        ),
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        border:
            UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
      ));
}

Widget customDatePicker(BuildContext context, String text) {
  return InkWell(
    onTap: () {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1),
      );
    },
    child: Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey.shade200)),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text,
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.bold)),
            const Icon(Icons.keyboard_arrow_down)
          ],
        ),
      )),
    ),
  );
}

Widget divider() {
  return Container(height: 1, width: double.infinity, color: Colors.grey);
}

Widget dottedDivder() {
  return Row(
    children: List.generate(
        150 ~/ 1.5,
        (index) => Expanded(
              child: Container(
                color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                height: 2,
              ),
            )),
  );
}

Widget serachBar(
  TextEditingController search,
  Function()? onTap, {
  void Function(String)? onChanged,
  void Function()? onEditingComplete,
  bool filter = true,
}) {
  return Row(
    children: [
      Expanded(
          child: TextField(
        controller: search,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, size: 26, color: Colors.black54),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search anything',
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300)),
        ),
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
      )),
      if (filter) horGap(10),
      if (filter)
        InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.black),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset('assets/icons/filter_lines.svg',
                  height: 40, width: 40),
            ),
          ),
        ),
    ],
  );
}

Widget customCard(
  dynamic data, {
  bool gallery = true,
  void Function()? byNowOnTap,
  void Function()? ontapCompany,
}) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      InkWell(
        onTap: ontapCompany,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            data['profile_logo'] != '' && data['profile_logo'] != null
                ? Image.network(
                    '${baseUrl}images/clients/${data['profile_logo']}',
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, er, rr) {
                      return Image.asset('assets/images/food.png');
                    },
                  )
                : Image.asset('assets/images/food.png'),

            horGap(10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(data['gen_company_name'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    data['gen_street'] +
                        ' ' +
                        data['gen_suburb'] +
                        ' ' +
                        data['gen_city'] +
                        ' ' +
                        data['gen_country'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  gap(10),
                  Text(
                    'Ph : ${data['contact_public']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ])),
            // Column(children: [
            //   IconButton(
            //       onPressed: () {},
            //       icon: const Icon(Icons.favorite_outline, color: Colors.red)),
            if (data['user_reward'] != "0.00")
              Image.asset('assets/images/reward.png', height: 50, width: 50)
            // ]),
          ]),
        ),
      ),
      dottedDivder(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            const Text("This week's maximum reward is: ",
                style: TextStyle(color: Colors.black54)),
            Text(data['user_reward'] + '%',
                style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
      dottedDivder(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            InkWell(
              onTap: byNowOnTap,
              child: const Text("Buy Now Products",
                  style: TextStyle(color: Colors.black)),
            ),
            if (gallery)
              const Text(" | ", style: TextStyle(color: Colors.black)),
            if (gallery)
              const Text("View Gallery", style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    ]),
  );
}

Widget customDropdown(
    List<String> items, String dValue, void Function(String?)? onChanged) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: DropdownButton<String>(
          isExpanded: true,
          underline: gap(0),
          value: dValue,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged),
    ),
  );
}

Widget emptyMessage(String type) {
  return Column(
    children: [
      const Row(children: []),
      Image.asset('assets/images/desk.png'),
      gap(20),
      Text(type,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
      const Text(
          '(Rewards apply to all online purchases as per shop rewards except on vouchers)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey)),
      gap(10),
      const Text('You can only shop from one store during each checkout',
          textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
      gap(10),
      Text('There is no $type.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey))
    ],
  );
}
