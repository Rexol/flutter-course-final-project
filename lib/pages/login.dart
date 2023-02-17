import 'package:flutter/material.dart';

class _EmailInput extends StatelessWidget {
  @override
  const _EmailInput({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Email',
            hintText: 'Enter valid email id as abc@gmail.com'),
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  const _PasswordInput({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
      //padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
          hintText: 'Enter secure password',
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.only(top: 60.0),
          //   child: Center(
          //     child: Container(
          //       width: 200,
          //       height: 150,
          //       /*decoration: BoxDecoration(
          //               color: Colors.red,
          //               borderRadius: BorderRadius.circular(50.0)),*/
          //     ),
          //   ),
          // ),
          _EmailInput(controller: emailController),
          _PasswordInput(controller: passwordController),
          TextButton(
            onPressed: () {
              //TODO FORGOT PASSWORD SCREEN GOES HERE
            },
            child: Text(
              'Forgot Password',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20)),
            child: TextButton(
              onPressed: () {
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (_) => HomePage()));
              },
              style: Theme.of(context).textButtonTheme.style,
              child: Text(
                'Login',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          SizedBox(
            height: 130,
          ),
          Text('New User? Create Account')
        ],
      ),
    );
  }
}
