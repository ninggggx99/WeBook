import 'dart:io';

import 'package:epub_kitty/epub_kitty.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/download_provider.dart';
import 'package:webookapp/view_model/file_provider.dart';
import 'package:webookapp/widget/custom_loadingPage.dart';
import 'package:webookapp/widget/custom_text.dart';
import 'package:webookapp/widget/custom_AppBar.dart';
import 'package:webookapp/utils/consts.dart';


class DownloadBookScreen extends StatefulWidget {
  @override
  _DownloadBookScreenState createState() => new _DownloadBookScreenState();
  AuthProvider auth;
  
  DownloadBookScreen(this.auth);
}

class _DownloadBookScreenState extends State<DownloadBookScreen> {
  FileProvider file;
  DownloadProvider downloadProvider; 
  List<Book> _bookDownload;
  bool edit = true;

  void didChangeDependencies() {
    super.didChangeDependencies();
    downloadProvider = Provider.of<DownloadProvider>(context);
    file = Provider.of<FileProvider>(context);
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
        appBar: CustomAppBar( text: "Download"),
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
    final pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
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
          String epubPath;
          await pr.show();
          String path = await getBookPath(book);
          // await file.convertFile(path).then((f){
          //   epubPath = f.path;
          // });
          await pr.hide();
          EpubKitty.setConfig('book', '#32a852', 'vertical', true);
          EpubKitty.open(path);
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
Future<String> getBookPath (Book book) async {
  String title = book.title;
  Directory appDocDir = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : null;
  if (Platform.isAndroid){
    Directory(appDocDir.path.split('Android')[0] + '${Constants.appName}').createSync();
  }
  String path = appDocDir.path.split('Android')[0] + '${Constants.appName}/$title.epub';
  return path;
} 