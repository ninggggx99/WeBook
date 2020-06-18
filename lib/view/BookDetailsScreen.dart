
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/rating_model.dart';
import 'package:webookapp/view/CommentScreen.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/file_provider.dart';
import 'package:webookapp/view_model/home_provider.dart';
import 'package:webookapp/view_model/library_provider.dart';

import 'package:epub_kitty/epub_kitty.dart';
//import 'PDFScreen.dart';

class BookDetailsScreen extends StatefulWidget {
  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();

  final Book book;
  final bool home;

  BookDetailsScreen(this.book, this.home);
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {

  static const pageChannel = EventChannel('com.xiaofwang.epub_kitty/page');

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
  double avgRating;
  double userRate;


  @override
  void initState() {
    noComments = widget.book.comments != null ? widget.book.comments.length : 0;
    avgRating = widget.book.ratings != null ? calculateAverageRating() : null;
    userRate = 0;
    super.initState();

  }

  double calculateAverageRating() {
    List<Rating> ratings = widget.book.ratings;
    int noRate = ratings.length;
    double total = 0;
    for (Rating r in ratings) {
      total += r.rate;
    }
    double avg = double.parse((total/noRate).toStringAsFixed(2));
    return avg;
  }

  @override
  Widget build(BuildContext context) {
    final library = Provider.of<LibraryProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final file = Provider.of<FileProvider>(context);
    final feed = Provider.of<HomeProvider>(context);
    final pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('${widget.book.title}'),
          actions: widget.home ? <Widget> [] 
            : <Widget> [
            IconButton(
              icon: Icon(Icons.star),
              onPressed: () {
                void _showRating() {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("How good was this book?"),
                      content: Container( 
                        height: 60,
                        width: 300,
                        alignment: Alignment(0.0, 0.0),
                        child: RatingBar(
                        initialRating: 0,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          userRate = rating;
                        },
                      ),),
                      actions: <Widget>[
                      FlatButton(
                        child: Text("Submit!"),
                        onPressed: () async {

                          Navigator.of(context).pop();
                          await pr.show();
                          await feed.addRating(widget.book.key, auth.user.uid, userRate);
                          await pr.hide();
                          
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
                _showRating();
              },
            ),
            IconButton(
              icon: Icon(Icons.chrome_reader_mode), 
              onPressed: () async {
                //String pdfPath = "";
                String epubPath = "";
                await pr.show();

                /* await file.createFileOfPdfUrl(widget.book.bookURL).then((f) {
                  pdfPath = f.path;
                }); */

                await file.convertFile(widget.book.bookURL).then((f) {
                  epubPath = f.path;
                });

                /* await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PDFScreen(pathPDF: pdfPath, book: widget.book,) )
                ); */
                
                await pr.hide();
                EpubKitty.setConfig("androidBook", "#32a852", "vertical", true);    
                EpubKitty.open(epubPath);

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
                        Icon(Icons.star, color: Colors.yellowAccent[400]),
                        Text(avgRating != null ? "$avgRating/5.0" : "Not Rated"),
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