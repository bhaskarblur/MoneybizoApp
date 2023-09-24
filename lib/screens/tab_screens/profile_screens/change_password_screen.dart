import 'package:flutter/material.dart';
import 'package:money_bizo/api_services.dart';
import 'package:money_bizo/screens/authentication/register_screens/forgot_password.dart';
import '../../../widget/navigator.dart';
import '../../../widget/sahared_prefs.dart';
import '../../../widget/widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _oldPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _conPass = TextEditingController();

  bool vis1 = false;
  bool vis2 = false;
  bool vis3 = false;

  RegExp regExp = RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                const Text('Delivery Address',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            gap(20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Enter old password'),
              InkWell(
                onTap: () {
                  Nav.push(context, const ForgotPasswordScreen());
                },
                child: const Text('Forgot password?',
                    style: TextStyle(color: Colors.blue)),
              ),
            ]),
            gap(10),
            TextFormField(
              controller: _oldPass,
              obscureText: vis1,
              decoration: InputDecoration(
                  filled: true,
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        vis1 = !vis1;
                      });
                    },
                    child: Icon(vis1 ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black),
                  ),
                  fillColor: Colors.grey.shade300,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
            gap(10),
            const Text('Enter new password'),
            gap(10),
            TextFormField(
              controller: _newPass,
              obscureText: vis2,
              decoration: InputDecoration(
                  filled: true,
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        vis2 = !vis2;
                      });
                    },
                    child: Icon(vis2 ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black),
                  ),
                  fillColor: Colors.grey.shade300,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  )),
              validator: (value) {
                if (!regExp.hasMatch(value!)) {
                  return 'Password must meet the below conditions';
                } else {
                  return null;
                }
              },
            ),
            gap(10),
            const Text('Confirm new password'),
            gap(10),
            TextFormField(
              controller: _conPass,
              obscureText: vis3,
              decoration: InputDecoration(
                  filled: true,
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        vis3 = !vis3;
                      });
                    },
                    child: Icon(vis3 ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black),
                  ),
                  fillColor: Colors.grey.shade300,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  )),
              validator: (value) {
                if (value != _newPass.text) {
                  return 'Password does not mathch';
                } else {
                  return null;
                }
              },
            ),
            gap(20),
            const Text(
                'Your password must have at least 6 Characters including:1 uppercase, 1 lowercase, 1 Number Or symbol')
          ]),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: MediaQuery.of(context).viewInsets.bottom != 0.0
          ? gap(0)
          : Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    Prefs.getBool('company').then((company) {
                      Prefs.getPrefs('loginId').then((loginId) {
                        Prefs.getToken().then((token) {
                          _apiServices.post(
                              context: context,
                              endpoint: 'passwordresetAPI.php',
                              body: {
                                "old_password": _oldPass.text,
                                "fem_user_login_id": loginId,
                                "mode": "mobile",
                                "type": company! ? 'company' : 'user',
                                "new_password": _newPass.text,
                                "access_token": token
                              }).then((value) {
                            dialog(context, value['message'], () {
                              Nav.pop(context);
                            });
                          });
                        });
                      });
                    });
                  }
                },
                child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue),
                    child: const Center(
                      child: Text('Change Password',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    )),
              ),
            ),
    );
  }
}
