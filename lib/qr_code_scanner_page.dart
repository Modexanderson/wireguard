import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert'; // Import for JSON decoding

class QrCodeScannerScreen extends StatefulWidget {
  final Function(Map<String, String>) onScanResult;

  const QrCodeScannerScreen({Key? key, required this.onScanResult})
      : super(key: key);

  @override
  _QrCodeScannerScreenState createState() => _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends State<QrCodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;

  @override
  void reassemble() {
    super.reassemble();
    if (qrController != null) {
      if (Platform.isAndroid) {
        qrController!.pauseCamera();
      }
      qrController!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.green,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 300,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      qrController = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      final String? code = scanData.code;
      if (code != null) {
        try {
          final Map<String, dynamic> decodedData = jsonDecode(code);
          final Map<String, String> parsedData =
              Map<String, String>.from(decodedData);
          widget.onScanResult(parsedData);
        } catch (e) {
          // Handle JSON parsing error
          print('Failed to parse QR code: $e');
        }
      }
      qrController?.dispose();
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }
}
