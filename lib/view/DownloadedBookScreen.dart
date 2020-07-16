import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/download_provider.dart';
import 'package:webookapp/widget/custom_loadingPage.dart';
import 'package:webookapp/widget/custom_text.dart';


class DownloadBookScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _DownloadBookScreenState();
  AuthProvider auth;
  
  DownloadBookScreen(this.auth);
}

class _DownloadBookScreenState extends State<DownloadBookScreen> {
  
  DownloadProvider downloadProvider; 
  List<Book> _bookDownload;
  bool edit = true;

  void didChangeDependencies() {
    super.didChangeDependencies();
    downloadProvider = Provider.of<DownloadProvider>(context);
    load();
  }

  void load() async {
    if (widget.auth != null) {
      final bookDownload = await downloadProvider.getDownloadedBooks(widget.auth.user.uid);
      // print (bookDownload);
      setState(() {
        _bookDownload = bookDownload;
      });
      // print(_bookDownload);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bookDownload == null){
      // print(_bookDownload);
      return CustomLoadingPage();
    }
    else{
      // print(_bookDownload);
       return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          title: CustomText(text: "Download", size: 22, weight: FontWeight.w500, colors: Colors.black),
          backgroundColor: Colors.white,
        ),
        body: Container(
          child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
          
            ListView.builder(
              padding: EdgeInsets.only(left: 25, right: 6, top: 20),
              itemCount: _bookDownload.length,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final book = _bookDownload[index];
                return _buildDownloadList(context, book);
                
                },
              ),
            ],
          )
        ),
      );
    }
   
  }
  Widget _buildDownloadList (BuildContext context, Book book){

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) async{       
        await downloadProvider.removeBook(book.bookURL, book.title, book.key, widget.auth.user.uid);
        print("removed"); 
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(book.title + " has been deleted from downloads"),)
        );       
        setState(() {
          _bookDownload.remove(book);
          load();
        });
      },
      child: GestureDetector(
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
        ),
    );
  }
}
