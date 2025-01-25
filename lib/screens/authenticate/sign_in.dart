import 'package:tamazotchi/services/auth.dart';
import 'package:tamazotchi/config/constants.dart';
import 'package:tamazotchi/components/loading.dart';
import 'package:tamazotchi/config/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Text("Hello Again!",
                        style: TextStyle(color: Colors.black, fontSize: 30.0)),
                    SizedBox(height: 40.0),
                    TextFormField(
                      style: TextStyle(color: Colors.brown, fontSize: 14.0),
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Your email'),
                      validator: (val) => val != null && val.isEmpty
                          ? 'Please enter a valid email'
                          : null,
                      controller: emailController,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      style: TextStyle(color: Colors.brown, fontSize: 14.0),
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Password'),
                      obscureText: true,
                      validator: (val) => val != null && val.length < 6
                          ? 'Please enter a valid password'
                          : null,
                      controller: passwordController,
                    ),
                    SizedBox(height: 30.0),
                    TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20.0),
                          child: Text(
                            'Sign In',
                            style:
                                TextStyle(color: Colors.black, fontSize: 14.0),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            if (!mounted) {
                              return;
                            }
                            setState(() => loading = true);
                            dynamic result =
                                await _auth.signInWithEmailAndPassword(
                                    emailController.text,
                                    passwordController.text);
                            if (result is firebase_auth.FirebaseAuthException) {
                              if (!mounted) {
                                return;
                              }
                              setState(() {
                                loading = false;
                                error =
                                    'The email and password combination is incorrect.';
                              });
                            }
                          }
                        }),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    TextButton(
                      child: Text(
                        'Don\'t have an account? Sign Up',
                        style: TextStyle(color: Colors.black, fontSize: 12.0),
                      ),
                      onPressed: () => widget.toggleView(),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
