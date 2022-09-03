import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/Child/childProfileScreen/ChildProfileViewModel.dart';
import 'package:kid_garden_app/presentation/ui/dialogs/ActionDialog.dart';
import 'package:kid_garden_app/presentation/ui/dialogs/dialogs.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/admin/AssignScreen/AssginScreen.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/admin/AssignScreen/AssignRequestByQR.dart';
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
import '../../../general_components/units/buttons.dart';
import '../../../general_components/units/texts.dart';
import '../../../styles/colors_style.dart';
import '../../childActions/ChildActions.dart';
import '../../kindergartens/kindergartenScreen.dart';

class ChildProfileScreen extends ConsumerStatefulWidget {
  final Child child;
  final bool isSubscriptionValid;
  final String? subscriptionMessage;
  final Function() onChildRemoved;
  final Function()? onKindergartenLeft;

  const ChildProfileScreen(
      {Key? key,
      this.onAssignCompleted,
      required this.onChildRemoved,
      required this.child,
      required this.isSubscriptionValid,
      this.subscriptionMessage,
      this.onKindergartenLeft})
      : super(key: key);

  @override
  ConsumerState createState() => _ChildProfileScreenState();

  final Function()? onAssignCompleted;
}

class _ChildProfileScreenState extends ConsumerState<ChildProfileScreen> {
  late ChildProfileViewModel _viewModel;
  late UserModel? user;

