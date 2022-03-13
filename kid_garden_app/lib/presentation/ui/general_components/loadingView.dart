import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MessageDialog extends StatefulWidget {
  String message;
  String title;
  DialogType type;
  int? delay;

  MessageDialog(
      {Key? key,
      this.delay = 2000,
      required this.type,
      required this.title,
      required this.message})
      : super(key: key);

  @override
  State<MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog> {
  @override
  Widget build(BuildContext context) {
    if (widget.type != DialogType.loading) {
      Future.delayed(Duration(milliseconds: widget.delay!), () async {
        Navigator.pop(context);
      });
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
