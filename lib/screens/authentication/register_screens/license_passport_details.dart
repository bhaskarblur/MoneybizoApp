import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/screens/authentication/register_screens/upload_bank_statement.dart';
import 'package:money_bizo/widget/navigator.dart';
import '../../../app_config/colors.dart';
import '../../../widget/sahared_prefs.dart';
import '../../../widget/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8, base64;

class LicensePassportScreen extends StatefulWidget {
  final String? documentType;
  const LicensePassportScreen({super.key, this.documentType});

  @override
  State<LicensePassportScreen> createState() => _LicensePassportScreenState();
}

class _LicensePassportScreenState extends State<LicensePassportScreen> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _givenName = TextEditingController();
  final TextEditingController _middleName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _licenseNumber = TextEditingController();
  final TextEditingController _licenseVersion = TextEditingController();
  final TextEditingController _passportNumber = TextEditingController();
  final TextEditingController _passportExpiry = TextEditingController();
  final TextEditingController _addressLine1 = TextEditingController();
  final TextEditingController _addressLine2 = TextEditingController();
  final TextEditingController _suburb = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _country = TextEditingController();
  final TextEditingController _date = TextEditingController();

  String numberOfChildren = 'Select';
  String maritalStatus = 'Select';
  String employmentStatus = 'Select';
  String gender = 'Select';

  bool checkBox1 = false;
  bool checkBox2 = false;

  void centrix() async {
    // var envelope = '''
    //               <?xml version="1.0" encoding="utf-8"?>
    //                 <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cen="http://centrix.co.nz">
    //                   <soapenv:Header/>
    //                   <soapenv:Body>
    //                     <cen:GetCreditReportProducts>
    //                       <cen:CreditReportProductsRequest>
    //                         <cen:Credentials>
    //                           <cen:SubscriberID>OPIW</cen:SubscriberID>
    //                           <cen:UserID>opiwb2buser</cen:UserID>
    //                           <cen:UserKey>TpyE7QJXP3DKPxTWDjhAmxGh</cen:UserKey>
    //                         </cen:Credentials>
    //                         <cen:ServiceProducts>
    //                           <cen:ServiceProduct>
    //                             <cen:ProductCode>SmartID</cen:ProductCode>
    //                           </cen:ServiceProduct>
    //                         </cen:ServiceProducts>
    //                         <cen:RequestDetails>
    //                           <cen:EnquiryReason>IDVF</cen:EnquiryReason>
    //                           <cen:SubscriberReference>DIA1</cen:SubscriberReference>
    //                         </cen:RequestDetails>
    //                         <cen:DriverLicence>
    //                           <cen:DriverLicenceNumber>${_licenseNumber.text}</cen:DriverLicenceNumber>
    //                           <cen:DriverLicenceVersion>${_licenseVersion.text}</cen:DriverLicenceVersion>
    //                         </cen:DriverLicence>
    //                         <cen:ConsumerData>
    //                           <cen:Personal>
    //                             <cen:Surname>${_lastName.text}</cen:Surname>
    //                             <cen:FirstName>${_givenName.text}</cen:FirstName>
    //                             <cen:MiddleName>${_middleName.text}</cen:MiddleName>
    //                             <cen:DateOfBirth>1975-11-03</cen:DateOfBirth>
    //                       <cen:Gender>Male</cen:Gender>
    //                           </cen:Personal>
    //                           <cen:Addresses>
    //                             <cen:Address>
    //                               <cen:AddressType>AV</cen:AddressType>
    //                               <cen:AddressLine1>${_addressLine1.text}</cen:AddressLine1>
    //                               <cen:AddressLine2>${_addressLine2.text}</cen:AddressLine2>
    //                               <cen:Suburb>${_suburb.text}</cen:Suburb>
    //                               <cen:City>${_city.text}</cen:City>
    //                               <cen:Country>NZL</cen:Country>
    //                               <cen:Postcode></cen:Postcode>
    //                             </cen:Address>
    //                           </cen:Addresses>
    //                           <cen:Passport>
    //                             <cen:PassportNumber>${_passportNumber.text}</cen:PassportNumber>
    //                             <cen:Expiry>${_passportExpiry.text}</cen:Expiry>
    //                           </cen:Passport>
    //                         </cen:ConsumerData>
    //                         <cen:Consents>
    //                           <cen:Consent>
    //                             <cen:Name>DIAPassportVerification</cen:Name>
    //                             <cen:ConsentGiven>1</cen:ConsentGiven>
    //                           </cen:Consent>
    //                         </cen:Consents>
    //                       </cen:CreditReportProductsRequest>
    //                     </cen:GetCreditReportProducts>
    //                   </soapenv:Body>
    //                 </soapenv:Envelope>
    //               ''';

    var envelope;

    if(widget.documentType=='license') {
      envelope = '''<?xml version="1.0" encoding="utf-8"?>
                    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cen="http://centrix.co.nz">
                      <soapenv:Header/>
                      <soapenv:Body>
                        <cen:GetCreditReportProducts>
                          <cen:CreditReportProductsRequest>
                            <cen:Credentials>
                              <cen:SubscriberID>OPIW</cen:SubscriberID>
                              <cen:UserID>opiwb2buser</cen:UserID>
                              <cen:UserKey>TpyE7QJXP3DKPxTWDjhAmxGh</cen:UserKey>
                            </cen:Credentials>
                            <cen:ServiceProducts>
                              <cen:ServiceProduct>
                                <cen:ProductCode>SmartID</cen:ProductCode>
                              </cen:ServiceProduct>
                            </cen:ServiceProducts>
                            <cen:RequestDetails>
                              <cen:EnquiryReason>IDVF</cen:EnquiryReason>
                              <cen:SubscriberReference>DIA1</cen:SubscriberReference>
                            </cen:RequestDetails>
                            <cen:DriverLicence>
                              <cen:DriverLicenceNumber>${_licenseNumber.text}</cen:DriverLicenceNumber> 
                              <cen:DriverLicenceVersion>${_licenseVersion.text}</cen:DriverLicenceVersion> 
                            </cen:DriverLicence>
                            <cen:ConsumerData>
                              <cen:Personal>
                                <cen:Surname>${_lastName.text}</cen:Surname> 
                                <cen:FirstName>${_givenName.text}</cen:FirstName>
                                <cen:MiddleName>${_middleName.text}</cen:MiddleName>
                                <cen:DateOfBirth>${_date.text}</cen:DateOfBirth>
                          <cen:Gender>${gender}</cen:Gender> 
                              </cen:Personal>
                              <cen:Addresses>
                                <cen:Address>
                                  <cen:AddressType>AV</cen:AddressType> 
                                  <cen:AddressLine1>${_addressLine1.text}</cen:AddressLine1>
                                  <cen:AddressLine2>${_addressLine2.text}</cen:AddressLine2>
                                  <cen:Suburb>${_suburb.text}</cen:Suburb>
                                  <cen:City>${_city.text}</cen:City>
                                  <cen:Country>NZL</cen:Country>
                                  <cen:Postcode></cen:Postcode>
                                </cen:Address>
                              </cen:Addresses>
                            </cen:ConsumerData>
                            <cen:Consents>
                              <cen:Consent>
                                <cen:Name>DIAPassportVerification</cen:Name>
                                <cen:ConsentGiven>1</cen:ConsentGiven>
                              </cen:Consent>
                            </cen:Consents>
                          </cen:CreditReportProductsRequest>
                        </cen:GetCreditReportProducts>
                      </soapenv:Body>
                    </soapenv:Envelope>
                  ''';
    }
    else {
      envelope = '''<?xml version="1.0" encoding="utf-8"?>
                    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cen="http://centrix.co.nz">
                      <soapenv:Header/>
                      <soapenv:Body>
                        <cen:GetCreditReportProducts>
                          <cen:CreditReportProductsRequest>
                            <cen:Credentials>
                              <cen:SubscriberID>OPIW</cen:SubscriberID>
                              <cen:UserID>opiwb2buser</cen:UserID>
                              <cen:UserKey>TpyE7QJXP3DKPxTWDjhAmxGh</cen:UserKey>
                            </cen:Credentials>
                            <cen:ServiceProducts>
                              <cen:ServiceProduct>
                                <cen:ProductCode>SmartID</cen:ProductCode>
                              </cen:ServiceProduct>
                            </cen:ServiceProducts>
                            <cen:RequestDetails>
                              <cen:EnquiryReason>IDVF</cen:EnquiryReason>
                              <cen:SubscriberReference>DIA1</cen:SubscriberReference>
                            </cen:RequestDetails>
                            <cen:ConsumerData>
                              <cen:Personal>
                                <cen:Surname>${_lastName.text}</cen:Surname> 
                                <cen:FirstName>${_givenName.text}</cen:FirstName>
                                <cen:MiddleName>${_middleName.text}</cen:MiddleName>
                                <cen:DateOfBirth>${_date.text}</cen:DateOfBirth>
                          <cen:Gender>${gender}</cen:Gender> 
                              </cen:Personal>
                              <cen:Addresses>
                                <cen:Address>
                                  <cen:AddressType>AV</cen:AddressType> 
                                  <cen:AddressLine1>${_addressLine1.text}</cen:AddressLine1>
                                  <cen:AddressLine2>${_addressLine2.text}</cen:AddressLine2>
                                  <cen:Suburb>${_suburb.text}</cen:Suburb>
                                  <cen:City>${_city.text}</cen:City>
                                  <cen:Country>NZL</cen:Country>
                                  <cen:Postcode></cen:Postcode>
                                </cen:Address>
                              </cen:Addresses>
                              <cen:Passport>
                                <cen:PassportNumber>${_passportNumber.text}</cen:PassportNumber> 
                                <cen:Expiry>${_passportExpiry.text}</cen:Expiry> 
                              </cen:Passport>
                            </cen:ConsumerData>
                            <cen:Consents>
                              <cen:Consent>
                                <cen:Name>DIAPassportVerification</cen:Name>
                                <cen:ConsentGiven>1</cen:ConsentGiven>
                              </cen:Consent>
                            </cen:Consents>
                          </cen:CreditReportProductsRequest>
                        </cen:GetCreditReportProducts>
                      </soapenv:Body>
                    </soapenv:Envelope>
                  ''';
    }


    http.Response response = await http.post(
        Uri.parse('https://test2.centrix.co.nz/v16/Consumers.svc?singlewsdl='),
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "Host": "test2.centrix.co.nz",
          "Content-Length": envelope.toString().length.toString(),
          "Authorization": "Basic "+base64.encode(utf8.encode("opiweb:CZQ76wUrDVvB")),
          "SOAPAction": "http://centrix.co.nz/IConsumers/GetCreditReportProducts",
        },
        body: envelope);


    print(widget.documentType);
    // Use the xml package's 'parse' method to parse the response.
    // xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);


    var response_got =response.body.toString();
 // print(response.body);
  log(response.body);

    print(response_got.contains("<IsSuccess>true</IsSuccess>"));

    if(response_got.contains("<IsSuccess>true</IsSuccess>")) {
    if(response_got.contains("<DIAPassportVerified>true</DIAPassportVerified>")
    || response_got.contains("<DIAPassportVerified>true</DIAPassportVerified>") ) {
      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getDeviceToken().then((deviceToken) {
          _apiServices.post(
              context: context,
              endpoint: 'registerUsers.php',
              body: {
                "mode": "mobile",
                "submit": "Confirm",
                "fem_user_login_id": loginId,
                "firstname": _givenName.text,
                "middlename": _middleName.text,
                "lastname": _lastName.text,
                "gender": gender,
                "gene_street": _addressLine1.text,
                "gene_suburb": _suburb.text,
                "gene_city": _city.text,
                "gene_country": _country.text,
                "birth_day": _date.toString().substring(8,9),
                "birth_month": _date.toString().substring(5,6),
                "birth_year":_date.toString().substring(0,3).toString(),
                "email_offers": "",
                "passport_number": _passportNumber.text,
                "passport_expiry": _passportExpiry.text,
                "licence_number": _licenseNumber.text,
                "licence_version": _licenseVersion.text,
                "how_many_children": numberOfChildren,
                "marital_status": maritalStatus,
                "employment_status": employmentStatus,
                "device_token": deviceToken,
                "device_type":
                Platform.isIOS ? 'ios' : 'android',
                "type": "user",
                "register_step": "5"
              }).then((value) {
            if (value['status'] == 200) {
              Nav.push(
                  context, const UploadBankStatement());
              Prefs.setPrefs(
                  'token', value['access_token']);
              Prefs.setPrefs('loginId',
                  value['fem_user_login_id']);
              Prefs.setBool('company', false);
            } else {
              dialog(context,
                  value['error'] ?? value['message'],
                      () {
                    Nav.pop(context);
                  });
            }
          });
        });
      });
    }
    else {
      dialog(context, 'Incorrect details, please check the values.', () {
        Nav.pop(context);
      });
    }
    }
    else {
      dialog(context, 'Incorrect details, please check the values.', () {
        Nav.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    const Text('Enter Your Details',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    gap(10),
                    const Text(
                        'Please ensure all details are entered correctly and identical to the original document'),
                    gap(20),
                    customTextField(_givenName, 'Given Name',
                        fillColor: backgroundColor),
                    gap(10),
                    customTextField(_middleName, 'Middle Name',
                        fillColor: backgroundColor),
                    gap(10),
                    customTextField(_lastName, 'Last Name',
                        fillColor: backgroundColor),
                    gap(10),
                    customTextField3(_date, 'Date of Birth (YYYY-MM-DD)',
                        fillColor: backgroundColor),
                    gap(10),
                    widget.documentType == 'license'
                        ? Column(children: [
                      customTextField(_licenseNumber, 'License Number',
                          fillColor: backgroundColor),
                      gap(10),
                      customTextField2(_licenseVersion, 'License Version',
                          fillColor: backgroundColor),
                    ])
                        : Column(children: [
                      customTextField(_passportNumber, 'Passport Number',
                          fillColor: backgroundColor),
                      gap(10),
                      customTextField3(
                          _passportExpiry, 'Passport Expiry Date (YYYY-MM-DD)',
                          fillColor: backgroundColor),
                    ]),
                    gap(10),
                    customTextField(_addressLine1, 'Address Line 1',
                        fillColor: backgroundColor),
                    gap(10),
                    customTextField(_addressLine2, 'Address Line 2',
                        fillColor: backgroundColor),
                    gap(10),
                    customTextField(_suburb, 'Suburb',
                        fillColor: backgroundColor),
                    gap(10),
                    customTextField(_city, 'City', fillColor: backgroundColor),
                    gap(10),
                    customTextField(_country, 'Country',
                        fillColor: backgroundColor),
                    gap(20),
                    const Text('Gender',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                    gap(10),
                    customDropdown(
                        value: gender,
                        items: ['Select', 'Male', 'Female'],
                        onChanged: (value) {
                          setState(() {
                            gender = value!;
                          });
                        }),
                    gap(20),
                    const Text('Number of Children You Have',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                    gap(10),
                    customDropdown(
                        value: numberOfChildren,
                        items: [
                          'Select',
                          '0',
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                          '9',
                          '10',
                          '11',
                          '12',
                          '13',
                          '14',
                          '15',
                        ],
                        onChanged: (value) {
                          setState(() {
                            numberOfChildren = value!;
                          });
                        }),
                    gap(20),
                    const Text('Marital Status',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                    gap(10),
                    customDropdown(
                        value: maritalStatus,
                        items: ['Select', 'Married', 'Single'],
                        onChanged: (value) {
                          setState(() {
                            maritalStatus = value!;
                          });
                        }),
                    gap(20),
                    const Text('Employment Status',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                    gap(10),
                    customDropdown(
                        value: employmentStatus,
                        items: ['Select', 'Employed', 'Unemployed'],
                        onChanged: (value) {
                          setState(() {
                            employmentStatus = value!;
                          });
                        }),
                    gap(30),
                    const Text("Confirm You've Read Out T&Cs.",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    gap(10),
                    Text("By Clicking 'Confirm'",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600)),
                    gap(20),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                              activeColor: primaryColor,
                              value: checkBox1,
                              onChanged: (value) {
                                setState(() {
                                  checkBox1 = value!;
                                });
                              }),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "I consent to Moneybizo disclosing my personal information to credit reporting bodies or agencies externally in order to verify my identity as required by Law. I acknowledge that Moneybizo handles my personal information in accordance with its Terms and Conditions and Privacy Policy.",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade500),
                              ),
                            ),
                          )
                        ]),
                    gap(20),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                              activeColor: primaryColor,
                              value: checkBox2,
                              onChanged: (value) {
                                setState(() {
                                  checkBox2 = value!;
                                });
                              }),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "I confirm that:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade500),
                                  ),
                                  gap(10),
                                  bulletLine('I am 18 years of age or older'),
                                  bulletLine('I am permanent resident of NZ;'),
                                  bulletLine(
                                      'I am not an undischarged bankrupt or have reason to believe I am or may become insolvent.'),
                                ],
                              ),
                            ),
                          )
                        ]),
                    gap(30),
                    fullWidthButton(
                        buttonName: 'Confirm',
                        onTap: () {
                          if (checkBox1 && checkBox2) {
                            if (_givenName.text.isNotEmpty &&
                                _lastName.text.isNotEmpty &&
                                _licenseNumber.text.isNotEmpty ||
                                _licenseVersion.text.isNotEmpty ||
                                _passportNumber.text.isNotEmpty ||
                                _passportExpiry.text.isNotEmpty ||
                                _addressLine1.text.isNotEmpty &&
                                _addressLine2.text.isNotEmpty &&
                                _suburb.text.isNotEmpty &&
                                _city.text.isNotEmpty &&
                                _country.text.isNotEmpty) {

                                centrix();

                            } else {
                              dialog(context, 'Enter all information.', () {
                                Nav.pop(context);
                              });
                            }
                          } else {
                            dialog(context, 'Check the conditions', () {
                              Nav.pop(context);
                            });
                          }
                        }),
                    gap(20),
                  ]),
            )));
  }

  Widget bulletLine(String text) {
    return Column(
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Container(
                height: 5,
                width: 5,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey.shade500)),
          ),
          horGap(5),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey.shade500),
            ),
          )
        ]),
        gap(3)
      ],
    );
  }

  Widget customDropdown(
      {String? value, List<String>? items, void Function(String?)? onChanged}) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          elevation: 0,
          underline: gap(0),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500),
          items: items!.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}