import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kid_garden_app/presentation/general_components/units/buttons.dart';
import 'package:kid_garden_app/presentation/general_components/units/texts.dart';
import 'package:kid_garden_app/presentation/ui/SignUp/SignUpViewModel.dart';
import 'package:kid_garden_app/presentation/ui/dialogs/dialogs.dart';
import 'package:kid_garden_app/presentation/ui/entrySharedScreen/EntrySharedScreen.dart';
import 'package:kid_garden_app/presentation/utile/language_constrants.dart';

import '../../../data/network/ApiResponse.dart';
import '../../../data/network/FromData/User.dart';
import '../../../di/Modules.dart';
import '../../../domain/UserModel.dart';
import '../../styles/colors_style.dart';
import '../../utile/FormValidator.dart';
import '../../utile/LangUtiles.dart';
import '../dialogs/ActionDialog.dart';
import '../login/PinCodeScreen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  SignUpScreen({
    required this.signedUp,
    Key? key,
  }) : super(key: key);
  Function(UserModel? userModel) signedUp;

  @override
  ConsumerState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  SignUpForm form = SignUpForm();
  late SignUpViewModel viewModel;
  final GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    viewModel = ref.watch(signUpViewModelProvider);
    return EntrySharedScreen(
      body: Container(
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
        const SizedBox(height: 50.0),
        customTextForm(
            icon: Icon(
              FontAwesomeIcons.userAlt,
              size: 18,
              color: ColorStyle.male1,
            ),
            hint: AppLocalizations.of(context)?.getText("name") ?? 'Name',
            textType: TextInputType.name,
            onChange: ((text) => form.fullName = text),
            validator: FormValidator(context).validateNotEmpty,
            onSaved: (value) {
              form.fullName = value!;
            }),
        const SizedBox(
          height: 10,
        ),
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
      /////////////firebase auth////////////////////
      showAlertDialog(
          context: context,
          messageDialog: ActionDialog(
              type: DialogType.loading,
              title: getTranslated("sign_up", context),
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
                        await  _sendToServer();
                        },
                        phoneNumber: '${form.phoneNumber}',
                      )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      ////////////////////////////

      // await viewModel.signUp(form);

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
    switch (viewModel.signUpApiResponse.status) {
      case Status.LOADING:
        {
          return const CircularProgressIndicator();
        }
      case Status.COMPLETED:
        {
          Future.delayed(Duration.zero, () {
            widget.signedUp(viewModel.signUpApiResponse.data);
            viewModel.setSignUpApiResponse(ApiResponse.non());
          });
        }
        break;
      case Status.ERROR:
        Future.delayed(Duration.zero, () {
          showAlertDialog(
                  context: context,
                  messageDialog: ActionDialog(
                      type: DialogType.warning,
                      title: getTranslated("warning", context),
                      message: viewModel.signUpApiResponse.message! + ""))
              .then((value) {
            viewModel.setSignUpApiResponse(ApiResponse.non());
          });
        });

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
        text: AppLocalizations.of(context)?.getText("sign_up") ?? "Sign Up",
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
            title: AppLocalizations.of(context)?.getText("verification") ??
                "Verification",
            message:
                AppLocalizations.of(context)?.getText("verification_des") ??
                    "please waite until verification process complete"));
    await auth.signInWithCredential(credential).then((value) async {
      await viewModel.signUp(form);
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      Navigator.pop(context);
    });
  }
}
