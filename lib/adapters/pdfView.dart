import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Pdfview extends StatefulWidget {
  final String url;

  const Pdfview({super.key, required this.url});

  @override
  State<Pdfview> createState() => _PdfviewState();
}

class _PdfviewState extends State<Pdfview> {
  PdfViewerController? _pdfViewerController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.network(widget.url, controller: _pdfViewerController),
    );
  }
}
