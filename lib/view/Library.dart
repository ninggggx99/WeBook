import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
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

   @override
  Widget build(BuildContext context) {
    final library = Provider.of<LibraryProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Library')),
      body: 
       new FutureBuilder(
        future:  library.getBooks(auth.user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final book = snapshot.data[index];
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
                              String str = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => BookDetailsScreen(book, false))
                              );
                              
                              if (str == "delete") {
                                setState(() {
                                  //rebuild
                                });
                              }         //Show notification upon success
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
            );
          } else if (snapshot.data == null) {
            return Container(
              alignment: Alignment(0.0, 0.0),
              child: Text(
                "Explore new books and add it to your library!",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = LinearGradient(
                colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))
                ),
              )
            );
          } else if (snapshot.hasError) {
            var children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            );
          } else {
            return Container(
              alignment: Alignment(0.0, 0.0),
              child: CircularProgressIndicator(),
            );
          }
        }
      )
    );
  }


}