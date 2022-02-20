import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/main.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';

import '../../../data/network/ApiResponse.dart';
import '../../../data/network/models/LoginRequestData.dart';
import '../../../domain/User.dart';
import '../../../providers/Providers.dart';
import '../../FormValidator.dart';

class LoginPage extends ConsumerStatefulWidget {
  static String tag = 'login-page';

  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late LoginPageViewModel viewModel;
  final GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  final LoginRequestData _loginData = LoginRequestData();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = ref.watch(LoginPageViewModelProvider);

    viewModel.getUserChanges();
    var user = viewModel.currentUser;
    if (user != null) {
      Future.delayed(Duration.zero, () async {
        Navigator.pushReplacementNamed(context, HomeScreenRoute);
      });
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: Center(
              child: Form(
                key: _key,
                autovalidateMode: _validate,
                child: _getFormUI(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getFormUI() {
    return Column(
      children: <Widget>[
        const Icon(
          Icons.person,
          color: Colors.lightBlue,
          size: 100.0,
        ),
        const SizedBox(height: 50.0),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Email',
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          validator: FormValidator().validateEmail,
          onSaved: (String? value) {
            _loginData.email = value!;
          },
        ),
        const SizedBox(height: 20.0),
        TextFormField(
            autofocus: false,
            obscureText: _obscureText,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Password',
              contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  semanticLabel:
                      _obscureText ? 'show password' : 'hide password',
                ),
              ),
            ),
            validator: FormValidator().validatePassword,
            onSaved: (String? value) {
              _loginData.password = value!;
            }),
        const SizedBox(height: 15.0),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0), child: body()),
        TextButton(
          child: const Text(
            'Forgot password?',
            style: TextStyle(color: Colors.black54),
          ),
          onPressed: _showForgotPasswordDialog,
        ),
        TextButton(
          onPressed: _sendToRegisterPage,
          child: const Text('Not a member? Sign up now',
              style: TextStyle(color: Colors.black54)),
        ),
      ],
    );
  }

  Widget LoginButton() {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  side: const BorderSide(color: Colors.lightBlueAccent)))),
      onPressed: () async {
        await _sendToServer();
      },
      child: const Text('Log In', style: TextStyle(color: Colors.white)),
    );
  }

  _sendToRegisterPage() {
    ///Go to register page
  }

  Future _sendToServer() async {
    if (_key.currentState!.validate()) {
      await viewModel.auth(loginRequestData: LoginRequestData());

      /// No any error in validation
      _key.currentState!.save();
    } else {
      ///validation error
      setState(() {
        _validate = AutovalidateMode.always;
      });
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Please enter your eEmail'),
            contentPadding: const EdgeInsets.all(5.0),
            content: TextField(
              decoration: const InputDecoration(hintText: "Email"),
              onChanged: (String value) {
                _loginData.email = value;
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Ok"),
                onPressed: () async {
                  _loginData.email = "";
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  Widget body() {
    var loginButton = LoginButton();
    switch (viewModel.userApiResponse.status) {
      case Status.LOADING:
        return const CircularProgressIndicator();
      case Status.COMPLETED:
        Future.delayed(Duration.zero, () async {
          Navigator.pushReplacementNamed(context, HomeScreenRoute);
        });

        break;
      case Status.ERROR:
        return loginButton;
      case Status.NON:
        return loginButton;
      default:
    }

    return const CircularProgressIndicator();
  }
}
