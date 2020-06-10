import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/library_provider.dart';

class BookDetailsScreen extends StatefulWidget {
  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();

  final Book book;

  BookDetailsScreen(this.book);
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {

  //REFORMAT THIS PAGE
  final descTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w300,
    fontFamily: 'Roboto',
    letterSpacing: 0.5,
    fontSize: 14,
    height: 2,
  );

  @override
  Widget build(BuildContext context) {
    final library = Provider.of<LibraryProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
      return Scaffold(
          appBar: AppBar(title: Text('${widget.book.title}')),
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
                    children: [
                      Icon(Icons.comment),
                      //Add the counter for the number of comments
                      Text('1 hr'),
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
        child: FlatButton.icon(
          onPressed: () async  {
            
            await pr.show();
            await library.addBook(widget.book.key, auth.user.uid);
            await pr.hide();

          
          }, 
          icon: Icon(Icons.add_circle, color: Colors.white,), 
          label: Text("Add to Library"))
      ),

    );
  }
}