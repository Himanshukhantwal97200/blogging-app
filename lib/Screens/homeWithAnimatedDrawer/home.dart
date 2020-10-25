import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shortblogapp/Screens/textEditor/text_editor.dart';
import 'package:shortblogapp/Screens/welcomeWithAuthentication/welcome.dart';
import 'package:shortblogapp/components/fadeAnimation.dart';
import 'package:shortblogapp/services/auth.dart';
import 'components/drawer_items.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  AuthService _auth = AuthService();

  bool isCollapsed = true;
  double screenWidth, screenHeight;
  Duration duration = Duration(milliseconds: 500);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.6).animate(_controller);
    _menuScaleAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;

    return Stack(
      children: [
        drawer(context),
        home(context),
      ],
    );
  }

  Widget drawer(context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _menuScaleAnimation,
          child: Align(
            alignment: Alignment.centerLeft,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(50)),
                  color: Colors.black38,
                ),
                width: screenWidth * 0.58,
                height: screenHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.blue[600],
                          width: double.infinity,
                          height: screenHeight * 0.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                // if the user has signed in with google then we'll use google gmail image otherwise use this image
                                backgroundImage: AssetImage(
                                    "assets/images/generic-profile-picture.jpg"),
                                minRadius: 35,
                                maxRadius: 45,
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Moamen",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              drawerItems(
                                  text: "Home",
                                  onTap: () {
                                    setState(() {
                                      isCollapsed = true;
                                      _controller.reverse();
                                    });
                                  }),
                              SizedBox(height: screenHeight * 0.025),
                              drawerItems(text: "Favorites", onTap: () {}),
                              SizedBox(height: screenHeight * 0.025),
                              drawerItems(text: "Interests", onTap: () {}),
                              SizedBox(height: screenHeight * 0.025),
                              drawerItems(text: "Your Stories", onTap: () {}),
                              SizedBox(height: screenHeight * 0.025),
                              drawerItems(text: "Subscriptions", onTap: () {}),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Align(
                          heightFactor: 5,
                          widthFactor: 5,
                          child: GestureDetector(
                            onTap: () async {
                              await _auth.signOut();
                              Navigator.pop(context);
                              Navigator.pushNamed(context, Welcome.id);
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "Log out  ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.red)),
                                WidgetSpan(
                                    child:
                                        Icon(Icons.logout, color: Colors.red))
                              ]),
                            ),
                          ),
                          alignment: Alignment.center,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget home(context) {
    return AnimatedPositioned(
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : screenWidth * 0.4,
      right: isCollapsed ? 0 : screenWidth * -0.6,
      duration: duration,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          animationDuration: duration,
          borderRadius: isCollapsed != true
              ? BorderRadius.all(Radius.circular(40))
              : null,
          elevation: 10,
          child: ClipRRect(
            borderRadius: isCollapsed != true
                ? BorderRadius.all(Radius.circular(40))
                : BorderRadius.zero,
            child: Scaffold(
              appBar: AppBar(
                leading: InkWell(
                  child: Icon(
                      isCollapsed
                          ? Icons.double_arrow_rounded
                          : Icons.arrow_back_ios_sharp,
                      color: Colors.black),
                  onTap: () {
                    setState(() {
                      if (isCollapsed) {
                        _controller.forward();
                      } else {
                        _controller.reverse();
                      }
                      isCollapsed = !isCollapsed;
                    });
                  },
                ),
                actions: [
                  Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  SizedBox(width: 20),
                  Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.black,
                  ),
                  SizedBox(width: 20),
                ],
                title: Text("Blogging App"),
              ),
              floatingActionButton: FadeAnimation(
                1,
                FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, TextEditor.id);
                  },
                  child: new Icon(Icons.edit_outlined),
                ),
              ),
              body: Container(
                child: Center(
                  child:
                      Text('Here we will load blogs from realtime firestore'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
