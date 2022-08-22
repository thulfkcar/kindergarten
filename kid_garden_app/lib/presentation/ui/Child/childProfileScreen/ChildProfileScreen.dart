import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/Child/childProfileScreen/ChildProfileViewModel.dart';
import 'package:kid_garden_app/presentation/utile/language_constrants.dart';
import '../../../../data/network/BaseApiService.dart';
import '../../../../di/Modules.dart';
import '../../../../domain/AssignRequest.dart';
import '../../../../domain/Child.dart';
import '../../../../domain/Contact.dart';
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

  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(childProfileViewModelProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
              getTranslated("profile", context) + ": " + widget.child.name),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: childCard(),
                    ),
                    Container(
                      color: ColorStyle.text1,
                      width: 1,
                    ),
                    actionButton()
                  ],
                ),
              ),
              Container(
                color: ColorStyle.text1,
                height: 1,
              ),
              contactCard(widget.child.contacts),
              (widget.child.contacts != null &&
                      widget.child.contacts!.isNotEmpty)
                  ? Container(
                      color: ColorStyle.text1,
                      height: 1,
                    )
                  : Container(),
              widget.child.assignRequest != null
                  ? widget.child.assignRequest!.requestStatus ==
                          RequestStatus.Pending
                      ? RequestedToKindergartenCard(widget.child.assignRequest!,
                          (kindergarten) {
                          //todo: request kindergarten
                        })
                      : (KindergartenButton(
                          name: widget.child.assignRequest!.kindergartenName!,
                          image: widget.child.assignRequest!.kindergartenImage!,
                          id: widget.child.assignRequest!.kindergartenId,
                        ))
                  : joinKindergartenCard(),
            ],
          ),
        ));
  }

  Widget contactCard(List<Contact>? contacts) {
    return contacts != null
        ? Container(
            color: ColorStyle.text5,
            padding: const EdgeInsets.all(10),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final item = contacts[index];

                return ContactList(
                  true,
                  contact: item,
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(height: 1, color: Colors.black);
              },
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
                    builder: (context) =>
                        KindergartenScreen(childId: widget.child.id)))
            .then((value) async {
          await _viewModel.joinRequest(widget.child.id);
        });
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: titleText(
                getTranslated("click_to_join", context), ColorStyle.text1),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: descriptionText(
                    getTranslated("click_to_join_des", context),
                    ColorStyle.text1,
                    textAlign: TextAlign.center)),
          )
        ],
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(ColorStyle.text4),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ))),
    );
  }

  Widget childCard() {
    return ElevatedButton(
      onPressed: () {
        if (!widget.isSubscriptionValid) Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipOval(
              child: SizedBox.fromSize(
                  size: const Size.fromRadius(30),
                  child: Image.network('$domain${widget.child.image!}',
                      fit: BoxFit.cover)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
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
                        fontSize: 20,
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
            ),
          ],
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(ColorStyle.text4),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          Directionality.of(context).index == 0
              ? const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(10)),
                )
              : const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                ),
        ),
      ),
    );
  }

  Widget actionButton() {
    return ElevatedButton(
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
      child: titleText(getTranslated("actions", context), ColorStyle.white),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(ColorStyle.text3),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          Directionality.of(context).index == 0
              ? const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                )
              : const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(10)),
                ),
        ),
      ),
    );
  }
}
