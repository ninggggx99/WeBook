import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  Color textcolor = Color.fromRGBO(104,134,197,1);
  //Color textcolor = Color.fromRGBO(192, 242, 208,1);
  @override
  Widget build(BuildContext context) {
    return Container(
      height : 75,
      padding: EdgeInsets.only(top: 5, bottom: 30, left: 0, right:0),
      color: Color.fromRGBO(249, 249, 249, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            color: textcolor,
            icon:Icon(Icons.home, size:35.0) ,
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          IconButton(
            color:textcolor,
            icon:Icon(Icons.library_books, size:35.0) ,
            onPressed: (){
               Navigator.pushReplacementNamed(context, '/library');
            },
          ),
          IconButton(
            color: textcolor,
            icon:Icon(Icons.create, size:35.0) ,
            onPressed: (){
               Navigator.pushReplacementNamed(context, '/createbook');
            },
          ),
          IconButton(
            color: textcolor,
            icon:Icon(Icons.notifications, size:35.0) ,
            onPressed: (){
               Navigator.pushReplacementNamed(context, '/notification');
            },
          ),
          IconButton(
            color: textcolor,
            icon:Icon(Icons.person, size: 35.0) ,
            onPressed: (){
               Navigator.pushReplacementNamed(context, '/profile');
            },
          ),

      ],
      ),
    );
  }
}
