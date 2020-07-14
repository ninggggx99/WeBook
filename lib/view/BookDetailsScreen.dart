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
  final bool home;
  final bool profile;
  BookDetailsScreen(this.bookModel, this.auth, this.home, this.profile);
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  LibraryProvider library;
  HomeProvider feed;
  bool _exist;
  bool _own;
  int _tabIndex = 0;
  bool checkExist = false;
  bool checkOwn = false;
  int tabbed = 0;

  List<Comment> _comment;
  void didChangeDependencies() {
    super.didChangeDependencies();
    library = Provider.of<LibraryProvider>(context);
    feed = Provider.of<HomeProvider>(context);
    load();
  }

  void load() async {
    Book book;
    if (widget.auth.user.uid != null) {
      final bookExist = await library.getBooks(widget.auth.user.uid);
      final bookOwn = await library.getUserBooks(widget.auth.user.uid);
      final comment = await feed.getComments(widget.bookModel);
      print(widget.bookModel.title);
      // print(comment.length);
      // await feed.addComment(widget.bookModel.key, widget.auth.user.uid, 'Helphelp', 3);
      // if (library.error != LibraryError.NO_BOOK){
      if (bookExist != null) {
        for (book in bookExist) {
          if (book.bookURL == widget.bookModel.bookURL) {
            checkExist = true;
          }
        }
      }
      if (bookOwn != null) {
        for (book in bookOwn) {
          if (book.bookURL == widget.bookModel.bookURL) {
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
      });
      print(_exist);
    }
  }

  TabController _tabcontroller;

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
                          Positioned(
                              left: 25,
                              top: 35,
                              child: GestureDetector(
                                  onTap: () {
                                    if (widget.profile == true) {
                                      Navigator.pushReplacementNamed(
                                          context, "/writerProfile");
                                    } else {
                                      Navigator.pushReplacementNamed(
                                          context, "/mainHome");
                                    }
                                  },
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                    child: Icon(Icons.arrow_back_ios),
                                  ))),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  margin: EdgeInsets.only(bottom: 42),
                                  width: 172,
                                  height: 225,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            widget.bookModel.coverURL)),
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
                          child: Text(widget.bookModel.title,
                              style: GoogleFonts.openSans(
                                  fontSize: 27,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))),
                      Padding(
                          padding: EdgeInsets.only(top: 7, left: 25),
                          child: Text(widget.bookModel.authorName,
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
                                isScrollable: true,
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
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 0, right: 25, top: 20),
                                      child: Text(widget.bookModel.description,
                                          style: GoogleFonts.openSans(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 1.5,
                                              height: 2)),
                                    ),
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
                                          : ListView.builder(
                                              itemCount: _comment.length,
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                final Comment comment =
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
                                                        return Column(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 30,
                                                              height: 50,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                backgroundColor:
                                                                    const Color(
                                                                            0x009688)
                                                                        .withOpacity(
                                                                            0.5),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            )
                                                          ],
                                                        );
                                                      }
                                                    });
                                              }),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 0, right: 25, top: 20),
                                      child: Text("Coming soon",
                                          style: GoogleFonts.openSans(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 1.5,
                                              height: 2)),
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
                child: _own == true
                    ? _tabIndex == 0 ? writerButton() : null
                    : bookwormButton()),
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
        Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => EditBookScreeen(widget.bookModel)));
      },
      child: CustomText(
          text: 'Edit Book',
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
                          "Are you sure you want to delete ${widget.bookModel.title} ?"),
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
            await pr.hide();
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: const Text(
                    'Yay! It has been successfully added to your library.'),
              ),
            );
            setState(() {
              _exist = true;
            });
          }
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CreateReview(widget.bookModel, widget.auth, feed)));
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
}
