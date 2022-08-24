import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/Child/childProfileScreen/ChildProfileViewModel.dart';
import 'package:kid_garden_app/presentation/ui/dialogs/ActionDialog.dart';
import 'package:kid_garden_app/presentation/ui/dialogs/dialogs.dart';
import 'package:kid_garden_app/presentation/utile/language_constrants.dart';
import 'package:kid_garden_app/them/DentalThem.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../data/network/ApiResponse.dart';
import '../../../../data/network/BaseApiService.dart';
import '../../../../di/Modules.dart';
import '../../../../domain/AssignRequest.dart';
import '../../../../domain/Child.dart';
import '../../../../domain/Contact.dart';
import '../../../../domain/UserModel.dart';
import '../../../general_components/ContactList.dart';
import '../../../general_components/KindergartenButton.dart';
import '../../../general_components/RequestedToKindergartenCard.dart';
import '../../../general_components/units/texts.dart';
import '../../../styles/colors_style.dart';
import '../../childActions/ChildActions.dart';
import '../../kindergartens/kindergartenScreen.dart';

class ChildProfileScreen extends ConsumerStatefulWidget {
  Child child;
  bool isSubscriptionValid;
  String? subscriptionMessage;

  ChildProfileScreen(
      {Key? key,
      required this.child,
      required this.isSubscriptionValid,
      this.subscriptionMessage})
      : super(key: key);

  @override
  ConsumerState createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends ConsumerState<ChildProfileScreen> {
  late ChildProfileViewModel _viewModel;
  late AsyncValue<UserModel?> user;

  @override
  Widget build(BuildContext context) {
    user = ref.watch(userProvider);

    _viewModel = ref.watch(childProfileViewModelProvider);
    Future.delayed(Duration.zero, () {
      kindergratenRequestViewResponse();
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
              getTranslated("profile", context) + ": " + widget.child.name),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipOval(
                            child: SizedBox.fromSize(
                                size: const Size.fromRadius(50),
                                child: Image.network(
                                    '$domain${widget.child.image!}',
                                    fit: BoxFit.cover)),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.child.name,
                                  style: const TextStyle(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF090F13),
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: [
                                    widget.child.gender == Gender.Female
                                        ? Icon(
                                            Icons.female,
                                            // if child is female gender
                                            // Icons.male,
                                            color: ColorStyle.female1,
                                            // color: ColorStyle.male1,
                                            size: 20,
                                          )
                                        : Icon(
                                            Icons.male,
                                            // if child is female gender
                                            // Icons.male,
                                            color: ColorStyle.male1,
                                            // color: ColorStyle.male1,
                                            size: 20,
                                          ),
                                    Text(
                                      widget.child.age.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Lexend Deca',
                                        color: Color(0xFF57636C),
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                widget.child.staffName != null
                                    ? Text(
                                        "Taking care by: " +
                                            widget.child.staffName.toString(),
                                        style: const TextStyle(
                                          fontFamily: 'Lexend Deca',
                                          color: Color(0xFF57636C),
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    contactCard(widget.child.contacts),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!widget.isSubscriptionValid) {
                            Navigator.pop(context);
                          } else {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChildActions(
                                          childId: widget.child.id,
                                        )));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: titleText(
                              getTranslated("actions", context), Colors.black),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(KidThem.white),
                            side: MaterialStateProperty.all(
                                BorderSide(width: 1, color: KidThem.male1)),
                            elevation: MaterialStateProperty.all(0)),
                      ),
                    )
                  ],
                ),
                widget.child.assignRequest != null
                    ? widget.child.assignRequest!.requestStatus ==
                            RequestStatus.Pending
                        ? RequestedToKindergartenCard(
                            widget.child.assignRequest!, (kindergarten) {
                            //todo: request kindergarten
                          })
                        : (KindergartenButton(
                            name: widget.child.assignRequest!.kindergartenName!,
                            image:
                                widget.child.assignRequest!.kindergartenImage!,
                            id: widget.child.assignRequest!.kindergartenId,
                          ))
                    : joinKindergartenCard(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(getTranslated("childId", context) + " : ",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      QrImage(
                        data: widget.child.id,
                        version: QrVersions.auto,
                        size: 300,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget contactCard(List<Contact>? contacts) {
    return contacts != null
        ? Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        getTranslated("Contacts", context),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ),
                  ],
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final item = contacts[index];

                    return ContactListCard(
                      item.userType == "Parent" &&
                              (user.value != null &&
                                  user.value!.role == Role.Parents)
                          ? false
                          : true,
                      contact: item,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(height: 1, color: Colors.transparent);
                  },
                ),
              ],
            ),
          )
        : Container();
  }

  Widget joinKindergartenCard() {
    return ElevatedButton(
      onPressed: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => KindergartenScreen(
                      childId: widget.child.id,
                      onKindergartenChoosed: (kindergartenId) async {
                        await _viewModel.joinRequest(
                            widget.child.id, kindergartenId);
                      },
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Center(
                    child: descriptionText(
                        getTranslated("click_to_join_des", context),
                        ColorStyle.text1,
                        textAlign: TextAlign.center)),
                Text(
                  getTranslated("click_to_join", context),
                  style: TextStyle(color: Colors.black87, fontSize: 18),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.yellow.shade800,
                  size: 30,
                ),
              ],
            )
          ],
        ),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(KidThem.white),
          side: MaterialStateProperty.all(
              BorderSide(width: 1, color: KidThem.male1)),
          elevation: MaterialStateProperty.all(0)),
    );
  }

  kindergratenRequestViewResponse() {
    var status = _viewModel.joinKindergartenRequest.status;
    switch (status) {
      case Status.LOADING:
        showDialogGeneric(
            context: context,
            dialog: ActionDialog(
                type: DialogType.loading,
                title: getTranslated("joining_request", context),
                message: getTranslated("joining_request_sending", context)));
        break;
      case Status.COMPLETED:
        Navigator.pop(context);
        showDialogGeneric(
            context: context,
            dialog: ActionDialog(
              type: DialogType.completed,
              title: getTranslated("joining_request", context),
              message: getTranslated("joining_request_sending", context),
              onCompleted: (sd) {
                setState(() {
                  widget.child.assignRequest =
                      _viewModel.joinKindergartenRequest.data!;
                });

                _viewModel.joinKindergartenRequest = ApiResponse.non();
              },
            ));
        break;
      case Status.ERROR:
        Navigator.pop(context);

        showDialogGeneric(
            context: context,
            dialog: ActionDialog(
                type: DialogType.error,
                title: getTranslated("joining_request", context),
                message: "دز كي من الapi حته ع اساسه تظهرله الرسالة"));
        break;
      default:
    }
  }
}
