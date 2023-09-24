import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_bizo/screens/authentication/register_screens/signature_screen.dart';
import 'package:money_bizo/screens/tab_screens/tab_screen.dart';

import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/sahared_prefs.dart';
import '../../../widget/widgets.dart';
import 'package:http/http.dart' as http;

class UploadDocument extends StatefulWidget {
  const UploadDocument({super.key});

  @override
  State<UploadDocument> createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
  String selectedValue = '';

  FilePickerResult? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        statusBar(context),
                        Center(
                          child: SizedBox(
                              width: 100,
                              child:
                                  Image.asset('assets/icons/banner_icon.png')),
                        ),
                        gap(10),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Nav.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back, size: 30)),
                            const Text('Upload Document',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        gap(10),
                        DottedBorder(
                          color: Colors.grey.shade600,
                          strokeWidth: 1,
                          dashPattern: const [10, 10],
                          child: InkWell(
                            onTap: () async {
                              result = await FilePicker.platform.pickFiles();
                              setState(() {});
                            },
                            child: Container(
                              color: Colors.white,
                              width: double.infinity,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 80),
                                child: Text('Pick your signed file here',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                        gap(30),
                        if (result != null)
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey.shade300),
                                color: backgroundColor),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/pdf_icon.svg'),
                                      horGap(20),
                                      Text(
                                        result!.files[0].name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      result = null;
                                      setState(() {});
                                    },
                                    child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.red),
                                        child: const Icon(
                                            FontAwesomeIcons.xmark,
                                            color: Colors.white)),
                                  )
                                ],
                              ),
                            ),
                          )
                      ]),
                ),
                Column(children: [
                  fullWidthButton(
                      buttonName: 'Upload',
                      onTap: () {
                        if (result == null) {
                          dialog(context, 'Pick Signed PDF', () {
                            Nav.pop(context);
                          });
                        } else {
                          loader(context);
                          uploadImage(context, File(result!.paths[0]!),
                                  'http://testingprowze.prowzer.co.nz/upload_file.php')
                              .then((value) {
                            Nav.pop(context);
                            if (value) {
                              Nav.push(context, const TabScreen());
                            } else {
                              dialog(context, 'Something went wrong', () {
                                Nav.pop(context);
                              });
                            }
                          });
                          result = null;
                        }
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Row(children: [
                      const Expanded(
                          child: DottedLine(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        lineLength: double.infinity,
                        dashColor: Colors.black,
                      )),
                      horGap(10),
                      const Text('OR',
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                      horGap(10),
                      const Expanded(
                          child: DottedLine(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        lineLength: double.infinity,
                        dashColor: Colors.black,
                      )),
                    ]),
                  ),
                  fullWidthButton(
                      buttonName: 'Upload Signature',
                      onTap: () {
                        Nav.push(context, const DrawingBoard());
                      }),
                ])
              ],
            )));
  }

  progressLoader(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: primaryColor,
            contentPadding: const EdgeInsets.all(15),
            content: const Row(
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(width: 20),
                Text('Downloading...',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))
              ],
            ),
          );
        });
  }

  Future<bool> uploadImage(
      BuildContext context, File file, String uploadUrl) async {
    print(uploadUrl);

    debugPrint(file.path.split('/')[file.path.split('/').length - 1]);

    bool ck = false;
    final url = Uri.parse(uploadUrl);
    var request = http.MultipartRequest('POST', url);

    Prefs.getPrefs('loginId').then((loginId) {
      Prefs.getPrefs('token').then((token) {
        request.fields['mode'] = 'mobile';
        request.fields['submit_bank'] = 'Submit';
        request.fields['fem_user_login_id'] = loginId!;
        request.fields['access_token'] = token!;
        request.fields['type'] = 'user';
      });
    });

    var pic = await http.MultipartFile.fromPath("signature", file.path);

    request.files.add(pic);
    var response = await request.send();

    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      ck = true;
    } else {
      ck = false;
    }
    return ck;
  }
}
