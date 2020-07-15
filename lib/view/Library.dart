import 'package:epub_kitty/epub_kitty.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view/BottomNavBar.dart';

import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/download_provider.dart';
import 'package:webookapp/view_model/file_provider.dart';
import 'package:webookapp/view_model/library_provider.dart';

import 'package:webookapp/widget/custom_bookItem.dart';
import 'package:webookapp/widget/custom_deleteBookAlert.dart';
import 'package:webookapp/widget/custom_loadingPage.dart';
import 'package:webookapp/widget/custom_text.dart';

class LibraryPage extends StatefulWidget{
  LibraryPage({Key key}) : super(key:key);
  @override
  _LibraryPageState createState(){
      return _LibraryPageState();
  }
}
class _LibraryPageState extends State<LibraryPage>{
  AuthProvider auth;
  LibraryProvider library;
  FileProvider file;
  DownloadProvider downloadProvider;
  User user;
  List<Book> _book;
  bool delete = false;
  
  void didChangeDependencies() {
    super.didChangeDependencies();
    auth = Provider.of<AuthProvider>(context);
    library = Provider.of<LibraryProvider>(context);
    file = Provider.of<FileProvider>(context);
    downloadProvider = Provider.of<DownloadProvider>(context);
    load();
  }
  void load() async{
    if(auth.user.uid != null){
      print(auth.user.uid);
      final book = await library.getBooks(auth.user.uid);
      setState(() {
        _book = book;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
      if ( _book != null){       
        return Scaffold(          
          body: Container(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 25, top:25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomText(
                        text: 'What are you',                        
                        size: 22,
                        weight: FontWeight.w100,
                        colors: Colors.black                        
                      ),
                      Row(
                        children: <Widget>[
                          CustomText(
                            text: 'reading ',
                            size: 22,
                            weight: FontWeight.w100,
                            colors: Colors.black
                          ),
                          CustomText(
                            text: 'today ?',
                            size: 22,
                            weight: FontWeight.w600,
                            colors: Colors.black                            
                          )
                        ],
                      )
                    ],
                  )
                ),
                GridView.builder(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                  shrinkWrap: true,
                  itemCount: _book.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 200 / 300,
                  
                  ),
                  itemBuilder: (context,index){
                    final book =_book[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal:8),
                      child: _bookItem(context,book),
                    );
                  },
                )
              ]
            )
          )
        );
      }
      else{
        return CustomLoadingPage();
      }
    
  }

  Widget _bookItem(BuildContext context, Book book){
     final pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
     return InkWell(
      onLongPress: () async{
        showModalBottomSheet(
          context: context, 
          builder: (context) {
            return Container(
              height: 250,
              color: Color(0xFF737373),
              child: Container(                 
                child: _buildBottomSheet(context,book),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10)
                  )
                ),
              ),
            );
          }
        );
      
      },
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
              book.coverURL,
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
  Widget _buildBottomSheet (BuildContext context,Book book){
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Row(
          children: <Widget>[   
            SizedBox(width: 10),         
            Container(
              height: 81,
              width: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(book.coverURL)),
                color: const Color(0xe0f2f1),
              ),
            ),
            SizedBox(
              width: 21,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomText(
                  text: book.title,
                  size: 16,
                  weight: FontWeight.w600,
                  colors: Colors.black
                ),
                SizedBox(height: 5),
                CustomText(
                  text:book.authorName,
                  size: 14,
                  weight: FontWeight.w400,
                  colors: Colors.black
                ),
                SizedBox(height: 5),
                CustomText(
                  text: book.category,
                  size: 16,
                  weight: FontWeight.w600,
                  colors: Colors.black
                ),
              ],
            ) 
          ],
        ),
        SizedBox(height:15),
        ListTile(
          leading: Icon(Icons.file_download),
          title: CustomText(
                  text: 'Download',
                  colors: Colors.black,
                  size: 14,
                  weight: FontWeight.normal,
                ),
          onTap: () async {
            
            await downloadProvider.downloadBook(context, book.bookURL, book.title, book.key, auth.user.uid);
            print("downloaded");
            // if(downloaded == true){
            //   Navigator.pop(context);
            // }
           
          },
        ),
        ListTile(
          leading: Icon(Icons.delete),
          title: CustomText(
                  text: 'Remove from Library',
                  colors: Colors.black,
                  size: 14,
                  weight: FontWeight.normal,
                ),
          onTap: () async{
            void _showDialog(BuildContext ancestorCont) async{
              await showDialog(
                context: context,
                builder: (BuildContext context){
                  return CustomDeleteBookAlert(book, library, auth);
                }
              ).then((value){
                Navigator.of(context).pop();
                setState(() {
                            print("hi");
                            load();
                });
              });             
            }
            _showDialog(context);           
           
          },
        ),
      ],
    );
  }

}