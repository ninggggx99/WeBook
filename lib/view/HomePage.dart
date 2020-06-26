
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view_model/auth_provider.dart';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:webookapp/view/BookDetailsScreen.dart';
import 'package:webookapp/view_model/home_provider.dart';
import 'package:webookapp/widget/custom_homeTabBar.dart';
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
      final book = await home.getBooks(auth.user.uid);
      final user = await auth.retrieveUser();
      setState(() {
        _book = book;
        _user = user;
      });
    }
  }
  @override
  void dispose(){
    super.dispose();
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
              custom_homeTabBar(
                auth: auth,
                newBook: _book,
                bestBook: _book,
                trendBook: _book,
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
                      onTap: () async{
                        print('vertical tapped');
                        Navigator.pushReplacement( context,
                            MaterialPageRoute(builder: (context) => BookDetailsScreen(book,auth))
                          );
        
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
      );

    }
   
  }

}
