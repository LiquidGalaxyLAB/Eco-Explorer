import 'package:eco_explorer/constants/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../constants/theme.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isFlashOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: () {
              _flashToggle();
            },
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.camera_rotate_fill,
              color: Colors.white,
            ),
            onPressed: () {
              _cameraSwitch();
            },
          ),
          SizedBox(width: Constants.totalWidth(context)*0.02,)
        ],
      ),
      body: Stack(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(
                borderColor: Themes.timelapse,
                borderRadius: Constants.totalWidth(context)*0.015,
                borderLength: Constants.totalWidth(context)*0.07,
                borderWidth: Constants.totalWidth(context)*0.02,
                cutOutSize: Constants.totalWidth(context)*0.6,
              ),
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }

  _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        print('Barcode Type: ${describeEnum(result!.format)} Data: ${result!.code}');
        Navigator.pop(context,{
          'result': result!.code
        });
      });
    });
  }

  _flashToggle() async{
    if (controller != null) {
      await controller!.toggleFlash();
      bool? flashStatus = await controller!.getFlashStatus();
      setState(() {
        isFlashOn = flashStatus ?? false;
      });
    }
  }

  _cameraSwitch() async{
    if (controller != null) {
      await controller!.flipCamera();
    }
  }
}
