import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/download_provider.dart';
import 'package:webookapp/widget/custom_loadingPage.dart';
import 'package:webookapp/widget/custom_text.dart';
import 'package:webookapp/widget/custom_AppBar.dart';

class SearchBookScreen extends StatefulWidget {
  @override
  _SearchBookScreenState createState() => new _SearchBookScreenState();
  AuthProvider auth;
  List<Book> books;
  String search;
  SearchBookScreen(this.auth, this.books,this.search);
}
class _SearchBookScreenState extends State<SearchBookScreen> {
  
 
  void didChangeDependencies() {
    super.didChangeDependencies();
    // downloadProvider = Provider.of<DownloadProvider>(context);
    load();
  }

  void load() async {
    if (widget.auth != null) {
      // final bookDownload = await downloadProvider.getDownloadedBooks(widget.auth.user.uid);
      // // print (bookDownload);
      // setState(() {
      //   _bookDownload = bookDownload;
      // });
      // print(_bookDownload);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.books== null){
      // print(_bookDownload);
      return CustomLoadingPage();
    }
    else{
      // print(_bookDownload);
       return Scaffold(
        appBar: CustomAppBar( text: widget.search),
        body: Container(
          child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
          
            ListView.builder(
              padding: EdgeInsets.only(left: 25, right: 6, top: 20),
              itemCount: widget.books.length,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final book = widget.books[index];
                return _buildResultList(context, book);
                
                },
              ),
            ],
          )
        ),
      );
    }
  }
   Widget _buildResultList (BuildContext context, Book book){
    return GestureDetector(
      onTap: () async {
        print('vertical tapped');
      },
      child: Container(
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
        )
      );
  }
}