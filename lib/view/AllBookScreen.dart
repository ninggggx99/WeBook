
import 'package:flutter/material.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/view/BookDetailsScreen.dart';
import 'package:webookapp/view_model/auth_provider.dart';

import 'package:webookapp/view_model/file_provider.dart';
import 'package:webookapp/view_model/home_provider.dart';
import 'package:webookapp/widget/custom_loadingPage.dart';
import 'package:webookapp/widget/custom_text.dart';
import 'package:webookapp/widget/custom_AppBar.dart';



class AllBookScreen extends StatefulWidget {
  @override
  _AllBookScreenState createState() => new _AllBookScreenState();
  AuthProvider auth;
  
  AllBookScreen(this.auth);
}

class _AllBookScreenState extends State<AllBookScreen> {
  FileProvider file;
  HomeProvider homeProvider; 
  List<Book> _books;
  bool edit = true;

  void didChangeDependencies() {
    super.didChangeDependencies();
    homeProvider = Provider.of<HomeProvider>(context);
    file = Provider.of<FileProvider>(context);
    load();
  }

  void load() async {
    if (widget.auth != null) {
      final book = await homeProvider.getBookByVolume(widget.auth.user.uid);
      // print (bookDownload);
      setState(() {
        _books = book;
      });
      // print(_bookDownload);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_books == null){
      // print(_bookDownload);
      return CustomLoadingPage();
    }
    else{
      // print(_bookDownload);
       return Scaffold(
        appBar: CustomAppBar( text: "Popular"),
        body: Container(
          child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
          
            ListView.builder(
              padding: EdgeInsets.only(left: 25, right: 6, top: 20),
              itemCount: _books.length,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final book = _books[index];
                return _buildBookList(context, book);
                
                },
              ),
            ],
          )
        ),
      );
    }
   
  }
  Widget _buildBookList (BuildContext context, Book book){
    final pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BookDetailsScreen(book, widget.auth)));
      },
      child: Row(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 19),
              height: 81,
              width: MediaQuery.of(context).size.width - 50,
              child: Row(
                children: <Widget>[
                  Container(
                    height: 81,
                    width: 62,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: NetworkImage(book.coverURL)),
                      color: const Color(0xe0f2f1),
                    ),
                  ),
                  SizedBox(
                    width: 21,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomText(
                        text: book.title,
                        size: 16,
                        weight: FontWeight.w600,
                        colors: Colors.black
                      ),
                      SizedBox(height: 5),
                      CustomText(
                        text:book.authorName,
                        size: 10,
                        weight: FontWeight.w400,
                        colors: Colors.black
                      ),
                      SizedBox(height: 5),
                      CustomText(
                        text:book.category,
                        size: 16,
                        weight: FontWeight.w600,
                        colors: Colors.black
                      ),
                    ],
                  )
                ],
              )
            ),
        ],
      )
      );
  }
}
