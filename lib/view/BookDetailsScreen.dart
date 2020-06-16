import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/view/CommentScreen.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/file_provider.dart';
import 'package:webookapp/view_model/library_provider.dart';

import 'PDFScreen.dart';

class BookDetailsScreen extends StatefulWidget {
  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();

  final Book book;
  final bool home;

  BookDetailsScreen(this.book, this.home);
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //REFORMAT THIS PAGE
  final descTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w300,
    fontFamily: 'Roboto',
    letterSpacing: 0.5,
    fontSize: 14,
    height: 2,
  );

  int noComments;

  @override
  void initState() {
    super.initState();
    noComments = widget.book.comments != null? widget.book.comments.length:0;
  }

  @override
  Widget build(BuildContext context) {
    final library = Provider.of<LibraryProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final file = Provider.of<FileProvider>(context);
    final pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('${widget.book.title}'),
          actions: widget.home ? <Widget> [] 
            : <Widget> [
            IconButton(
              icon: Icon(Icons.chrome_reader_mode), 
              onPressed: () async {
                String pdfPath = "";
                await pr.show();
                await file.createFileOfPdfUrl(widget.book.bookURL).then((f) {
                  pdfPath = f.path;
                });
                await pr.hide();

                await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PDFScreen(pathPDF: pdfPath, book: widget.book,) )
                );
            },)
          ]
        ),
        body: Center(
          child: Stack(
            children: <Widget>[
            Center(
              child:  Column(
                children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                child: Image.network(
                  widget.book.coverURL,
                  height: 150,
                  width: 100),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ], 
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.favorite, color: Colors.pink),
                        Text("${widget.book.rating}"),
                      ],
                    ),
                    Column(
                      children: <Widget> [
                        IconButton(
                          icon: Icon(Icons.comment),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CommentScreen(book: widget.book))
                            );
                          },),
                        //Add the counter for the number of comments
                        Text(noComments.toString()),
                      ],
                    ),
                  ],
                ),
              ),

                  Text("Author name: ${widget.book.authorName}"),
                  Text("Category: ${widget.book.category}"),
                  Text("Description: ${widget.book.description}", style: descTextStyle,)
                ],
              )
            )
          
            ],

          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.teal,
          child: widget.home ? FlatButton.icon(
            onPressed: () async  {

              await pr.show();
              bool exist = await library.addBook(widget.book.key, auth.user.uid);
              await pr.hide();
  
              if (!exist) {
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: const Text('Yay! It has been successfully added to your library.'),
                    ),
                  );
              } else {
                 _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: const Text('This book exists in your library already!'),
                  ),
                );

              }
            }, 
            icon: Icon(Icons.add_circle, color: Colors.white,), 
            label: Text("Add to Library")) :
            FlatButton.icon(
              onPressed: () async {
                void _showDialog(BuildContext ancestorContext) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Are you sure you want to delete ${widget.book.title} ?"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Confirm!"),
                        onPressed: () async {

                          Navigator.of(context).pop();
                          await pr.show();
                          await library.deleteBook(widget.book.key, auth.user.uid);
                                          //Refreshes future builder
                          await pr.hide();
                          Navigator.of(ancestorContext).pop("delete");
                          
                        }
                      ,),
                        FlatButton(
                          child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }
                        )
                    ],
                    );
                    }
                  );
                }
                _showDialog(context);
              },
              icon: Icon(Icons.delete, color: Colors.white,),
              label: Text("Delete", style: TextStyle(color: Colors.white))

            )
        ),

      );
  }
}