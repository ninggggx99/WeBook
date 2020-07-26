import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/download_provider.dart';
import 'package:webookapp/view_model/file_provider.dart';
import 'package:webookapp/view_model/library_provider.dart';
import 'package:webookapp/widget/custom_text.dart';


// ignore: must_be_immutable
class CustomDeleteBookAlert extends StatelessWidget {
  final Book book;
  final LibraryProvider _libraryProvider;
  final AuthProvider _authProvider;
  final DownloadProvider _downloadProvider;
  final FileProvider _fileprovider;
  final bool own;
  CustomDeleteBookAlert(this.book, this._libraryProvider,this._authProvider, this._downloadProvider, this._fileprovider , this.own);

  @override
  Widget build(BuildContext context) {
     final pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    return AlertDialog(

      title: Text(
        "Are you sure you want to delete ${book.title} ?"),
      actions: <Widget>[
        FlatButton(
          child: CustomText(
              text: "Confirm",
              size: 14,
              weight: FontWeight.w600,
              colors: const Color(0x009688).withOpacity(0.9)),
          onPressed: () async {
            await pr.show();
            if (own == true){
              print("own");
              await _fileprovider.deleteBookP(book);
            }
            else{
              await _downloadProvider.removeBook(book.bookURL, book.title, book.key, _authProvider.user.uid);
              await _libraryProvider.deleteBook(
              book.key, _authProvider.user.uid);
            }
            
         
            print("deleted");
            Navigator.of(context).pop();
            await pr.hide();            
            
          },
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: CustomText(
              text: "Cancel",
              size: 14,
              weight: FontWeight.w600,
              colors: const Color(0x009688).withOpacity(0.9)),
        )
      ],
   );
  }
}
