import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActionDialog extends StatefulWidget {
  String message;
  String title;
  DialogType type;
  int? delay;
  Function? onCompleted;
  bool dismissed = false;

  ActionDialog(
      {Key? key,
      this.delay = 2000,
      required this.type,
      required this.title,
      required this.message,
      this.onCompleted})
      : super(key: key);

  @override
  State<ActionDialog> createState() => _ActionDialogState();
}

class _ActionDialogState extends State<ActionDialog> {
  @override
  Widget build(BuildContext context) {
    if (widget.type != DialogType.loading) {
      if (widget.delay != null) {
        Future.delayed(Duration(milliseconds: widget.delay!), () async {
          if (widget.dismissed == false) {
            Navigator.pop(context);
            if (widget.onCompleted != null) {
              widget.onCompleted!();
            }
          }
        });
      }
    }
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              symbole(),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Text(
                    widget.message,
                  )),
            ],
          ),
          actions: [
            widget.type != DialogType.loading
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        widget.dismissed = true;
                        Navigator.pop(context);
                        if (widget.type == DialogType.completed ||
                            widget.type == DialogType.warning) {
                          widget.onCompleted();
                        }
                      });
                    },
                    child: const Text("Dismiss"))
                : Container()
          ],
        ));
  }

  Widget symbole() {
    switch (widget.type) {
      case DialogType.error:
        return const FaIcon(
          FontAwesomeIcons.exclamationCircle,
          color: Colors.redAccent,
          size: 60,
        );
      case DialogType.loading:
        return const SizedBox(
            width: 60, height: 60, child: CircularProgressIndicator());
      case DialogType.warning:
        return const FaIcon(FontAwesomeIcons.exclamationCircle,
            color: Colors.yellowAccent, size: 60);

      case DialogType.completed:
        return const FaIcon(
          FontAwesomeIcons.checkCircle,
          color: Colors.blueAccent,
          size: 60,
        );
    }
  }
}

enum DialogType { error, loading, warning, completed }
