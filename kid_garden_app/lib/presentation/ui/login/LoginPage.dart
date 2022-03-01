import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/main.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import 'package:kid_garden_app/presentation/ui/splash/Splash.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../data/network/models/LoginRequestData.dart';
import '../../../domain/User.dart';
import '../../../providers/Providers.dart';
import '../../utile/FormValidator.dart';
import '../../utile/LangUtiles.dart';

class LoginPage extends ConsumerStatefulWidget {
  static String tag = 'login-page';

  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool isCompleted = false;
  User? user;
  var form =LoginRequestData();
  LoginPageViewModel viewModel = LoginPageViewModel();
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
    user = viewModel.currentUser;
    if (user != null) {
      // condition here
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, HomeScreenRoute);
      });
    }
    if (!isCompleted) {
      return SplashScreen(
        completed: () {
          if (mounted) {
            setState(() {
              isCompleted = true;
            });
          }
        },
      );
    } else {
      if (user == null) {
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
    }

    return Container();
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
          onChanged: ((text)=>form.email=text),

          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            hintText: StringResources.of(context)?.getText("email") ?? "Error",
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          validator: FormValidator(context).validateEmail,
          onSaved: (String? value) {
            _loginData.email = value!;
          },
        ),
        const SizedBox(height: 20.0),
        TextFormField(
          onChanged: ((text)=>form.password=text),
            autofocus: false,
            obscureText: _obscureText,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText:
                  StringResources.of(context)?.getText("password") ?? "Error",
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
            validator: FormValidator(context).validatePassword,
            onSaved: (String? value) {
              _loginData.password = value!;
            }),
        const SizedBox(height: 15.0),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0), child: body()),
      ],
    );
  }

  Widget loginButton() {
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
      child: Text(StringResources.of(context)?.getText("login") ?? "Error",
          style: TextStyle(color: Colors.white)),
    );
  }

  Future _sendToServer() async {
    if (_key.currentState!.validate()) {
      await viewModel.auth(loginRequestData: form);
      /// No any error in validation
      _key.currentState!.save();
    } else {
      ///validation error
      setState(() {
        _validate = AutovalidateMode.always;
      });
    }
  }

  Widget body() {
    var login = loginButton();
    switch (viewModel.userApiResponse.status) {
      case Status.LOADING:
        return const CircularProgressIndicator();
      case Status.COMPLETED:
        Future.delayed(Duration.zero, () async {
          Navigator.pushReplacementNamed(context, HomeScreenRoute);
        });

        break;
      case Status.ERROR:
        return login;
      case Status.NON:
        return login;
      default:
    }

    return const CircularProgressIndicator();
  }
}
