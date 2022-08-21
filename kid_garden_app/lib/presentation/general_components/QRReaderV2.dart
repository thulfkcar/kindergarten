import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRReaderV2 extends StatefulWidget {
  QRReaderV2({required this.barcodeResult, Key? key}) : super(key: key);
  Function(Barcode?) barcodeResult;

  @override
  State<StatefulWidget> createState() => _QRReaderV2State();
}

class _QRReaderV2State extends State<QRReaderV2> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Icon icon = const Icon(
    Icons.flash_off,
    color: Colors.grey,
  );

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Stack(children: [
            _buildQrView(context),
            Container(
              margin: const EdgeInsets.all(8),
              child: MaterialButton(
                elevation: 0,
                disabledElevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                hoverElevation: 0,
                onPressed: () async {
                  await controller?.toggleFlash();
                  setState(() {

                  });
                },
                padding: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child:FutureBuilder(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            icon =snapshot.data!=null&&(snapshot.data as bool)==true?  const Icon(
                              Icons.flash_on,
                              color: Colors.yellow,
                            ): const Icon(
                              Icons.flash_off,
                              color: Colors.grey,
                            );
                            return icon; Text('Flash: ${snapshot.data}');
                          },
                        )
                ),
              ),

            ),
          ])),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  // void _onQRViewCreated(QRViewController controller) {
  //   setState(() {
  //     this.controller = controller;
  //   });
  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() {
  //       result = scanData;
  //     });
  //   });
  // }
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
          // Navigator.pop(context);

        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
