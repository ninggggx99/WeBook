import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class PDFScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _PDFScreenState();
  
  final String pathPDF;

  PDFScreen(this.pathPDF);
  
}

class _PDFScreenState extends State<PDFScreen> {

  Color favColor;

  @override
  void initState() {
    favColor = Colors.grey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Document"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: favColor),
              onPressed: () {
                setState(() {
                  favColor == Colors.grey ? favColor = Colors.pink: favColor = Colors.grey;
                  //add likes to the book
                });
                
              },),
            IconButton(
              icon: Icon(Icons.add_comment),
              onPressed: () {
                //comment screen
              },
            ),
          ],
        ),
        path: widget.pathPDF
    );        
  }
}