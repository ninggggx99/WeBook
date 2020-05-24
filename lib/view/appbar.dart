import 'package:flutter/material.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  String title;

  AppBarCustom({this.title, this.height}):
   assert(title!=null);

  // const AppBarCustom({
  //   Key key, this.height,
  // }):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height : 80.0,
      padding: EdgeInsets.fromLTRB(25, 30, 20, 20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(104, 134, 197, 1), //blue
        // color: Color.fromRGBO(192, 242, 208, 1),
      ),      
      child:Text(
        title,         
        style: TextStyle(
          color: Color.fromRGBO(249, 249, 249, 1),
          fontSize: 25.0,
          fontWeight: FontWeight.w700,
        )
      )
    );
  }
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
