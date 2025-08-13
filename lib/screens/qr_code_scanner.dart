import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  MobileScannerController cameraController = MobileScannerController();
  bool isStarted = true;
  bool isScanned = false;
  bool isTorchOn = false;
  bool isFrontCamera = false;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    cameraController.barcodes.listen((capture) {
      if (!isScanned) {
        final List<Barcode> barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          if (barcode.rawValue != null) {
            _handleBarcode(barcode.rawValue!);
            break;
          }
        }
      }
    });
  }

  void _handleBarcode(String code) {
    if (isScanned) return;

    setState(() {
      isScanned = true;
    });

    cameraController.stop();

    Navigator.pop(context, {
      'result': code,
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Define ratios
    final scannerBoxSize = width * 0.7;
    final cornerSize = scannerBoxSize * 0.12;
    final overlayHeight = height * 0.15;
    final instructionBottomOffset = height * 0.2;
    final iconSize = width * 0.08;

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(
              isTorchOn ? Icons.flash_on : Icons.flash_off,
              color: isTorchOn ? Colors.yellow : Colors.grey,
            ),
            iconSize: iconSize,
            onPressed: () async {
              await cameraController.toggleTorch();
              setState(() {
                isTorchOn = !isTorchOn;
              });
            },
          ),
          IconButton(
            color: Colors.white,
            icon: Icon(
              isFrontCamera ? Icons.camera_front : Icons.camera_rear,
            ),
            iconSize: iconSize,
            onPressed: () async {
              await cameraController.switchCamera();
              setState(() {
                isFrontCamera = !isFrontCamera;
              });
            },
          ),
          IconButton(
            color: Colors.white,
            icon: isStarted ? const Icon(Icons.stop) : const Icon(Icons.play_arrow),
            iconSize: iconSize,
            onPressed: () async {
              if (isStarted) {
                await cameraController.stop();
              } else {
                await cameraController.start();
              }
              setState(() {
                isStarted = !isStarted;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              // This is handled by the listener in initState
            },
          ),
          // Top overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: overlayHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Bottom overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: overlayHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Scanning overlay
          Center(
            child: Container(
              width: scannerBoxSize,
              height: scannerBoxSize,
              child: Stack(
                children: [
                  // Top-left corner
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: cornerSize,
                      height: cornerSize,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.green, width: 4),
                          left: BorderSide(color: Colors.green, width: 4),
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(scannerBoxSize * 0.048),
                        ),
                      ),
                    ),
                  ),
                  // Top-right corner
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: cornerSize,
                      height: cornerSize,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.green, width: 4),
                          right: BorderSide(color: Colors.green, width: 4),
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(scannerBoxSize * 0.048),
                        ),
                      ),
                    ),
                  ),
                  // Bottom-left corner
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: cornerSize,
                      height: cornerSize,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.green, width: 4),
                          left: BorderSide(color: Colors.green, width: 4),
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(scannerBoxSize * 0.048),
                        ),
                      ),
                    ),
                  ),
                  // Bottom-right corner
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: cornerSize,
                      height: cornerSize,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.green, width: 4),
                          right: BorderSide(color: Colors.green, width: 4),
                        ),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(scannerBoxSize * 0.048),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Instructions
          Positioned(
            bottom: instructionBottomOffset,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(width * 0.04),
              child: Text(
                'Position the QR code inside the frame to scan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Loading indicator when scanned
          if (isScanned)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}