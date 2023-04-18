import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haven_admin/Firebase/auth.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = "", _password = "";
  String? _emailErrorText, _passwordErrorText;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 3.5;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(26.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: width,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        errorText: _emailErrorText,
                        prefixIcon: Icon(Icons.email),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        _email = value;
                        setState(() {
                          _emailErrorText = null;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: width,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.key),
                        fillColor: Colors.white,
                        errorText: _passwordErrorText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      onChanged: (value) {
                        _password = value;
                        setState(() {
                          _passwordErrorText = null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: width,
                    child: RoundedLoadingButton(
                      controller: _btnController,
                      animateOnTap: false,
                      borderRadius:
                          _btnController.currentState == ButtonState.loading
                              ? 26
                              : 10,
                      child: const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Center(
                          child: Text("Continue"),
                        ),
                      ),
                      onPressed: () async {
                        if (!validate()) {
                          return;
                        }
                        setState(() {});
                        _btnController.start();
                        var response = await signInUser(_email, _password);
                        switch (response) {
                          case Code.weakPassword:
                            // Not possible.
                            break;
                          case Code.emailInUse:
                            // Not possible.
                            break;
                          case Code.successful:
                            _btnController.success();
                            break;
                          case Code.unknownError:
                            _btnController.stop();
                            setState(() {});
                            Fluttertoast.showToast(
                                msg: "An unkonw error has occurred");
                            break;
                          case Code.userNotFound:
                            _btnController.stop();
                            setState(() {
                              _emailErrorText =
                                  "You don't seem to have an account";
                            });
                            break;
                          case Code.wrongPassword:
                            _btnController.stop();
                            setState(() {
                              _passwordErrorText = "Incorrect password";
                            });
                            break;
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    if (_email.trim().isEmpty) {
      setState(() {
        _emailErrorText = "Please enter your email";
      });
      return false;
    } else if (_password.trim().isEmpty) {
      setState(() {
        _passwordErrorText = "Please enter your password";
      });
      return false;
    }
    return true;
  }
}
