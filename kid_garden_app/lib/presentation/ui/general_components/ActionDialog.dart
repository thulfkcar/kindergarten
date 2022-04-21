import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../AssingScreen/QRReader.dart';

class ActionDialog extends StatefulWidget {
  String message;
  String title;
  DialogType type;
  int? delay;
  Function(String?)? onCompleted;
  bool dismissed = false;
  String? qr;

  ActionDialog(
      {Key? key,
      this.delay = 2000,
      required this.type,
      required this.title,
      required this.message,
      this.onCompleted,
      this.qr})
      : super(key: key);

  @override
  State<ActionDialog> createState() => _ActionDialogState();
}

class _ActionDialogState extends State<ActionDialog> {
  @override
  Widget build(BuildContext context) {
    if (widget.type != DialogType.loading && widget.type != DialogType.qr && widget.type!=DialogType.scanner) {
      if (widget.delay != null) {
        Future.delayed(Duration(milliseconds: widget.delay!), () async {
          if (widget.dismissed == false) {
              Navigator.pop(context);

            if (widget.onCompleted != null) {
              widget.onCompleted!(null);
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
                          if (widget.onCompleted != null) {
                            widget.onCompleted!(null);
                          }
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
      case DialogType.qr:
        return Container(
            height: 300,
            width: 300,
            child: QrImage(
              data: widget.qr!,
              version: QrVersions.auto,
              size: 200.0,
            ));
      case DialogType.scanner:
       return Container (height:400,child:  QRReader(
         barcodeResult: (Barcode) async {
           if (Barcode.code != null) {
             widget.onCompleted!(Barcode.code);

           }
         },
       ));
    }
  }
}

Future<void> showAlertDialog(
    {required BuildContext context,
    required ActionDialog messageDialog}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return messageDialog;
    },
  );
}

enum DialogType { error, loading, warning, completed, qr ,scanner}
