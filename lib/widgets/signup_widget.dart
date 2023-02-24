import 'package:final_project/main.dart';
import 'package:final_project/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Enter email adress';
  }
  String emailRe =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  if (!RegExp(emailRe).hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
}

class SignUpWidget extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const SignUpWidget({
    super.key,
    required this.onClickedSignIn,
  });

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget _emailInput() {
    return Padding(
      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: emailController,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Email',
            hintText: 'Enter valid email as abc@example.com'),
        inputFormatters: [
          FilteringTextInputFormatter.singleLineFormatter,
        ],
        validator: validateEmail,
      ),
    );
  }

  Widget _passwordInput() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
      //padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
          hintText: 'Enter secure password',
        ),
        inputFormatters: [
          FilteringTextInputFormatter.singleLineFormatter,
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter the password';
          }
          if (value.length < 6) {
            return 'Password should be at least 6 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _repeatPasswordInput() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
      //padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
          hintText: 'Enter secure password',
        ),
        inputFormatters: [
          FilteringTextInputFormatter.singleLineFormatter,
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter the password again';
          }
          if (value != passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }

  Widget _signupButton() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
      //padding: EdgeInsets.symmetric(horizontal: 15),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
        ),
        icon: const Icon(Icons.lock_open, size: 32),
        onPressed: signUp,
        label: const Text(
          'Sign Up',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: [
                _emailInput(),
                _passwordInput(),
                _repeatPasswordInput(),
                _signupButton(),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              text: 'Already have and account?  ',
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = widget.onClickedSignIn,
                  text: 'Sign In',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
