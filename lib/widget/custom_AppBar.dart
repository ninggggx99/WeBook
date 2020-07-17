
import 'package:flutter/material.dart';
import 'package:webookapp/widget/custom_text.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String text;

  CustomAppBar({
    Key key,
    @required this.text,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
   return AppBar(
      iconTheme: IconThemeData(
        color:const Color(0x009688).withOpacity(0.8)
      ),
      title: CustomText(text: text, size: 22, weight: FontWeight.w500, colors: Colors.black),
      backgroundColor:  const Color (0x00FFFFFF).withOpacity(1),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}