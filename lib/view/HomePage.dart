
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view_model/auth_provider.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:webookapp/view/BookDetailsScreen.dart';
import 'package:webookapp/view_model/home_provider.dart';
import 'package:webookapp/widget/custom_tab_indicator.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthProvider auth;
  HomeProvider home;
  User _user;
  List<Book> _book;
  
  void didChangeDependencies() {
    super.didChangeDependencies();
    auth = Provider.of<AuthProvider>(context);
    home = Provider.of<HomeProvider>(context);
    load();
  }
  void load() async{
    if(auth.user.uid != null){
      final book = await home.getBooks();
      final user = await auth.retrieveUser();
      setState(() {
        _book = book;
        _user = user;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    if(_user == null ||_book== null){
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
          child:ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 25, top:25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Hi, ' + _user.firstName,
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey
                      ),
                    ),
                    Text(
                      'Discover Latest Book',
                      style: GoogleFonts.openSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 39,
                margin: EdgeInsets.only(left:25, right: 25,top: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade100
                ),
                child: Stack(
                  children: <Widget>[
                    TextField(
                      maxLengthEnforced: true,
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w600
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left:19, right:50, bottom: 8),
                        border: InputBorder.none,
                        hintText: 'Search book..',
                        hintStyle: GoogleFonts.openSans(
                          fontSize:12,
                          color:Colors.grey,
                          fontWeight: FontWeight.w600                                          
                        )
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        height: 39,
                        margin: EdgeInsets.only(left:25, right: 0,top: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:const Color(0x009688).withOpacity(0.5),
                        ),
                      
                        child:IconButton(
                          padding: EdgeInsets.only(top:0, bottom:0) ,
                          icon: Icon(Icons.search),
                          color: Colors.white,
                          iconSize: 30,
                          onPressed: (){

                          },
                      )
                      )
                    )
                  ],
                ),
              ),
              Container(
                height: 25,
                margin: EdgeInsets.only(top:30),
                padding: EdgeInsets.only(left:25),
                child: DefaultTabController(
                  length: 3,
                  child: TabBar(
                    labelPadding: EdgeInsets.all(0),
                    indicatorPadding: EdgeInsets.all(0),
                    isScrollable: true,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700  
                    ),
                    unselectedLabelStyle: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                    ),
                    indicator: RoundedRectangleTabIndicator(
                      weight:2,
                      width: 10,
                      color: Colors.black
                    ),
                    tabs: <Widget>[
                      Tab(
                        child: Container(
                          margin:EdgeInsets.only(right:23),
                          child:Text('New'),
                        ) ,
                      ),
                      Tab(
                        child: Container(
                          margin:EdgeInsets.only(right:23),
                          child:Text('Trending'),
                        ) ,
                      ),
                      Tab(
                        child: Container(
                          margin:EdgeInsets.only(right:23),
                          child:Text('Best Rated'),
                        ) ,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:21),
                height: 200,
                child: ListView.builder(
                  padding: EdgeInsets.only(left:25, right:6),
                  itemCount: _book.length,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index){
                    final book = _book[index];
                    return Container(
                      margin: EdgeInsets.only(right:19),
                      height: 200,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xe0f2f1),
                        image: DecorationImage(
                          image: NetworkImage(book.coverURL),
                        ),
                      ),
                      child: InkWell(
                        onTap: () async{
                          String str = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BookDetailsScreen(book, false))
                          );
                          
                          if (str == "delete") {
                            load();
                          } 
                        }
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, top:25, bottom: 25),               
                child:  Text(
                    'Popular',
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black
                    ),
                  )
              ),
              ListView.builder(
                  padding: EdgeInsets.only(left:25, right:6),
                  itemCount: _book.length,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index){

                    final book = _book[index];
                    return GestureDetector(
                      onTap: (){
                        print('vertical tapped');
                        // Navigator.pushReplacement(context,
                        // MaterialPageRoute(
                        //   builder: (context) => BookDetailsScreen(book),
                        //   ),
                        // );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom:19),
                        height: 81,
                        width: MediaQuery.of(context).size.width - 50,                      
                        child: Row(
                          children: <Widget>[
                            Container(
                              height:81,
                              width:62,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: NetworkImage(book.coverURL)
                                ),
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
                                Text(
                                  book.title,
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black
                                  ),
                                ),
                                SizedBox(height:5),
                                Text(
                                  book.authorName,
                                  style: GoogleFonts.openSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black
                                  ),
                                ),
                                SizedBox(height:5),
                                Text(
                                  book.category,
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black
                                  ),                            
                                ),
                                
                              ],
                            )
                          ],
                        )
                      )
                    );
                    
                  },
                ),
            ],
          )
        ),
        // appBar: AppBar(title: const Text('Home')),
        // body: 
        //  new FutureBuilder(
        //   future: feed.getBooks(),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return ListView.builder(
        //         scrollDirection: Axis.horizontal,
        //         itemCount: snapshot.data.length,
        //         itemBuilder: (context, index) {
        //           final book = snapshot.data[index];
        //           return Padding( 
        //             padding: EdgeInsets.all(5),
        //             child: Container(
        //             margin: const EdgeInsets.fromLTRB(10, 40, 10, 40),
        //             height: 200,
        //             width: 150,
        //             child: Column(
        //               children: [
        //                 Material(
        //                   child: InkWell(
        //                     onTap: () {
        //                       //Home Page's Book Details
        //                       Navigator.push(
        //                         context,
        //                         MaterialPageRoute(builder: (context) => BookDetailsScreen(book, true))
        //                       );
        //                     },
        //                     child:  Container(
        //                       constraints: BoxConstraints.expand(
        //                         height: Theme.of(context).textTheme.headline4.fontSize * 1.1 + 200.0,
        //                       ),
        //                       decoration: BoxDecoration(
        //                         border: Border.all(),
        //                       ),
        //                       width: 150,
        //                       child:Image.network(book.coverURL),
        //                     ),
        //                   )
        //                 ),
        //                 Text(
        //                   book.title, 
        //                   style: TextStyle(fontWeight: FontWeight.bold)
        //                 )
        //               ]
        //             )
        //           )  
        //         );
        //        },
        //       );
        //     } else {
        //       return Container(
        //         alignment: Alignment(0.0, 0.0),
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //   }   
        // )
      );

    }
   
  }

}
