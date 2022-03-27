import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/main.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../data/network/FromData/User.dart';
import '../../../di/Modules.dart';
import '../../../domain/User.dart';
import '../../utile/FormValidator.dart';
import '../../utile/LangUtiles.dart';

class LoginByPhoneNumber extends ConsumerStatefulWidget {
  static String tag = 'login-by-phone';

  Function(bool isLoggedIn) loggedIn;

  LoginByPhoneNumber({Key? key, required this.loggedIn}) : super(key: key);

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginByPhoneNumber> {
  bool isCompleted = false;
  User? user;
  LoginForm form = LoginForm();
  LoginPageViewModel viewModel = LoginPageViewModel();
  final GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  final LoginForm _loginData = LoginForm();
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
    return SingleChildScrollView(
      child: Container(
        child: Center(
          child: Form(
            key: _key,
            autovalidateMode: _validate,
            child: _getFormUI(),
          ),
        ),
      ),
    );
  }

  Widget _getFormUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(
          Icons.person,
          color: Colors.lightBlue,
          size: 100.0,
        ),
        const SizedBox(height: 50.0),
        TextFormField(
          onChanged: ((text) => form.phoneNumber = text),
          keyboardType: TextInputType.phone,
          autofocus: false,
          decoration: InputDecoration(
            hintText: "phone number",
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          validator: FormValidator(context).validatePhone,
          onSaved: (String? value) {
            _loginData.phoneNumber = value!;
          },
        ),
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
      await viewModel.authByPhone(loginRequestData: form);

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
        {
          return const CircularProgressIndicator();
        }
      case Status.COMPLETED:
        {
          widget.loggedIn(true);
        }
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
