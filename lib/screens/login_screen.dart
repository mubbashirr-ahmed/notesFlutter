import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes_app/models/http_exception.dart';
import 'package:notes_app/provider/auth.dart';
import 'package:notes_app/screens/notes_screen.dart';
import 'package:provider/provider.dart';
import './signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
        title: const Center(child: const Text('Login')),
        foregroundColor: Colors.white,
      ),
      body: Container(
        height: double.infinity,
        color: Color.fromRGBO(206, 206, 206, 1),
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                  height: 30,
                ),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          if (_emailController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            _showErrorDialog('Missing fields');
                            return;
                          }
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await Provider.of<Auth>(context, listen: false)
                                .login(_emailController.text,
                                    _passwordController.text);
                            Navigator.of(context)
                                .pushReplacementNamed(NotesScreen.routeName);
                            Fluttertoast.showToast(
                                gravity: ToastGravity.BOTTOM,
                                msg: 'Loged in Successfully',
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor: Colors.black45,
                                textColor: Theme.of(context).primaryColor);
                          } on HttpException catch (error) {
                            print(error);
                            var errorMessage = 'Authentication failed!';
                            if (error.toString().contains('INVALID_EMAIL')) {
                              errorMessage = 'This email is invalid';
                            } else if (error
                                .toString()
                                .contains('EMAIL_NOT_FOUND')) {
                              errorMessage = 'This email not found';
                            } else if (error
                                .toString()
                                .contains('INVALID_PASSWORD')) {
                              errorMessage = 'You entered invalid password';
                            }
                            _showErrorDialog(errorMessage);
                          } catch (error) {
                            const errorMessage =
                                'Could not Autahenticate you, Please try again later!';
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
                          'Login',
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
                      'Don\'t have an Account?',
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(SignupScreen.routeName);
                      },
                      child: Text(
                        'Sign Up',
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
