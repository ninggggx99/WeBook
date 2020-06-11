
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/view_model/auth_provider.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:webookapp/view/BookDetailsScreen.dart';
import 'package:webookapp/view_model/home_provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final feed = Provider.of<HomeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: 
       new FutureBuilder(
        future: feed.getBooks(),
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BookDetailsScreen(book))
                            );
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
