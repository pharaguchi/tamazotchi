import 'package:tamazotchi/config/color_constants.dart';
import 'package:tamazotchi/services/auth.dart';
import 'package:tamazotchi/components/loading.dart';
import 'package:tamazotchi/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:carousel_slider/carousel_slider.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  final nameController = TextEditingController();
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
                    Text("Welcome!",
                        style: TextStyle(color: Colors.black, fontSize: 30.0)),
                    SizedBox(height: 40.0),
                    TextFormField(
                      style: TextStyle(color: Colors.brown, fontSize: 14.0),
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Name'),
                      validator: (val) => val != null && val.isEmpty
                          ? 'Please enter a valid name'
                          : null,
                      controller: nameController,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      style: TextStyle(color: Colors.brown, fontSize: 14.0),
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Email'),
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
                          ? 'Your password must be 6 or more characters long'
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
                            'Create Account',
                            style:
                                TextStyle(color: Colors.brown, fontSize: 14.0),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            if (!mounted) {
                              return;
                            }
                            setState(() => loading = true);
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    nameController.text,
                                    emailController.text,
                                    passwordController.text);
                            if (result is firebase_auth.FirebaseAuthException) {
                              if (result.code == 'email-already-in-use') {
                                setState(() {
                                  loading = false;
                                  error =
                                      'Email is already in use by another account.';
                                });
                              } else {
                                if (!mounted) {
                                  return;
                                }
                                setState(() {
                                  loading = false;
                                  error =
                                      'Please supply a valid email and password.';
                                });
                              }
                            } else {
                              if (!mounted) {
                                return;
                              }
                              setState(() {
                                loading = false;
                                error =
                                    'An error occurred during registration.';
                              });
                            }
                          }
                        }),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    SizedBox(height: 5.0),
                    TextButton(
                      child: Text(
                        'Already have an account? Log In',
                        style: TextStyle(color: Colors.black, fontSize: 12.0),
                      ),
                      onPressed: () => widget.toggleView(),
                    ),
                    SizedBox(height: 35.0),
                    CarouselSlider(
                      items: List.generate(tamagotchiNames.length, (index) {
                          return 'assets/Tamagotchi/${tamagotchiNames[index]}.webp';
                        }).map((path) {
                        return Image.asset(path,
                        fit: BoxFit.contain,
                        width: MediaQuery.of(context).size.width,
                      );
                    }).toList(), 
                      options: CarouselOptions(
                        height: 175.0,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 2),
                        enlargeCenterPage: false,
                        aspectRatio: 1 / 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
