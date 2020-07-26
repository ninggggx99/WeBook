import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/user_model.dart';

import 'package:webookapp/view/BookDetailsScreen.dart';
import 'package:webookapp/view/EditProfileScreen.dart';
import 'package:webookapp/view/ChangePassword.dart';
import 'package:webookapp/view/logIn.dart';

import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/file_provider.dart';
import 'package:webookapp/view_model/home_provider.dart';
import 'package:webookapp/view_model/library_provider.dart';
import 'package:webookapp/widget/custom_loadingPage.dart';
import 'package:webookapp/widget/custom_text.dart';

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
  List<Book> _userBook;
  bool signout = false;
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<AuthProvider>(context);
    library = Provider.of<LibraryProvider>(context);
    file = Provider.of<FileProvider>(context);
    load();
  }

  void load() async {
    print("load" );
    print(_auth == null);
    if (signout == false) {
      final user = await _auth.retrieveUser();
      final book = await library.getBooks(_auth.user.uid);
      final userBook = await library.getUserBooks(_auth.user.uid);
      setState(() {
        _user = user;
        _book = book;
        _userBook = userBook;
        // print(book.length);
        if (_user.profilePic == null || _user.profilePic == " ") {
          _user.profilePic =
              "https://img.icons8.com/pastel-glyph/2x/person-male.png";
        }
      });
    } else {
      _user = null;
    }
  }
   

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final feed = Provider.of<HomeProvider>(context);
    if (_user == null) {
      return CustomLoadingPage();
    } else {
      return Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: const Color(0x009688).withOpacity(0.5)),
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
                            border:
                                Border.all(color: Colors.white60, width: 2.0),
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
                      CustomText(
                        text: _user.firstName,
                        weight: FontWeight.bold,
                        size: 18.0,
                        colors: Colors.black,
                      ),
                      CustomText(
                        text: _user.role,
                        weight: FontWeight.bold,
                        size: 12.0,
                        colors: Colors.black,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20
                        ),
                        _user.role =="Bookworm" ? 
                        Container()
                        :(Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(left: 25),
                                height: 20,
                                child: CustomText(
                                    text: 'Work by me',
                                    size: 16,
                                    weight: FontWeight.w500,
                                    colors: Colors.grey.shade600),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 0, right: 0, top: 20),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.20,
                                        child:
                                            _buildListView(_userBook)),
                                  ],
                                )
                              )
                            ],
                          ),
                        )),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(left: 25),
                                height: 20,
                                child: CustomText(
                                    text: 'My Reading List',
                                    size: 16,
                                    weight: FontWeight.w500,
                                    colors: Colors.grey.shade600),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 0, right: 0, top: 20),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.20,
                                        child:
                                            _buildListView(_book)),
                                  ],
                                )
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
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
                  child: FlatButton(
                      onPressed: () =>
                          _scaffoldKey.currentState.openEndDrawer(),
                      child: new Icon(Icons.settings, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
        endDrawer: Drawer(
            elevation: 20.0,
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: CustomText(
                  text: _user.firstName,
                  size: 14,
                  weight: FontWeight.bold,
                  colors: Colors.black,
                ),
                accountEmail: CustomText(
                  text: _user.email,
                  size: 12,
                  weight: FontWeight.w400,
                  colors: Colors.black,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x009688).withOpacity(0.5),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(_user.profilePic),
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
              ListTile(
                title: CustomText(
                  text: 'Edit Profile',
                  size: 14,
                  weight: FontWeight.normal,
                  colors: Colors.black,
                ),
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfileScreen()))
                      .then((value) => setState(() {
                            print("hi");
                            load();
                          }));
                },
              ),
              ListTile(
                title: CustomText(
                  text: 'Change Password',
                  size: 14,
                  weight: FontWeight.normal,
                  colors: Colors.black,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen()));
                },
              ),
              ListTile(
                title: CustomText(
                  text: 'Logout',
                  size: 14,
                  weight: FontWeight.normal,
                  colors: Colors.black,
                ),
                onTap: () {
                  logout() async {
                   Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => LogInPage()
                    ),
                     (r) => false);
                    setState(() {
                      signout = true;
                    });
                    await _auth.signOut();
                   print ("logout");
                   
                    // setState(() {
                    //   _auth = null;
                    //   _user = null;
                    //   _book = null;
                    // });
                    
                    
                  }

                  logout();
                  
                  // Navigator.pushNamedAndRemoveUntil(
                  //       context, "/logIn", (r) => false);
                },
              ),
            ])),
      );
    }
  }

  Widget _buildListView(List<Book> _book) {
    return ListView.builder(
      padding: EdgeInsets.only(left: 25, right: 6),
      itemCount: _book.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final book = _book[index];
        return Container(
          margin: EdgeInsets.only(right: 19),
          height: 0,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xe0f2f1),
            image: DecorationImage(
              image: NetworkImage(book.coverURL),
              fit: BoxFit.fill,
            ),
          ),
          child: InkWell(onTap: ()  {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BookDetailsScreen(book, _auth))).then((value) => setState(() {
                            print("hi");
                            load();
                          }));
          }),
        );
      },
    );
  }
}
