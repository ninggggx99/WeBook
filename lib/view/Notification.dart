import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/comment_model.dart';
import 'package:webookapp/model/notification_model.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/notification_provider.dart';
import 'package:webookapp/widget/custom_loadingPage.dart';
import 'package:webookapp/widget/custom_text.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  AuthProvider auth;
  NotiProvider noti;

  List<Message> _notiMessage;
  List<Book> _notiBook;
  List<User> _notiUser;
  List<Comment> _notiComment;

  List<Message> _notiMessageWk;
  List<Book> _notiBookWk;
  List<User> _notiUserWk;
  List<Comment> _notiCommentWk;

  void didChangeDependencies() {
    super.didChangeDependencies();
    auth = Provider.of<AuthProvider>(context);
    noti = Provider.of<NotiProvider>(context);
    load();
  }

  void load() async {
    print(auth.user.uid);
    final notiMessage = await noti.getTodayNoti(auth.user.uid);
    final notiBook = await noti.getCommentedBook(notiMessage);
    final notiUser = await noti.getCommentedUser(notiMessage);
    final notiComment = await noti.getCommentedComment(notiMessage);

    final notiMessageWk = await noti.getWeekNoti(auth.user.uid);
    final notiBookWk = await noti.getCommentedBook(notiMessageWk);
    final notiUserWk = await noti.getCommentedUser(notiMessageWk);
    final notiCommentWk = await noti.getCommentedComment(notiMessageWk);
    print(notiMessage);
    setState(() {
      _notiMessage = notiMessage;
      _notiBook = notiBook;
      _notiUser = notiUser;
      _notiComment = notiComment;

      _notiMessageWk = notiMessageWk;
      _notiBookWk = notiBookWk;
      _notiUserWk = notiUserWk;
      _notiCommentWk = notiCommentWk;
    });
  }
  Widget _buildMessage(Message notim, Book book, User user,Comment comment){
    return GestureDetector(
      onTap: ()async {

      },
      child: Container(
        margin: EdgeInsets.only(bottom: 19),
        height: 81,
        width: MediaQuery.of(context).size.width - 50,
        child: Row(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  user.profilePic != ""? user.profilePic :   "https://img.icons8.com/pastel-glyph/2x/person-male.png" ,
                  height: 71,
                  width: 71,
                ),
            ),
            SizedBox(
              width: 21,
            ),
            Expanded( 
                  
              child: Column(
                children: <Widget>[
                  CustomText(
                    text: user.firstName + " commented: " + comment.commentDesc ,
                    size: 14,
                    weight: FontWeight.w400,
                    colors: Colors.black
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  book.coverURL != null? book.coverURL :   "https://img.icons8.com/pastel-glyph/2x/person-male.png" ,
                  height: 71,
                  width: 71,
                ),
            ),
          ],
        )
      )
    );
    // print("building");
    // return ListTile(
    //   title: Text(notim.title),
    //   subtitle: Text(notim.body)
    // );
  }
  @override
  Widget build(BuildContext context) {
    // _handleMessages(context);
   
    if (_notiMessage == null || _notiMessageWk == null){
      return CustomLoadingPage();
    }
    else{
       return Scaffold(
        body: Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 25, top:25),
                child: Row(                   
                  children: <Widget>[                      
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,      
                      children: <Widget>[
                        CustomText(
                            text: 'Notification',                        
                            size: 22,
                            weight:FontWeight.w600,
                            colors: Colors.black                        
                        ),
                        
                      ],
                    ),
                    SizedBox(width: 10,)
                  ],
                )
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, top: 25, bottom: 5),
                child: CustomText(
                  text:'Today',
                  size: 20,
                  weight: FontWeight.w200,
                  colors: Colors.black),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Column(
                  children: <Widget>[
                    Container (
                      color: Colors.blue,
                    ),
                    ListView.builder(
                      padding: EdgeInsets.only(left: 25, right: 6, top: 20),
                      itemCount: _notiMessage.length,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final message = _notiMessage[index];
                        final book = _notiBook[index];
                        final user = _notiUser[index];
                        final comment = _notiComment[index];
                        return _buildMessage(message,book,user,comment);
                        
                        },
                    ),
                  ],
                )
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, top: 25, bottom: 5),
                child: CustomText(
                  text:'This Week',
                  size: 20,
                  weight: FontWeight.w200,
                  colors: Colors.black),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Column(
                  children: <Widget>[
                    Container (
                      color: Colors.blue,
                    ),
                    ListView.builder(
                      padding: EdgeInsets.only(left: 25, right: 6, top: 20),
                      itemCount: _notiMessageWk.length,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final message = _notiMessageWk[index];
                        final book = _notiBookWk[index];
                        final user = _notiUserWk[index];
                        final comment = _notiCommentWk[index];
                        return _buildMessage(message,book,user,comment);
                        
                        },
                    ),
                  ],
                )
              ),
              
            ],   
          ),
        )
      );
    }
   
  }

}

