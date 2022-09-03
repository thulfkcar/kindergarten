import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRReader extends StatefulWidget {
  QRReader({Key? key, bool, required this.barcodeResult}) : super(key: key);

  Function(Barcode) barcodeResult;

  @override
  State<QRReader> createState() => _QRReaderState();
}

class _QRReaderState extends State<QRReader> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Column(
          children: <Widget>[
            Expanded(
              flex: 11,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ],
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 300,
                height: 300,
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 2)),
              ),
              Center(
                child: (result != null)
                    ? Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                    : Text(AppLocalizations.of(context)?.getText("scan_pin")??'Scan a code'),
              ),
            ],
          ),
        )
      ]),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    bool scanned = false;
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      if (!scanned) {
        if (result != null) {
          setState(() {
            scanned = true;
          });
          widget.barcodeResult(result!);
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
