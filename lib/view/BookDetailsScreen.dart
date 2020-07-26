import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/comment_model.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view/CreateReview.dart';
import 'package:webookapp/view/EditBookScreen.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/file_provider.dart';
import 'package:webookapp/view_model/home_provider.dart';
import 'package:webookapp/view_model/library_provider.dart';

import 'package:epub_kitty/epub_kitty.dart';
import 'package:webookapp/widget/custom_feedbackContainer.dart';
import 'package:webookapp/widget/custom_loadingPage.dart';
import 'package:webookapp/widget/custom_tab_indicator.dart';
import 'package:webookapp/widget/custom_text.dart';

//import 'PDFScreen.dart';
class BookDetailsScreen extends StatefulWidget {
  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();

  final Book bookModel;
  final AuthProvider auth;
  BookDetailsScreen(this.bookModel, this.auth);
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  LibraryProvider library;
  HomeProvider feed;
  FileProvider file;
  bool _exist;
  bool _own;
  int _tabIndex = 0;
  bool checkExist = false;
  bool checkOwn = false;
  int tabbed = 0;
  TabController _tabcontroller;
  List<Book> _bookSim;
  List<Comment> _comment;
  Book _mainBook;
  void didChangeDependencies() {
    super.didChangeDependencies();
    library = Provider.of<LibraryProvider>(context);
    feed = Provider.of<HomeProvider>(context);
    file = Provider.of<FileProvider>(context);
    load();
  }

