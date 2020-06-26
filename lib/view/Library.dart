import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/user_model.dart';

import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/file_provider.dart';
import 'package:webookapp/view_model/library_provider.dart';

import 'package:webookapp/widget/custom_bookItem.dart';
import 'package:webookapp/widget/custom_loadingPage.dart';
import 'package:webookapp/widget/custom_text.dart';

class LibraryPage extends StatefulWidget{
  LibraryPage({Key key}) : super(key:key);
  @override
  _LibraryPageState createState(){
      return _LibraryPageState();
  }
}
class _LibraryPageState extends State<LibraryPage>{
  AuthProvider auth;
  LibraryProvider library;
  FileProvider file;
  User user;
  List<Book> _book;
  
  void didChangeDependencies() {
    super.didChangeDependencies();
    auth = Provider.of<AuthProvider>(context);
    library = Provider.of<LibraryProvider>(context);
    file = Provider.of<FileProvider>(context);
    load();
  }
  void load() async{
    if(auth.user.uid != null){
      print(auth.user.uid);
      final book = await library.getBooks(auth.user.uid);
      setState(() {
        _book = book;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
      if ( _book != null){       
        return Scaffold(          
          body: Container(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 25, top:25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomText(
                        text: 'What are you',                        
                        size: 22,
                        weight: FontWeight.w100,
                        colors: Colors.black                        
                      ),
                      Row(
                        children: <Widget>[
                          CustomText(
                            text: 'reading ',
                            size: 22,
                            weight: FontWeight.w100,
                            colors: Colors.black
                          ),
                          CustomText(
                            text: 'today ?',
                            size: 22,
                            weight: FontWeight.w600,
                            colors: Colors.black                            
                          )
                        ],
                      )
                    ],
                  )
                ),
                GridView.builder(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                  shrinkWrap: true,
                  itemCount: _book.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 200 / 300,
                  
                  ),
                  itemBuilder: (context,index){
                    final book =_book[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal:8),
                      child: BookItem(book: book,img: book.coverURL,title: book.title, file: file,),
                    );
                  },
                )
              ]
            )
          )
        );
      }
      else{
        return CustomLoadingPage();
      }
    
  }


}