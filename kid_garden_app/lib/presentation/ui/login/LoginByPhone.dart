import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:kid_garden_app/presentation/general_components/units/texts.dart';
import 'package:kid_garden_app/presentation/ui/dialogs/ActionDialog.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import 'package:kid_garden_app/presentation/utile/language_constrants.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../data/network/FromData/User.dart';
import '../../../di/Modules.dart';
import '../../../domain/UserModel.dart';
import '../../styles/colors_style.dart';
import '../../utile/FormValidator.dart';
import '../../utile/LangUtiles.dart';
import '../dialogs/dialogs.dart';
import 'PinCodeScreen.dart';

class LoginByPhoneNumber extends ConsumerStatefulWidget {
  static String tag = 'login-by-phone';

  Function(UserModel? user) loggedIn;

  LoginByPhoneNumber({Key? key, required this.loggedIn}) : super(key: key);

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginByPhoneNumber> {
  bool isCompleted = false;
  UserModel? user;
  LoginForm form = LoginForm();
  late LoginPageViewModel viewModel;
  final GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  final LoginForm _loginData = LoginForm();

  @override
  Widget build(BuildContext context) {
    viewModel = ref.watch(LoginPageViewModelProvider);
    user = ref.watch(hiveProvider).value!.getUser();

    return Container(
      child: Center(
        child: Form(
          key: _key,
          autovalidateMode: _validate,
          child: _getFormUI(),
        ),
      ),
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
              FontAwesomeIcons.phone,
              size: 18,
              color: ColorStyle.male1,
            ),
            hint: AppLocalizations.of(context)?.getText("phone") ??
                'Phone Number',
            textType: TextInputType.phone,
            onChange: ((text) => form.phoneNumber = text),
            validator: FormValidator(context).validatePhone,
            onSaved: (value) {
              _loginData.phoneNumber = value!;
            }),
        const SizedBox(height: 15.0),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0), child: body()),
      ],
    );
  }

  Widget loginButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              await _sendToServer();
            },
            child: titleText(
                AppLocalizations.of(context)?.getText("sign_in") ?? "Sign In",
                ColorStyle.white),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(ColorStyle.male1),
                elevation: MaterialStateProperty.all(0)),
          ),
        )
      ],
    );
  }

  Future _sendToServer() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (_key.currentState!.validate()) {
      /////////////firebase auth////////////////////
      showAlertDialog(
          context: context,
          messageDialog: ActionDialog(
              type: DialogType.loading,
              title: getTranslated("sign_in", context),
              message: getTranslated("please_waite", context)));

      await auth.verifyPhoneNumber(
        phoneNumber: '+964${form.phoneNumber}',
        timeout: const Duration(seconds: 60),
        // autoRetrievedSmsCodeForTesting:"123456",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await signInWithUserCredential(auth, credential);
        },

        verificationFailed: (FirebaseAuthException e) {
          var title="";
         var message="";
          switch (e.code) {
            case 'invalid-verification-code':
              title=getTranslated("invalid_ver_code",context);
              message=getTranslated("invalid_ver_code_des", context);
              break;
            case 'too-many-requests':
              title=getTranslated("too_many_requests",context);
              message=getTranslated("too_many_requests_des", context);
              break;
            default :
            title=e.code;
            message=e.message.toString();
              break;
          }

          showDialogGeneric(
              context: context,
              dialog: ActionDialog(
                type: DialogType.warning,
                title: title,
                message: message,
                delay: 10000,
              )).then((value) {
            Navigator.pop(context);
          });

        },
        codeSent: (String verificationId, int? resendToken) async {
          // Update the UI - wait for the user to enter the SMS code

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PinCodeVerificationScreen(
                        onVerify: (pin) async {
                          Navigator.pop(context);
                          String smsCode = pin;

                          // Create a PhoneAuthCredential with the code
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: smsCode);

                          // Sign the user in (or link) with the credential

                          await signInWithUserCredential(auth, credential);
                        },
                        onResendCode: () async {
                          await _sendToServer();
                        },
                        phoneNumber: '${form.phoneNumber}',
                      )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      ////////////////////////////
      //        await viewModel.authByPhone(loginRequestData: form);

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
          widget.loggedIn(viewModel.userApiResponse.data);
          viewModel.setUserApiResponse(ApiResponse.non());
        }
        break;
      case Status.ERROR:
        {
          Future.delayed(Duration(milliseconds: 0), () {
            showAlertDialog(
                context: context,
                messageDialog: ActionDialog(
                  type: DialogType.warning,
                  message: viewModel.userApiResponse.message!,
                  onCompleted: (s) {
                    viewModel.setUserApiResponse(ApiResponse.non());
                  },
                  title: 'Login Failure',
                  delay: 100000,
                ));
          });

          return login;
        }
      case Status.NON:
        return login;
      default:
    }

    return const CircularProgressIndicator();
  }

  signInWithUserCredential(
    FirebaseAuth auth,
    PhoneAuthCredential credential,
  ) async {
    showAlertDialog(
        context: context,
        messageDialog: ActionDialog(
            type: DialogType.loading,
            title: getTranslated("verification", context),
            message: getTranslated("please_waite", context)));
    await auth.signInWithCredential(credential).then((value) async {
      await viewModel.authByPhone(loginRequestData: form);
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      Navigator.pop(context);
    });
  }
}
