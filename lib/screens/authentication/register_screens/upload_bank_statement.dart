import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_bizo/app_config/app_details.dart';
import 'package:money_bizo/screens/authentication/register_screens/bank_details_screen.dart';
import 'package:http/http.dart' as http;
import 'package:money_bizo/widget/navigator.dart';
import 'package:money_bizo/widget/sahared_prefs.dart';
import '../../../app_config/colors.dart';
import '../../../widget/widgets.dart';

class UploadBankStatement extends StatefulWidget {
  const UploadBankStatement({super.key});

  @override
  State<UploadBankStatement> createState() => _UploadBankStatementState();
}

class _UploadBankStatementState extends State<UploadBankStatement> {
  FilePickerResult? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                const Text(
                  'Upload Bank Statement',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                gap(10),
                const Text('Please upload the bank statement here'),
                gap(20),
                DottedBorder(
                  color: Colors.grey.shade600,
                  strokeWidth: 1,
                  dashPattern: const [10, 10],
                  child: InkWell(
                    onTap: () async {
                      result = await FilePicker.platform.pickFiles();
                      setState(() {});
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            SvgPicture.asset('assets/icons/pdf.svg'),
                            const Text('Choose A File',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                gap(40),
                const Text('Selected Documents',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                if (result != null)
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: result!.files.length,
                    separatorBuilder: (context, index) {
                      return gap(10);
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade300),
                            color: backgroundColor),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset('assets/icons/pdf_icon.svg'),
                                  horGap(20),
                                  Text(
                                    result!.files[index].name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  result!.files.removeAt(index);
                                  setState(() {});
                                },
                                child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.red),
                                    child: const Icon(FontAwesomeIcons.xmark,
                                        color: Colors.white)),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
              ]))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: fullWidthButton(
            buttonName: 'Upload',
            onTap: () {
              uploadImage(context, File(result!.paths[0]!),
                      '${baseUrl}upload_file.php')
                  .then((value) {
                if (value) {
                  Nav.push(context, const BankDetailsScreen());
                } else {
                  dialog(context, "Image upload unsuccessful!", () {
                    Nav.pop(context);
                  });
                }
              });
            }),
      ),
    );
  }

  Future<bool> uploadImage(
      BuildContext context, File file, String uploadUrl) async {
    loader(context);
    print(uploadUrl);

    debugPrint(file.path.split('/')[file.path.split('/').length - 1]);

    bool ck = false;
    final url = Uri.parse(uploadUrl);
    var request = http.MultipartRequest('POST', url);

    Prefs.getPrefs('loginId').then((loginId) {
      Prefs.getPrefs('token').then((token) {
        request.fields['fem_user_login_id'] = loginId!;
        request.fields['type'] = 'user';
        request.fields['mode'] = 'mobile';
        request.fields['access_token'] = token!;
        request.fields['submit_bank'] = 'Submit';
      });
    });

    var pic = await http.MultipartFile.fromPath("image", file.path);

    request.files.add(pic);
    var response = await request.send();

    debugPrint(response.stream.toString());
    debugPrint(response.statusCode.toString());

    var dt = await response.stream.bytesToString();

    debugPrint(dt);

    if (response.statusCode == 200) {
      ck = true;
    } else {
      ck = false;
    }
    Nav.pop(context);
    return ck;
  }
}
