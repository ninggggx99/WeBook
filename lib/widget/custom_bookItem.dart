import 'package:epub_kitty/epub_kitty.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/view_model/file_provider.dart';


class BookItem extends StatelessWidget {
  final String img;
  final String title;
  final Book book;
  final FileProvider file;

  BookItem({
    Key key,
    @required this.img,
    @required this.title,
    @required this.book,
    @required this.file,
  }) : super(key: key);

  // static final uuid = Uuid();
  // final String imgTag = uuid.v4();
  // final String titleTag = uuid.v4();
  // final String authorTag = uuid.v4();

  @override
  Widget build(BuildContext context) {
    final pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    return InkWell(
      onTap: () async{
       String epubPath = "";
        await pr.show();

        /* await file.createFileOfPdfUrl(widget.book.bookURL).then((f) {
          pdfPath = f.path;
        }); */

        await file.convertFile(book.bookURL).then((f) {
          epubPath = f.path;
        });
        /* await Navigator.push(context,
          MaterialPageRoute(builder: (context) => PDFScreen(pathPDF: pdfPath, book: widget.book,) )
        ); */
        
        await pr.hide();
        EpubKitty.setConfig('book', "#32a852", 'vertical', true);

        //This is the part experiencing errors for me
        EpubKitty.open(epubPath);
      },
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            child:Image.network(
              img,
              height: 150,
              fit: BoxFit.fill,
            )
          ),
          SizedBox(height: 5.0),
          Text(
            book.title, 
            style: TextStyle(fontWeight: FontWeight.bold)
          )
        ],
      ),
    );
  }
}