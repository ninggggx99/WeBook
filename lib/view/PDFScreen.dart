/*import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:webookapp/model/book_model.dart';

class PDFScreen extends StatefulWidget {

  const PDFScreen({Key key, this.pathPDF, this.book}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _PDFScreenState();
  
  final String pathPDF;
  final Book book;
 
}

class _PDFScreenState extends State<PDFScreen> {

  @override
  Widget build(BuildContext context) {
    return  PDFViewerScaffold(
        appBar: AppBar(
          title: Text(widget.book.title),
        ),
        path: widget.pathPDF
    );        
  }
}*/