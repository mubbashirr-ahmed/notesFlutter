import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../provider/auth.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = 'signup_screen';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(
                'An Error Occured',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              content: Text(
                message,
                style: const TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: const Text('Sign Up')),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        height: double.infinity,
        color: Color.fromRGBO(206, 206, 206, 1),
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            Image.asset(
              "assets/images/logo.png",
              width: double.infinity,
              height: 250,
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Email'),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Password'),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Confirm Password'),
            ),
            const SizedBox(
              height: 30,
            ),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        _showErrorDialog('Password did not match');
                        return;
                      } else if (_emailController.text.isEmpty) {
                        _showErrorDialog('Missing fields');
                        return;
                      }
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        await Provider.of<Auth>(context, listen: false).signUp(
                            _emailController.text, _passwordController.text);
                        Navigator.of(context).pop();
                        Fluttertoast.showToast(
                            gravity: ToastGravity.BOTTOM,
                            msg: 'Signed Up Successfully',
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: Colors.black45,
                            textColor: Theme.of(context).primaryColor);
                      } on HttpException catch (error) {
                        var errorMessage = 'Authentication failed!';
                        if (error.toString().contains('EMAIL_EXISTS')) {
                          errorMessage = 'This email already exists';
                        } else if (error.toString().contains('INVALID_EMAIL')) {
                          errorMessage = 'This email is invalid';
                        } else if (error.toString().contains('WEAK_PASSWORD')) {
                          errorMessage = 'This password is weak';
                        }
                        _showErrorDialog(errorMessage);
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        fixedSize: const Size(120, 40),
                        backgroundColor:
                            Theme.of(context).appBarTheme.backgroundColor,
                        foregroundColor: Colors.white),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Already have an Account?',
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