  void load() async {

    Book book;

    if (widget.auth.user.uid != null) {
      final mainBook =await feed.retrieveBook(widget.bookModel.key);
      final bookExist = await library.getBooks(widget.auth.user.uid);
      final bookOwn = await library.getUserBooks(widget.auth.user.uid);
      final bookSimilar = await feed.getBooksByCat(mainBook.category,widget.bookModel.key);
      // print(bookSimilar[0].key + " " +bookSimilar[1].key);
      final comment = await feed.getComments(widget.bookModel.key);
      print(widget.bookModel.title);
      print(comment);
      // print(comment.length);
      // await feed.addComment(widget.bookModel.key, widget.auth.user.uid, 'Helphelp', 3);
      // if (library.error != LibraryError.NO_BOOK){
      if (bookExist != null) {
        for (book in bookExist) {
          if (book.key == widget.bookModel.key) {
            checkExist = true;
          }
        }
      }
      if (bookOwn != null) {
        for (book in bookOwn) {
          if (book.key == widget.bookModel.key) {
            checkOwn = true;
          }
        }
      }

      // }

      final exist = checkExist;
      final own = checkOwn;
      setState(() {
        _comment = comment;
        _exist = exist;
        _own = own;
        _bookSim = bookSimilar;
        _mainBook = mainBook;
        _mainBook.key = widget.bookModel.key;
      });
      print(_exist);
      print(_mainBook.title);
    }
  }

  

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (_exist != null) {
      return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
            child: Column(
          children: <Widget>[
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: const Color(0x009688).withOpacity(0.5),
                    expandedHeight: MediaQuery.of(context).size.height * 0.5,
                    flexibleSpace: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      color: const Color(0x009688).withOpacity(0.5),
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  margin: EdgeInsets.only(bottom: 42),
                                  width: 172,
                                  height: 225,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            _mainBook.coverURL)),
                                    borderRadius: BorderRadius.circular(10),
                                  )))
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                          padding: EdgeInsets.only(top: 24, left: 25),
                          child: Text(_mainBook.title,
                              style: GoogleFonts.openSans(
                                  fontSize: 27,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))),
                      Padding(
                          padding: EdgeInsets.only(top: 7, left: 25),
                          child: Text(_mainBook.authorName,
                              style: GoogleFonts.openSans(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400))),
                      Container(
                        height: 300,
                        margin: EdgeInsets.only(top: 23, bottom: 36),
                        padding: EdgeInsets.only(left: 25),
                        child: DefaultTabController(
                          length: 3,
                          child: Column(
                            children: <Widget>[
                              TabBar(
                                onTap: (index) {
                              
                                  setState(() {
                                    _tabIndex = index;
                                  });
                                },
                                
                                controller: _tabcontroller,
                                labelPadding: EdgeInsets.all(0),
                                indicatorPadding: EdgeInsets.all(0),
                                // isScrollable: SemanticsFlag.hasEnabledState
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.grey,
                                labelStyle: GoogleFonts.openSans(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                                unselectedLabelStyle: GoogleFonts.openSans(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                                indicator: RoundedRectangleTabIndicator(
                                    weight: 2, width: 30, color: Colors.black),
                                tabs: <Widget>[
                                  Tab(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 39),
                                      child: Text('Description'),
                                    ),
                                  ),
                                  Tab(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 39),
                                      child: Text('Reviews'),
                                    ),
                                  ),
                                  Tab(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 39),
                                      child: Text('Similar'),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    // description
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 0, right: 25, top: 20),
                                      child: Text(_mainBook.description,
                                          style: GoogleFonts.openSans(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 1.5,
                                              height: 2)),
                                    ),
                                    // reviews
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 0, right: 25, top: 20),
                                      child: _comment == null
                                          ? Text(
                                              'Loading..',
                                              style: GoogleFonts.openSans(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            )
                                          // ? Container()
                                          : ListView.builder(
                                              itemCount: _comment.length,
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                final comment =
                                                    _comment[index];

                                                String formattedDate =
                                                    DateFormat(
                                                            'yyyy-MM-dd kk:mm')
                                                        .format(comment
                                                            .dateCreated);
                                                return FutureBuilder(
                                                    future: widget.auth
                                                        .findUser(
                                                            comment.userId),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        final User user =
                                                            snapshot.data;
                                                        return Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10),
                                                          child: (Row(
                                                            children: <Widget>[
                                                              Expanded(
                                                                  child: Row(
                                                                      children: <
                                                                          Widget>[
                                                                    custom_feedbackContainer(
                                                                        comment:
                                                                            comment,
                                                                        date:
                                                                            formattedDate,
                                                                        user:
                                                                            user)
                                                                  ]))
                                                            ],
                                                          )),
                                                        );
                                                      } else {
                                                        return Container();
                                                      }
                                                    });
                                              }),
                                    ),
                                    //s
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 0, right: 0, top: 20),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.20,
                                                child:
                                                    _buildListView(_bookSim)),
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 0, right: 0, bottom: 25),
                width: 400,
                height: 49,
                color: Colors.transparent,
                child: _tabIndex != 2
                ? (_own == true
                  ? writerButton()
                  : bookwormButton()
                )
                : null
            ),
          ],
        )),
      );
    } else {
      return CustomLoadingPage();
    }
  }

  Widget writerButton() {
    final pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    return FlatButton(
      color: const Color(0x009688).withOpacity(0.5),
      onPressed: () async {
        if (_tabIndex == 0){
           Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditBookScreeen(_mainBook))).then((value) => setState(() {
                            print("hi");
                            load();
                                                      
                          
                          }));
        }
        else{
          String epubPath = "";
          await pr.show();

          /* await file.createFileOfPdfUrl(widget.book.bookURL).then((f) {
            pdfPath = f.path;
          }); */

          await file.convertFile(_mainBook.bookURL).then((f) {
            epubPath = f.path;
          });
          /* await Navigator.push(context,
            MaterialPageRoute(builder: (context) => PDFScreen(pathPDF: pdfPath, book: widget.book,) )
          ); */
          
          await pr.hide();
          EpubKitty.setConfig('book', "#32a852", 'vertical', true);

          //This is the part experiencing errors for me
          EpubKitty.open(epubPath);
        }
       
      },
      child: _tabIndex == 0
      ?  CustomText(
          text: 'Edit Book',
          size: 14,
          weight: FontWeight.w600,
          colors: Colors.white)
      :  CustomText(
          text: 'Read Book',
          size: 14,
          weight: FontWeight.w600,
          colors: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget bookwormButton() {
    final pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    return FlatButton(
      color: const Color(0x009688).withOpacity(0.5),
      onPressed: () async {
        if (_tabIndex == 0) {
          if (_exist == true) {
            void _showDialog(BuildContext ancestorContext) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                          "Are you sure you want to delete ${_mainBook.title} ?"),
                      actions: <Widget>[
                        FlatButton(
                          child: CustomText(
                              text: "Confirm",
                              size: 14,
                              weight: FontWeight.w600,
                              colors: const Color(0x009688).withOpacity(0.9)),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await pr.show();
                            await library.deleteBook(
                                widget.bookModel.key, widget.auth.user.uid);
                            await pr.hide();
                            setState(() {
                              _exist = false;
                            });
                          },
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: CustomText(
                              text: "Cancel",
                              size: 14,
                              weight: FontWeight.w600,
                              colors: const Color(0x009688).withOpacity(0.9)),
                        )
                      ],
                    );
                  });
            }

            _showDialog(context);
          } else {
            await pr.show();
            await library.addBook(widget.bookModel.key, widget.auth.user.uid);
            setState(() {
              _exist = true;
            });
            await pr.hide();
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: const Text(
                    'Yay! It has been successfully added to your library.'),
              ),
            );
          }
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CreateReview(_mainBook, widget.auth, feed)));
        }
      },
      child: _tabIndex == 0
          ? _exist == true
              ? CustomText(
                  text: 'Delete',
                  size: 14,
                  weight: FontWeight.w600,
                  colors: Colors.white)
              : CustomText(
                  text: 'Add to Library',
                  size: 14,
                  weight: FontWeight.w600,
                  colors: Colors.white)
          : CustomText(
              text: 'Add a Review',
              size: 14,
              weight: FontWeight.w600,
              colors: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildListView(List<Book> _book) {
    return ListView.builder(
      padding: EdgeInsets.only(left: 25, right: 6),
      itemCount: _book.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final book = _book[index];
        return Container(
          margin: EdgeInsets.only(right: 19),
          height: 120,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xe0f2f1),
            image: DecorationImage(
              image: NetworkImage(book.coverURL),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: InkWell(onTap: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BookDetailsScreen(book, widget.auth)));
          }),
        );
      },
    );
  }
}
