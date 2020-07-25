import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/widget/custom_tab_indicator.dart';
import 'package:webookapp/view/BookDetailsScreen.dart';
import 'package:webookapp/view_model/auth_provider.dart';

class CustomHomeTabBar extends StatelessWidget {

  final List<Book> newBook;
  final List<Book> trendBook;
  final List<Book> bestBook;
  final AuthProvider auth;

  CustomHomeTabBar({
    Key key,
    @required this.newBook,
    @required this.trendBook,
    @required this.bestBook,
    @required this.auth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Container(
      height: 300,
      margin: EdgeInsets.only(top:15),
      padding: EdgeInsets.only(left:25),
      child: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             TabBar(
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
                width: 30,
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
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _buildListView(newBook),
                  _buildListView(trendBook),
                  _buildListView(bestBook)                  
                ],
              )
            )

          ],
        )
        
      ),
    );
  }
  Widget _buildListView (List<Book> _book){
    return ListView.builder(
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
              fit: BoxFit.fill,
              
            ),
          ),
          child: InkWell(
            onTap: () async{
              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BookDetailsScreen(book,auth,true,false))
              );
            }
          ),
        );
      },
    );

  }
}