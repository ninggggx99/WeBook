import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/view/PDFScreen.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/file_provider.dart';
import 'package:webookapp/view_model/library_provider.dart';

class LibraryPage extends StatefulWidget{
  LibraryPage({Key key}) : super(key:key);
  @override
  _LibraryPageState createState(){
      return _LibraryPageState();
  }
}
class _LibraryPageState extends State<LibraryPage>{

   @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final library = Provider.of<LibraryProvider>(context);
    final file = Provider.of<FileProvider>(context);
    final pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Library')),
      body: 
       new FutureBuilder(
        future:  library.getBooks(auth.user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final book = snapshot.data[index];
                return Padding( 
                  padding: EdgeInsets.all(5),
                  child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 40, 10, 40),
                  height: 200,
                  width: 150,
                  child: Column(
                    children: [
                      Material(
                        child: InkWell(
                          onTap: () async {
                            String pdfPath = "";
                            await pr.show();
                            await file.createFileOfPdfUrl(book.bookURL).then((f) {
                              pdfPath = f.path;
                            });
                            await pr.hide();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PDFScreen(pdfPath))
                            );
                          },
                          child:  Container(
                            constraints: BoxConstraints.expand(
                              height: Theme.of(context).textTheme.headline4.fontSize * 1.1 + 200.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(),
                            ),
                            width: 150,
                            child:Image.network(book.coverURL),
                          ),
                        )
                      ),
                      Text(
                        book.title, 
                        style: TextStyle(fontWeight: FontWeight.bold)
                      )
                    ]
                  )
                )  
              );
              },
            );
          } else {
            return Container(
              alignment: Alignment(0.0, 0.0),
              child: CircularProgressIndicator(),
            );
          }
        }
      )
    );

  }
}