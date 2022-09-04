import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/utile/language_constrants.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../di/Modules.dart';
import '../../../domain/ActionGroup.dart';
import '../../../domain/ChildAction.dart';
import '../../general_components/ActionGroup.dart';
import '../../general_components/Error.dart';
import '../../general_components/loading.dart';
import 'ChildActionViewModel.dart';
class ChildActionAddScreen extends ConsumerStatefulWidget {
  final String childId;

  const ChildActionAddScreen({
    required this.childId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ChildActionAddScreenState();
}
class _ChildActionAddScreenState extends ConsumerState<ChildActionAddScreen> {
  late ChildActionViewModel _viewModel;
  ActionGroup? selectedActionGroup;
  TextEditingController textFieldController = TextEditingController();
  List<File>? medias;

  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(ChildActionViewModelProvider(widget.childId));

    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated("adding_action", context)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: bodyHead(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: [
                  Text(getTranslated("adding_action", context),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Container(
                padding: const EdgeInsets.only(top: 8),
                child: TextField(
                  controller: textFieldController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 2,
                          color: Color(0xFF898989),
                          style: BorderStyle.none,
                        )),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    hintText: "playing with other children",
                  ),
                  maxLines: 6,
                  minLines: 4,
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  picImage();
                },
                child: Text(
                  getTranslated("choose_image", context),
                  style: const TextStyle(color: Colors.blue),
                )),
          ],
        ),
      ),
      bottomSheet:  Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8,right: 8,bottom: 16),
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedActionGroup != null &&textFieldController.text.isNotEmpty) {
                    var childAction = ChildAction(
                        id: "",
                        actionGroupId: selectedActionGroup!.id,
                        audience: Audience.All,
                        value: textFieldController.text,
                        childId: widget.childId,
                        userId: '',
                        date: DateTime.now());

                    setState(() {
                      _viewModel
                          .addChildAction(childAction: childAction, assets: medias)
                          .then((value) {
                        Navigator.pop(context);
                      });
                    });
                  }
                },
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0.0),
                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Colors.blue)
                          // side: BorderSide()
                        ))),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 10, 8),
                  child: Text(
                    getTranslated("add", context),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Padding(
      //     padding: const EdgeInsets.all(40),
      //     child: ElevatedButton(
      //       onPressed: () async {
      //         if (selectedActionGroup != null &&textFieldController.text.isNotEmpty) {
      //           var childAction = ChildAction(
      //               id: "",
      //               actionGroupId: selectedActionGroup!.id,
      //               audience: Audience.All,
      //               value: textFieldController.text,
      //               childId: widget.childId,
      //               userId: '',
      //               date: DateTime.now());
      //
      //           setState(() {
      //             _viewModel
      //                 .addChildAction(childAction: childAction, assets: medias)
      //                 .then((value) {
      //               Navigator.pop(context);
      //             });
      //           });
      //         }
      //       },
      //       style: ButtonStyle(
      //           elevation: MaterialStateProperty.all(0.0),
      //           backgroundColor: MaterialStateProperty.all(Colors.transparent),
      //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      //               RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(10.0),
      //                   side: const BorderSide(color: Colors.blue)
      //                   // side: BorderSide()
      //                   ))),
      //       child: Padding(
      //         padding: const EdgeInsets.fromLTRB(8, 10, 10, 8),
      //         child: Text(
      //           getTranslated("add", context),
      //           style: TextStyle(fontSize: 20),
      //         ),
      //       ),
      //     )),
    );
  }

  Future<void> picImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      medias = files;
    } else {
      // User canceled the picker
    }
  }

  Widget bodyHead() {
    var status = _viewModel.actionGroupResponse.status;
    switch (status) {
      case Status.LOADING:
        return LoadingWidget();
      case Status.COMPLETED:
        return ActionGroups(
          actionGroups: _viewModel.actionGroupResponse.data!,
          selectedItem: (value) {
            setState(() {
              selectedActionGroup = value;
            });
          },
          viewTypeGrid: true,
        );
      case Status.ERROR:
        return MyErrorWidget(msg: _viewModel.actionGroupResponse.message!);
      case Status.Empty:
        return EmptyWidget(
          msg: "not action group added by super admin",
          onRefresh: () {
            _viewModel.fetchActionGroups();
          },
        );
      case Status.NON:
        break;
      default:
    }
    return Container(
      height: 1,
    );
  }
}
