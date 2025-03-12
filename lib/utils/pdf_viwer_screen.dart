import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String fileName;

  PdfViewerScreen({required this.pdfUrl, required this.fileName});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    downloadPdf();
  }

  Future<void> downloadPdf() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/${widget.fileName}.pdf");

      if (!file.existsSync()) {
        // Download the PDF from server
        Dio dio = Dio();
        await dio.download(widget.pdfUrl, file.path);
      }

      setState(() {
        localPath = file.path;
        isLoading = false;
      });
    } catch (e) {
      print("Error downloading PDF: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.fileName}")),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loader while downloading
          : localPath != null
          ? PDFView(
        filePath: localPath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onError: (error) {
          print("Error loading PDF: $error");
        },
      )
          : Center(child: Text("Failed to load PDF")),
    );
  }
}
