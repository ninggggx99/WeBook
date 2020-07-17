
import 'package:flutter/material.dart';
import 'package:webookapp/widget/custom_text.dart';

class CustomSubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback action;


  CustomSubmitButton({
    Key key,
    @required this.text,
    @required this.action
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
   return RaisedButton(
      elevation: 5.0,
      padding: EdgeInsets.all(15.0),

      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      color: const Color(0x009688).withOpacity(0.8),
      child: CustomText(
        text: text,
        size: 18.0, 
        colors: Colors.white,
        weight: FontWeight.w600,                            
      ),
      onPressed: action,
    );
  }

}