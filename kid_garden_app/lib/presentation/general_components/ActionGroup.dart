import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/data/network/NetworkApiService.dart';
import '../../../domain/ActionGroup.dart';
import '../../../data/network/BaseApiService.dart';

class ActionGroups extends StatefulWidget {
  ActionGroups(
      {Key? key,
      required this.actionGroups,
      required this.selectedItem,
      this.viewTypeGrid = false})
      : super(key: key);
  bool viewTypeGrid;
  List<ActionGroup> actionGroups;
  Function(ActionGroup) selectedItem;

  @override
  State<ActionGroups> createState() =>
      // ignore: no_logic_in_create_state
    viewTypeGrid? _ActionGroupsStateGrid():_ActionGroupsState();
}

class _ActionGroupsState extends State<ActionGroups> {
  int? selectedIndex = null;

  @override
  Widget build(BuildContext context) {
    var backColor = Color(0xA9AAAAAA);

    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: widget.actionGroups.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
              width: 55,
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                  color: Color(0xFF898989),
                ),
              ),
              child: InkWell(
                onTap: () {
                  setState(
                    () {
                      selectedIndex = index;
                      widget.selectedItem(widget.actionGroups[index]);
                    },
                  );
                },
                child: Container(
                  color:
                      index == selectedIndex ? backColor : Colors.transparent,
                  child: Center(
                      child: (widget.actionGroups[index].image) != null
                          ? Image.network(
                              (domain + widget.actionGroups[index].image!))
                          : const Icon(Icons.gradient)),
                ),
              ),
            ),
            Expanded(child: Text(widget.actionGroups[index].actionName))
          ],
        );
      },
    );
  }
}

class _ActionGroupsStateGrid extends State<ActionGroups> {
  int? selectedIndex = null;

  @override
  Widget build(BuildContext context) {
    var backColor = Color(0xA9AAAAAA);
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 5.5;
    final double itemWidth = size.width / 4;
    return GridView.count(
        childAspectRatio: (itemWidth / itemHeight),
      shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        children: List.generate(widget.actionGroups.length, (index) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: [
                Container(height: 65,width: 65,
                  padding: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  decoration:  BoxDecoration( border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    // border: Border.all(width: 1, color: ColorStyle.male1),
                    shape: BoxShape.rectangle,
                  ),
                  child: MaterialButton(
                      color: Colors.transparent,
                      elevation: 0,
                      disabledElevation: 0,
                      focusElevation: 0,
                      highlightElevation: 0,
                      hoverElevation: 0,
                      onPressed: () {
                        setState(
                          () {
                            selectedIndex = index;
                            widget.selectedItem(widget.actionGroups[index]);
                          },
                        );
                      },
                      child: Container(
                        color: index == selectedIndex
                            ? backColor
                            : Colors.transparent,
                        child: Center(
                            child: (widget.actionGroups[index].image) != null
                                ? Image.network(
                                    (domain + widget.actionGroups[index].image!))
                                : const Icon(Icons.gradient)),
                      )),
                ),
                Text(widget.actionGroups[index].actionName,style: TextStyle(fontSize: 13),)

              ],
            ),
          );
        }));
  }
}
