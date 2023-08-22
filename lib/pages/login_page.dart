import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:project1/appwrite/auth_api.dart';
import 'package:project1/pages/forgot_password_page.dart';
import 'package:project1/pages/message_page.dart';
import 'package:project1/pages/register_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  bool loading = false;

  signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  CircularProgressIndicator(),
                ]),
          );
        });

    try {
      final AuthAPI appwrite = context.read<AuthAPI>();
      await appwrite.createEmailSession(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      Navigator.pop(context);
    } on AppwriteException catch (e) {
      Navigator.pop(context);
      showAlert(title: 'Login failed', text: e.message.toString());
    }
  }

  showAlert({required String title, required String text}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }

  signInWithProvider(String provider) {
    try {
      context.read<AuthAPI>().signInWithProvider(provider: provider);
    } on AppwriteException catch (e) {
      showAlert(title: 'Login failed', text: e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: emailTextController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordTextController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  signIn();
                },
                icon: const Icon(Icons.login),
                label: const Text("Sign in"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPassword()));
                },
                child: const Text(
                  'Forgot Password',
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()));
                },
                child: const Text(
                  'Register',
                ),
              ),
              // const SizedBox(height: 16),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     ElevatedButton(
              //       onPressed: () => signInWithProvider('google'),
              //       style: ElevatedButton.styleFrom(
              //           foregroundColor: Colors.black,
              //           backgroundColor: Colors.white),
              //       child:
              //           SvgPicture.asset('assets/google_icon.svg', width: 12),
              //     ),
              //     ElevatedButton(
              //       onPressed: () => signInWithProvider('apple'),
              //       style: ElevatedButton.styleFrom(
              //           foregroundColor: Colors.black,
              //           backgroundColor: Colors.white),
              //       child: SvgPicture.asset('assets/apple_icon.svg', width: 12),
              //     ),
              //     ElevatedButton(
              //       onPressed: () => signInWithProvider('github'),
              //       style: ElevatedButton.styleFrom(
              //           foregroundColor: Colors.black,
              //           backgroundColor: Colors.white),
              //       child:
              //           SvgPicture.asset('assets/github_icon.svg', width: 12),
              //     ),
              //     ElevatedButton(
              //       onPressed: () => signInWithProvider('twitter'),
              //       style: ElevatedButton.styleFrom(
              //           foregroundColor: Colors.black,
              //           backgroundColor: Colors.white),
              //       child:
              //           SvgPicture.asset('assets/twitter_icon.svg', width: 12),
              //     )
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