  @override
  Widget build(BuildContext context) {
    user = ref.watch(hiveProvider).value!.getUser();
    _viewModel = ref.watch(childProfileViewModelProvider);
    Future.delayed(Duration.zero, () {
      kindergratenRequestViewResponse();
      cancelRequestResponse();
      removeChildViewResponse();
      leaveKindergartenResponse();
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
              getTranslated("profile", context) + ": " + widget.child.name),
          actions: [
            user!.role != Role.Staff
                ? customButton(
                    icon: Icons.delete_forever_outlined,
                    backgroundColor: Colors.transparent,
                    mainColor: Colors.redAccent,
                    text: "",
                    size: 30,
                    onPressed: () async {
                      showDialogGeneric(
                          context: context,
                          dialog: ConfirmationDialog(
                              title: getTranslated("remove_child", context),
                              message:
                                  getTranslated("remove_child_des", context),
                              confirmed: () async {
                                switch (user!.role) {
                                  case Role.admin:
                                    await _viewModel
                                        .removeChildFromKindergarten(
                                            widget.child.id);
                                    break;
                                  case Role.Parents:
                                    await _viewModel
                                        .removeChildEntirely(widget.child.id);
                                    break;
                                  default:
                                }
                              }));
                    },
                  )
                : Container()
          ],
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
                                        getTranslated(
                                                "taking_care_by", context) +
                                            " " +
                                            widget.child.staffName.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.fade,
                                        softWrap: true,
                                        textScaleFactor: 0.8,
                                        style: const TextStyle(
                                            fontFamily: 'Lexend Deca',
                                            color: Color(0xFF57636C),
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                            overflow: TextOverflow.ellipsis),
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
                    ),
                    user!.role != Role.Staff
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: ElevatedButton(
                              onPressed: () async {
                                user!.role == Role.admin
                                    ? await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AssignScreen(
                                                  childId: widget.child.id,
                                                  onAssignCompleted: (user) {
                                                    setState(() {
                                                      widget.child.contacts!
                                                          .add(Contact(
                                                              name: user.name!,
                                                              phone:
                                                                  user.phone!,
                                                              userType:
                                                                  "Staff"));
                                                    });
                                                  },
                                                )))
                                    : widget.isSubscriptionValid
                                        ? await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AssignScreenByQR(
                                                      childId: widget.child.id,
                                                      onAssignCompleted: () {
                                                        if (widget
                                                                .onAssignCompleted !=
                                                            null) {
                                                          widget
                                                              .onAssignCompleted!();
                                                        }
                                                      },
                                                    )))
                                        : {
                                            Navigator.pop(context),
                                            Navigator.pop(context)
                                          };
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: titleText(
                                    getTranslated("assign_to_staff", context),
                                    Colors.black),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(KidThem.white),
                                  side: MaterialStateProperty.all(BorderSide(
                                      width: 1, color: KidThem.male1)),
                                  elevation: MaterialStateProperty.all(0)),
                            ),
                          )
                        : Container(),
                  ],
                ),
                kindergartenView(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(getTranslated("childId", context) + " : ",
                              style: const TextStyle(
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
                        style: const TextStyle(
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
                              (user != null && user!.role == Role.Parents)
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
                  style: const TextStyle(color: Colors.black87, fontSize: 18),
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
              message: getTranslated("process_finished", context),
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
                    message: _viewModel.joinKindergartenRequest.message!))
            .then((value) =>
                _viewModel.setJoinKindergartenRequest(ApiResponse.non()));
        break;
      default:
    }
  }

  Widget kindergartenView() {
    UserModel? user = ref.watch(hiveProvider).value!.getUser();
    if (user != null) {
      return user.role == Role.Parents
          ? widget.child.assignRequest != null
              ? widget.child.assignRequest!.requestStatus ==
                      RequestStatus.Pending
                  ? RequestedToKindergartenCard(
                      widget.child.assignRequest!,
                      (kindergarten) {
                        //todo: request kindergarten
                      },
                      onCancelRequestClicked: () async {
                        showDialogGeneric(
                            context: context,
                            dialog: ConfirmationDialog(
                                title: getTranslated(
                                    "cancel_joining_request", context),
                                message: getTranslated(
                                    "cancel_join_request_des", context),
                                confirmed: () async {
                                  await _viewModel.cancelJoinRequest(
                                      widget.child.assignRequest!.id);
                                }));
                      },
                    )
                  : widget.child.assignRequest!.requestStatus ==
                          RequestStatus.Rejected
                      ? rejectKindergartenCard()
                      : Row(
                          children: [
                            Expanded(
                              child: (KindergartenButton(
                                name: widget
                                    .child.assignRequest!.kindergartenName!,
                                image: widget
                                    .child.assignRequest!.kindergartenImage!,
                                id: widget.child.assignRequest!.kindergartenId,
                              )),
                            ),
                            MaterialButton(
                                onPressed: () {
                                  showDialogGeneric(
                                      context: context,
                                      dialog: ConfirmationDialog(
                                          title:
                                              getTranslated("leave", context),
                                          message: getTranslated(
                                              "leave_des", context),
                                          confirmed: () async {
                                            await _viewModel.leaveKindergarten(
                                                widget.child.id);
                                          }));
                                },
                                child: const Icon(
                                  Icons.leave_bags_at_home_outlined,
                                  color: Colors.redAccent,
                                  size: 40,
                                ),
                                color: Colors.transparent,
                                elevation: 0)
                          ],
                        )
              : joinKindergartenCard()
          : Container();
    }
    return Container();
  }

  Widget rejectKindergartenCard() {
    return ElevatedButton(
      onPressed: () {
        //toDo:onclick kindergartenProfile...
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.child.assignRequest!.kindergartenName! + " : "),
                Expanded(
                  child: Text(
                    widget.child.assignRequest!.message!,
                  ),
                ),
              ],
            ),
            ElevatedButton(
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
                    Text(
                      getTranslated(
                          "click_to_join_another_kindergarten", context),
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 18),
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
            )
          ],
        ),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(KidThem.white),
          side: MaterialStateProperty.all(
              const BorderSide(width: 1, color: Colors.redAccent)),
          elevation: MaterialStateProperty.all(0)),
    );
  }

  cancelRequestResponse() {
    var status = _viewModel.cancelJoinRequestResponse.status;
    switch (status) {
      case Status.LOADING:
        showDialogGeneric(
            context: context,
            dialog: ActionDialog(
                type: DialogType.loading,
                title: getTranslated("cancel_joining_request", context),
                message:
                    getTranslated("cancel_joining_request_sending", context)));
        break;
      case Status.COMPLETED:
        Navigator.pop(context);
        showDialogGeneric(
            context: context,
            dialog: ActionDialog(
              type: DialogType.completed,
              title: getTranslated("cancel_joining_request", context),
              message: getTranslated("process_finished", context),
              onCompleted: (sd) {
                setState(() {
                  widget.child.assignRequest = null;
                });

                _viewModel.cancelJoinRequestResponse = ApiResponse.non();
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
                    message: _viewModel.cancelJoinRequestResponse.message!))
            .then((value) =>
                _viewModel.setCancelJoinRequestResponse(ApiResponse.non()));
        break;
      default:
    }
  }

  removeChildViewResponse() {
    var status = _viewModel.removeChildResponse.status;
    switch (status) {
      case Status.LOADING:
        showDialogGeneric(
            context: context,
            dialog: ActionDialog(
                type: DialogType.loading,
                title: getTranslated("remove_child", context),
                message:
                    getTranslated("cancel_joining_request_sending", context)));
        break;
      case Status.COMPLETED:
        Navigator.pop(context);
        showDialogGeneric(
            context: context,
            dialog: ActionDialog(
              type: DialogType.completed,
              title: getTranslated("remove_child", context),
              message: getTranslated("process_finished", context),
              onCompleted: (sd) {
                _viewModel.removeChildResponse = ApiResponse.non();
                widget.onChildRemoved();
                Navigator.pop(context);
              },
            ));
        break;
      case Status.ERROR:
        Navigator.pop(context);

        showDialogGeneric(
                context: context,
                dialog: ActionDialog(
                    type: DialogType.error,
                    title: getTranslated("remove_child", context),
                    message: _viewModel.removeChildResponse.message!))
            .then((value) =>
                _viewModel.setRemoveChildResponse(ApiResponse.non()));
        break;
      default:
    }
  }

  leaveKindergartenResponse() {
    var status = _viewModel.leaveKindergartenResponse.status;
    switch (status) {
      case Status.LOADING:
        showDialogGeneric(
            context: context,
            dialog: ActionDialog(
                type: DialogType.loading,
                title: getTranslated("leave", context),
                message: getTranslated("loading", context)));
        break;
      case Status.COMPLETED:
        if (widget.onKindergartenLeft != null) {
          widget.onKindergartenLeft!();
        }
        Navigator.pop(context);
        showDialogGeneric(
            context: context,
            dialog: ActionDialog(
              type: DialogType.completed,
              title: getTranslated("leave", context),
              message: getTranslated("process_finished", context),
              onCompleted: (sd) {
                setState(() {
                  widget.child.assignRequest = null;

                  widget.child.contacts!.removeWhere((element) =>
                      (element.userType == "Staff" ||
                          element.userType == "Admin"));
                });

                _viewModel.leaveKindergartenResponse = ApiResponse.non();
              },
            ));
        break;
      case Status.ERROR:
        Navigator.pop(context);

        showDialogGeneric(
                context: context,
                dialog: ActionDialog(
                    type: DialogType.error,
                    title: getTranslated("leave", context),
                    message: _viewModel.leaveKindergartenResponse.message!))
            .then((value) =>
                _viewModel.setLeaveKindergartenResponse(ApiResponse.non()));
        break;
      default:
    }
  }
}
