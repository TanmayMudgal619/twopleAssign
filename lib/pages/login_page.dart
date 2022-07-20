import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twople/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final GlobalKey<FormState> _loginform = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> errors = GlobalKey<ScaffoldState>();

  bool working = false;
  Future<bool> login() async {
    if (_loginform.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _username.text,
          password: _password.text,
        );
        return true;
      } on FirebaseAuthException catch (e) {
        errors.currentState!.showSnackBar(
          const SnackBar(
              backgroundColor: Colors.white,
              content: ListTile(title: Text("Invalid Email/Password!"))),
        );
      }
    }
    return false;
  }

  Future<bool> signup() async {
    if (_loginform.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _username.text,
          password: _password.text,
        );
        if (await login()) {
          return true;
        }
      } on FirebaseAuthException catch (e) {
        errors.currentState!.showSnackBar(
          SnackBar(
              backgroundColor: Colors.white,
              content: ListTile(title: Text("Error: ${e.code}"))),
        );
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: errors,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _loginform,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _username,
                  enabled: !working,
                  validator: ((value) =>
                      (RegExp(r"^[A-Za-z0-9]+@[a-zA-Z]+\.[A-Za-z]+$")
                              .hasMatch(value.toString()))
                          ? null
                          : "Enter Valid Email"),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    hintText: "Email",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _password,
                  enabled: !working,
                  obscureText: true,
                  validator: (value) => (value == null || value.length < 5)
                      ? "Password Should atleast contain 5 Character"
                      : null,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    hintText: "Password",
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CupertinoButton(
                  color: Colors.black,
                  child: const Text("Sign In"),
                  onPressed: () {
                    if (!working) {
                      setState(() {
                        working = true;
                      });
                      login().then((value) {
                        if (value) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              (route) => false);
                        }
                        setState(() {
                          working = false;
                        });
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                CupertinoButton(
                  color: Colors.blue,
                  child: const Text("Sign Up"),
                  onPressed: () {
                    if (!working) {
                      setState(() {
                        working = true;
                      });
                      signup().then((value) {
                        if (!value) {
                          setState(() {
                            working = false;
                          });
                        } else {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              (route) => false);
                        }
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
