import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view/SearchScreen.dart';
import 'package:webookapp/view_model/auth_provider.dart';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:webookapp/view/BookDetailsScreen.dart';
import 'package:webookapp/view_model/home_provider.dart';
import 'package:webookapp/widget/custom_homeTabBar.dart';
import 'package:webookapp/widget/custom_loadingPage.dart';
import 'package:webookapp/widget/custom_text.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthProvider auth;
  HomeProvider home;
  User _user;

  List<Book> _bookRec;
  List<Book> _bookPop;
  List<Book> _bookRate;

  TextEditingController searchController = TextEditingController();

  void didChangeDependencies() {
    super.didChangeDependencies();
    auth = Provider.of<AuthProvider>(context);
    home = Provider.of<HomeProvider>(context);
    load();
  }

  void load() async {
    if (auth.user.uid != null) {
      final bookRec = await home.getBookByRecency(auth.user.uid);
      final bookPop = await home.getBookByVolume(auth.user.uid);
      final bookRate = await home.getBookByRatings(auth.user.uid);
      final user = await auth.retrieveUser();
      setState(() {
        _bookRec = bookRec;
        _bookPop = bookPop;
        _bookRate = bookRate;
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null ||
        _bookRec == null ||
        _bookPop == null ||
        _bookRate == null) {
      return CustomLoadingPage();
    }
    else{
       return Scaffold(
       
        body: Container(
            child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 25, top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(
                    text: 'Hi, ' + _user.firstName,
                    size: 14,
                    weight: FontWeight.w600,
                    colors: Colors.grey
                  ),
                  CustomText(
                    text:'Discover Latest Book',
                    size: 22,
                    weight: FontWeight.w600,
                    colors: Colors.black
                  )
                ],
              ),
            ),
            Container(
              height: 39,
              margin: EdgeInsets.only(left: 25, right: 25, top: 18),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade100),
              child: Stack(
                children: <Widget>[
                  TextField(
                    controller: searchController,
                    maxLengthEnforced: true,
                    style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 19, right: 50, bottom: 8),
                        border: InputBorder.none,
                        hintText: 'Search book..',
                        hintStyle: GoogleFonts.openSans(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600)),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                          height: 39,
                          margin: EdgeInsets.only(left: 25, right: 0, top: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0x009688).withOpacity(0.5),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.only(top: 0, bottom: 0),
                            icon: Icon(Icons.search),
                            color: Colors.white,
                            iconSize: 30,
                            onPressed: () async {
                              String search = searchController.text;
                              searchController.clear();
                              if (search != null && search != ""){
                              
                                List<Book> searchResult = await home.searchResultBook(search, auth.user.uid);
                                if (searchResult.isEmpty){
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text("Book not found"),)
                                  );   
                                }
                                else{
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SearchBookScreen(auth,searchResult,search)));
                                }
                                
                              }
                              
                            },
                          )))
                ],
              ),
            ),
            CustomHomeTabBar(
              auth: auth,
              newBook: _bookRec,
              bestBook: _bookRate,
              trendBook: _bookPop,
            ),
            Padding(
                padding: EdgeInsets.only(left: 25, top: 25, bottom: 25),
                child: Text(
                  'Popular',
                  style: GoogleFonts.openSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                )),
            RaisedButton(
              child: Text('Color Changed'),
              onPressed: () async {
                await home.addComment("-MAtrrYb1TIdVOKIkPsh",
                    "2Xm3ecEYwtVZ3KScvijQWB7UxM13", "this is the NEWNEWNEWNWENW comment", 5);
                print("daone");
              },
            ),
            ListView.builder(
              padding: EdgeInsets.only(left: 25, right: 6),
              itemCount: _bookPop.length,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final book = _bookPop[index];
                return GestureDetector(
                    onTap: () async {
                      print('vertical tapped');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BookDetailsScreen(book, auth,true,false)));
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
                        )));
              },
            ),
          ],
        )),
      );
    }
  }
}

