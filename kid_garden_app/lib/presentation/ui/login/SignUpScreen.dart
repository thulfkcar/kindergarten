import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/network/ApiResponse.dart';
import '../../../data/network/FromData/User.dart';
import '../../../di/Modules.dart';
import '../../../domain/UserModel.dart';
import '../../styles/colors_style.dart';
import '../../utile/FormValidator.dart';
import '../../utile/LangUtiles.dart';
import '../general_components/ActionDialog.dart';
import '../general_components/units/buttons.dart';
import '../general_components/units/texts.dart';
import 'LoginPageViewModel.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  SignUpScreen({
    required this.signedUp,
    Key? key,
  }) : super(key: key);
  Function(bool isSginedUp) signedUp;

  @override
  ConsumerState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  UserModel? user;
  SignUpForm form = SignUpForm();
  late LoginPageViewModel viewModel;
  final GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    viewModel = ref.watch(LoginPageViewModelProvider);
    user = viewModel.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorStyle.male1,
        elevation: 0,
      ),
      body: Stack(children: [
        Container(
          height: (MediaQuery.of(context).size.height * 0.5),
          decoration: BoxDecoration(
              color: ColorStyle.male1,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "res/images/logo_kindergarten.png",
                height: (MediaQuery.of(context).size.width * 0.4),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 40,
                    right: 40,
                    top: (MediaQuery.of(context).size.height * 0.1),
                    bottom: (MediaQuery.of(context).size.height * 0.3)),
                decoration: BoxDecoration(
                    color: ColorStyle.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Container(
                    child: Center(
                      child: Form(
                        key: _key,
                        autovalidateMode: _validate,
                        child: _getFormUI(),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

  Widget _getFormUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 50.0),
        customTextForm(
            icon: Icon(
              FontAwesomeIcons.userAlt,
              size: 18,
              color: ColorStyle.male1,
            ),
            hint: 'Name',
            textType: TextInputType.name,
            onChange: ((text) => form.fullName = text),
            validator: FormValidator(context).validateNotEmpty,
            onSaved: (value) {
              form.fullName = value!;
            }),
        SizedBox(
          height: 10,
        ),
        customTextForm(
            icon: Icon(
              FontAwesomeIcons.phone,
              size: 18,
              color: ColorStyle.male1,
            ),
            hint: 'Phone Number',
            textType: TextInputType.phone,
            onChange: ((text) => form.phoneNumber = text),
            validator: FormValidator(context).validatePhone,
            onSaved: (value) {
              form.phoneNumber = value!;
            }),
        const SizedBox(height: 15.0),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0), child: body()),
      ],
    );
  }

  Future _sendToServer() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (_key.currentState!.validate()) {
      ///////////////firebase auth////////////////////
      //       showAlertDialog(context: context, messageDialog: ActionDialog(type: DialogType.loading, title: "sign in", message: "please wait"));
      //       await auth.verifyPhoneNumber(
      //         phoneNumber: '+964${form.phoneNumber}',
      //         timeout: const Duration(seconds: 60),
      //         // autoRetrievedSmsCodeForTesting:"123456",
      //         verificationCompleted: (PhoneAuthCredential credential) async {
      //           await signInWithUserCredential(auth, credential);
      //         },
      //         verificationFailed: (FirebaseAuthException e) {
      //           if (e.code == 'invalid-phone-number') {
      //             throw e;
      //           }
      //         },
      //         codeSent: (String verificationId, int? resendToken) async {
      //           // Update the UI - wait for the user to enter the SMS code
      //
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) => PinCodeVerificationScreen(
      //                         onVerify: (pin) async {
      //                           String smsCode = pin;
      //
      //                           // Create a PhoneAuthCredential with the code
      //                           PhoneAuthCredential credential =
      //                               PhoneAuthProvider.credential(
      //                                   verificationId: verificationId,
      //                                   smsCode: smsCode);
      //
      //                           // Sign the user in (or link) with the credential
      //
      //                           await signInWithUserCredential(auth, credential);
      //                         },
      //                         onResendCode: () {},
      //                         phoneNumber: '+964${form.phoneNumber}',
      //                       )));
      //         },
      //         codeAutoRetrievalTimeout: (String verificationId) {},
      //       );
      //////////////////////////////

      await viewModel.SginUp(form: form);

      /// No any error in validation
      ///
      ///
      ///

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
          widget.signedUp(true);
          viewModel.setUserApiResponse(ApiResponse.non());
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

  Widget loginButton() {
    return customButton(
        icon: FontAwesomeIcons.solidArrowAltCircleRight,
        text: "Sign Up",
        mainColor: ColorStyle.white,
        backgroundColor: ColorStyle.male1,
        onPressed: () async {
          await _sendToServer();
        });
  }

  signInWithUserCredential(
    FirebaseAuth auth,
    PhoneAuthCredential credential,
  ) async {
    showAlertDialog(
        context: context,
        messageDialog: ActionDialog(
            type: DialogType.loading,
            title: "Verification",
            message: "please waite until verification process complete"));
    await auth.signInWithCredential(credential).then((value) async {
      await viewModel.SginUp(form: form);
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      Navigator.pop(context);
    });
  }
}
