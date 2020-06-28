
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final Color colors;


  CustomText({
    Key key,
    @required this.text,
    @required this.size,
    @required this.weight,
    @required this.colors,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
   return Text(
    text,
    style: GoogleFonts.openSans(
      fontSize: size,
      fontWeight: weight ,
      color: colors
    ),
   );
  }
}