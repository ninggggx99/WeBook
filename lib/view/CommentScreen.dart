import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/comment_model.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/home_provider.dart';

class CommentScreen extends StatefulWidget {

  const CommentScreen({Key key, this.book}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();

  final Book book;

}

class _CommentScreenState extends State<CommentScreen> {
  
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final feed = Provider.of<HomeProvider>(context);
    return Scaffold (
      appBar: AppBar(
        title: Text("Comment Section"),
      ),
      body: Column(
        children: <Widget>[
          new FutureBuilder(
            future: feed.getComments(widget.book),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final Comment comment = snapshot.data[index];
                    String formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(comment.dateCreated);
                    return FutureBuilder(
                      future: auth.findUser(comment.userId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final User user = snapshot.data;
                          return Card(
                            child: ListTile(
                              leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: user.profilePic == null ? Image.asset('assets/logo_transparent.png',) : 
                                      Image.network(user.profilePic,),
                              ),
                              title: RichText(
                                text: TextSpan(
                                  text: user.firstName + " ",
                                    style: TextStyle(color: Colors.black, fontSize: 14),
                                  children: <TextSpan> [
                                    TextSpan(text: user.role, style: TextStyle(color: Colors.blueAccent, fontSize: 12))
                                  ]
                                )
                              ),
                              subtitle: Text(comment.commentDesc),
                              trailing: Text(formattedDate),
                            )
                          );
                        } else {
                          return Container(
                            alignment: Alignment(0.0, 0.0),
                            child: CircularProgressIndicator(),
                          );
                        }
                      }
                    ); 
              });
              } else {
                return Container(
                  alignment: Alignment(0.0, 0.0),
                  child: CircularProgressIndicator(),
                );
              }
            }   
          )
        ],
      )
    
    );
  }
}