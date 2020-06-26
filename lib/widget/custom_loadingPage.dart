
import 'package:flutter/material.dart';

import 'package:webookapp/widget/custom_text.dart';

class CustomLoadingPage extends StatelessWidget {
 


  CustomLoadingPage({
    Key key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
                backgroundColor: const Color(0x009688),
            ),
            CustomText(
              text: 'Loading..',
              size: 14,
              weight: FontWeight.w600,
              colors: Colors.black
            )
          ],
        )
      )
    );
  }
}