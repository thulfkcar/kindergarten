
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ComboBoxDental2<T> extends StatefulWidget {
  final String title;
  final FaIcon? icon;
  final Color? color;
  final Color? backgroundColor;
  double? fontSize;
  double paddingTitleValue;
  final double fontSizeTitle;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final List<T> items;
  final FloatingActionButton? button;
  void Function(T) selectedValue;
  final bool searchable;

  ComboBoxDental2(
      {Key? key,
      this.fontSize,
      required this.selectedValue,
      required this.paddingTitleValue,
      required this.title,
      this.icon,
      this.color,
      this.backgroundColor,
      required this.fontSizeTitle,
      this.onChanged,
      this.controller,
      required this.items,
      this.button,
      required this.searchable})
      : super(key: key);

  @override
  _ComboBoxDental2State<T> createState() => _ComboBoxDental2State();
}

class _ComboBoxDental2State<T> extends State<ComboBoxDental2<T>> {
  var searchString = "";
  var selectedItemIndex = 0;
  var dropIcon = Icons.keyboard_arrow_down_sharp;

  var isEditing = false;

  var searchController = TextEditingController();
  var searchScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double paddingTitle = widget.paddingTitleValue * 9;
    if (isEditing) {
      dropIcon = Icons.keyboard_arrow_up_sharp;
    } else {
      dropIcon = Icons.keyboard_arrow_down_sharp;
    }

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: widget.fontSize! * 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: paddingTitle,
                    child: Text(
                      widget.title + ":",
                      style: TextStyle(fontSize: widget.fontSizeTitle),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 4, 4, 0),
                  ),
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.yellowAccent,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color: Colors.blueAccent, width: 1)),
                          child: Row(
                            children: [
                              Expanded(
                                  child: TextField(
                                controller: searchController,
                                onChanged: (value) {
                                  for (var element in widget.items) {
                                    var searchKey = '';
                                    widget.searchable == true
                                        ? searchKey = (element as dynamic)
                                            .searchKey
                                            .toString()
                                            .toLowerCase()
                                            .trim()
                                        : searchKey = element as dynamic;
                                    if (searchKey ==
                                        searchString.toLowerCase().trim()) {
                                      widget.selectedValue(element);
                                      setState(() {
                                        isEditing = false;
                                        searchString = value.toLowerCase();
                                      });
                                    } else {
                                      setState(() {
                                        isEditing = true;
                                        searchString = value.toLowerCase();
                                      });
                                    }
                                  }
                                },
                                style: TextStyle(fontSize: widget.fontSize),
                                decoration: InputDecoration(
                                  fillColor: Colors.redAccent,
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )),
                                  filled: true,
                                ),
                              )),
                              Padding(
                                padding: EdgeInsets.all(0),
                                child: FloatingActionButton(
                                  foregroundColor: Colors.green,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  child: Icon(dropIcon),
                                  onPressed: () {
                                    setState(() {
                                      if (isEditing) {
                                        isEditing = false;
                                      } else {
                                        isEditing = true;
                                      }
                                    });
                                  },
                                ),
                              )
                            ],
                          )))
                ],
              ),
            ),
            // SizedBox(height: 10),
            if (isEditing)
              Row(
                children: [
                  SizedBox(
                    width: paddingTitle,
                    child: Text(
                      widget.title + ":",
                      style: TextStyle(fontSize: widget.fontSizeTitle),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey, width: 1)),
                      height: 200,
                      child: ListView.builder(
                        controller: searchScrollController,
                        itemCount: widget.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          var searchKey='';
                          widget.searchable==true ? searchKey = (widget.items[index] as dynamic)
                              .searchKey
                              .toLowerCase():searchKey= (widget.items[index] as dynamic);
                          return searchKey
                                  .contains(searchString)
                              ? ListTile(
                                  title: TextButton(
                                    onPressed: () {
                                      widget.selectedValue(widget.items[index]);
                                      selectedItemIndex = index;
                                      setState(() {
                                        isEditing = false;
                                        searchController.text =searchKey;
                                      });
                                    },
                                    child: Text(
                                      searchKey,
                                      style: TextStyle(
                                          fontSize: widget.fontSize,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  // List tile widget data
                                )
                              : Container();
                        },
                      ),
                    ),
                  )
                ],
              )
          ],
        ));
  }
}
