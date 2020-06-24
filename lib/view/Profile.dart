import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view/BookDetailsScreen.dart';
import 'package:webookapp/view/EditProfileScreen.dart';
import 'package:webookapp/view/ChangePassword.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/file_provider.dart';
import 'package:webookapp/view_model/home_provider.dart';
import 'package:webookapp/view_model/library_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  User _user;
  AuthProvider _auth;
  LibraryProvider library;
  FileProvider file;
  List<Book> _book;

  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<AuthProvider>(context);
    library = Provider.of<LibraryProvider>(context);
    file = Provider.of<FileProvider>(context);
    load();
  }

  void load() async {
    if (_auth.user.uid != null){
      final user = await _auth.retrieveUser();
      final book = await library.getBooks(_auth.user.uid);
      setState(() {
        _user = user;
        _book = book;
        print(book.length);
        if (_user.profilePic == null ||_user.profilePic == " "){
          _user.profilePic = "https://img.icons8.com/pastel-glyph/2x/person-male.png";
        }
      });
    }
    else{
      _user = null;
    }
   
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final feed = Provider.of<HomeProvider>(context);
    if (_user == null){
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.tealAccent,
          ),
          )
      );
    }
    else{
      return Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration( color:const Color(0x009688).withOpacity(0.5)),
              ),
              Container(
                margin: EdgeInsets.only(top: 160.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              Column(
                children: <Widget>[
                  //profile picture
                  Padding(
                    padding: EdgeInsets.only(top: 100.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white60, width: 2.0),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: CircleAvatar(                          
                            backgroundImage: NetworkImage(_user.profilePic),
                            backgroundColor: Colors.grey.shade200,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                      children: <Widget>[
                        Text(
                          _user.firstName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          _user.role,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                   
                    _book == null
                    ?Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                            backgroundColor: const Color(0x009688),
                        ),
                        Text(
                          'Loading..',
                          style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                              ),
                        )
                      ],
                    )
                    :ListView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: <Widget>[
                           Container(                     
                            padding: EdgeInsets.only(left: 25),
                            margin: EdgeInsets.only(top: 0),
                            height: 20,
                            child:
                              Text(
                                'Work by me',
                                style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500  ,
                                  color: Colors.grey.shade600
                                ),
                              ),
                          ),
                          Container(
                          height: 150,
                          padding: EdgeInsets.only(top: 10 ),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.only(left:25, right:6, ),
                                  itemCount: _book.length,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index){
                                    final book = _book[index];
                                    return Container(
                                      margin: EdgeInsets.only(right:19),
                                      height: 150,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xe0f2f1),
                                        image: DecorationImage(
                                          image: NetworkImage(book.coverURL),
                                          fit: BoxFit.fill,
                                          
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () async{
                                          await Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => BookDetailsScreen(book,_auth))
                                          );
                                        }
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          )
                        ),
                        SizedBox(height: 10),
                        Container(                     
                          padding: EdgeInsets.only(left:25),
                          height: 20,
                          child:
                            Text(
                              'My Reading List',
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w500  ,
                                color: Colors.grey.shade600
                              ),
                            ),
                        ),
                        Container(
                          height: 150,
                          padding: EdgeInsets.only(top: 10 ),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.only(left:25, right:6, ),
                                  itemCount: _book.length,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index){
                                    final book = _book[index];
                                    return Container(
                                      margin: EdgeInsets.only(right:19),
                                      height: 150,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xe0f2f1),
                                        image: DecorationImage(
                                          image: NetworkImage(book.coverURL),
                                          fit: BoxFit.fill,
                                          
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () async{
                                          await Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => BookDetailsScreen(book,_auth))
                                          );
                                        }
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          )
                        ),

                      ],
                    )
                    
                  ],
                ),
              // settings button
              Align(
                alignment: Alignment(1.4, -1.1),
                child: Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: FlatButton(onPressed: ()=> _scaffoldKey.currentState.openEndDrawer() ,child: new Icon(Icons.settings, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
        endDrawer: Drawer(
          elevation: 20.0,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              
              UserAccountsDrawerHeader(
                accountName: Text(_user.firstName), 
                accountEmail: Text(_user.email),
                decoration: BoxDecoration(
                  color:const Color(0x009688).withOpacity(0.5),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(_user.profilePic),
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
              ListTile(
                title: Text('Edit Profile'),
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen())).then((value) => setState((){print("hi"); load();}));
                },
              ),
              ListTile(
                title: Text('Change Password'),
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
                },
              ),
              ListTile(
                title: Text('Logout'),
                onTap:(){
                  logout() async{
                    await _auth.signOut().then((__) =>  Navigator.pushNamedAndRemoveUntil(context, "/logIn", (r) => false)); 
                   
                  }
                  logout(); 
                  Navigator.pop(context);
                },
              ),
            ]
          )
        ) ,
      );

    }
   
  }
}

// Container(
//                     height: 200,
//                     margin: EdgeInsets.only(top:5),
//                     padding: EdgeInsets.only(left: 25),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           'Works by me',
//                           style: GoogleFonts.openSans(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(top:21),
//                           height:150,
//                           child: ListView.builder(
//                             padding: EdgeInsets.only(left:25, right:6),
//                             itemCount: _bookwritten.length,
//                             physics: BouncingScrollPhysics(),
//                             scrollDirection: Axis.horizontal,
//                             itemBuilder: (context, index){
//                               final book = _bookwritten[index];
//                               return Container(
//                                 margin: EdgeInsets.only(right:19),
//                                 height: 180,
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: const Color(0xe0f2f1),
//                                   image: DecorationImage(
//                                     image: NetworkImage(book.coverURL),
//                                     fit: BoxFit.scaleDown
//                                   ),
//                                 ),
//                                 child: InkWell(
//                                   onTap: () async{
//                                     await Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(builder: (context) => BookDetailsScreen(book,_auth))
//                                     );
                                    
//                                     // if (str == "delete") {
//                                     //   load();
//                                     // } 
//                                   }
//                                 ),
//                               );
//                             },
//                           ),
//                         )

//                       ],
//                     ),

//                   ),