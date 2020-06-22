import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/file_provider.dart';
import 'package:webookapp/view_model/library_provider.dart';
import 'package:webookapp/widget/custom_bookItem.dart';

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
      final book = await library.getBooks(auth.user.uid);
      setState(() {
        _book = book;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    if (_book != null){
      if(_book.length == 0){
         return Scaffold( 
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                    backgroundColor: const Color(0x009688),
                ),
                Text(
                  'Loading..',
                  style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                      ),
                )
              ],
            )
          )
        );
      }
      else{
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
                      Text(
                        'What are you',
                        style: GoogleFonts.openSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w100,
                          color: Colors.black
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'reading ',
                            style: GoogleFonts.openSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w100,
                              color: Colors.black
                            ),
                          ),
                          Text(
                            'today ?',
                            style: GoogleFonts.openSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.black
                            ),
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
      
    }
    else{
    
     return Scaffold( 
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                  backgroundColor: const Color(0x009688),
              ),
              Text(
                'Loading..',
                style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black
                    ),
              )
            ],
          )
        )
      );
    }
   
    
  }


}