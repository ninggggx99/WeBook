import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view/BookDetailsScreen.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/library_provider.dart';

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
  User user;
  List<Book> _book;
  
  void didChangeDependencies() {
    super.didChangeDependencies();
    auth = Provider.of<AuthProvider>(context);
    library = Provider.of<LibraryProvider>(context);
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
          appBar: AppBar(title: const Text('Library')),
          body: Center(
            child: Text('Explore more')
            ),
          );
      }
      else{
        return Scaffold(
          appBar: AppBar(title: const Text('Library')),
          body: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _book.length,
                itemBuilder: (context, index) {
                  final book = _book[index];
                  return Padding( 
                    padding: EdgeInsets.all(5),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(10, 40, 10, 40),
                      height: 200,
                      width: 150,
                      child: Column(
                        children: [
                          Material(
                            child: InkWell(
                              onTap: () async {
                                // String str = await Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => BookDetailsScreen(bookModel: book))
                                // );
                                
                                // if (str == "delete") {
                                //   load();
                                // }         //Show notification upon success
                              },
                              child:  Container(
                                constraints: BoxConstraints.expand(
                                  height: Theme.of(context).textTheme.headline4.fontSize * 1.1 + 200.0,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                ),
                                width: 150,
                                child:Image.network(book.coverURL),
                              ),
                            )
                          ),
                          Text(
                            book.title, 
                            style: TextStyle(fontWeight: FontWeight.bold)
                          )
                        ]
                      )
                    )  
                  );
                },
            )
          );
      }
      
    }
    else{
    
      return Scaffold(
        appBar: AppBar(title: const Text('Library')),
        body: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.tealAccent,
          ),
        )
      );


    }
   
    
  }


}