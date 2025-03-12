import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  bool _isScanning = true;  // Add a flag to manage scanning state

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller?.pauseCamera();
    }
    _controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Stack(
        children: <Widget>[
          QRView(
            key: _qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.yellow,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 300,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              color: Colors.black.withOpacity(0.6),
              padding: EdgeInsets.all(16),
              child: Text(
                'Align QR code within the frame to scan',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });

    // Start listening for scanned data
    _controller?.scannedDataStream.listen((scanData) {
      if (_isScanning) {
        _isScanning = false;  // Prevent further scanning after the first scan

        final qrData = scanData.code;
        if (qrData != null) {
          // Navigate back with the result
          Get.back(result: qrData);
        }

        // After navigating back, ensure the camera is properly closed
        _controller?.pauseCamera();  // Pause camera to avoid further scans
      }
    });
  }

  @override
  void dispose() {
    // Ensure camera is disposed when the widget is destroyed
    _controller?.dispose();
    super.dispose();
  }
}
