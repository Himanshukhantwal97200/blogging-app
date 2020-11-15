import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shortblogapp/Screens/welcomeWithAuthentication/components/color_design_button.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name =
      "Tom Malkova"; // what ever name the user put on the signUp screen will come here, if user signed up with google the gmail name will come here

  String bio = "Write bio here";
  File _image;
  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF141518),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 100,
                  child: ClipOval(
                      child: SizedBox(
                    height: 200,
                    width: 200,
                    child: (_image != null)
                        ? Image.file(_image, fit: BoxFit.cover)
                        : Image.asset(
                            "assets/images/generic-profile-picture.jpg",
                            fit: BoxFit.cover,
                          ),
                  )),
                ),
                CircleAvatar(
                  radius: 20,
                  foregroundColor: Colors.transparent,
                  backgroundColor: Colors.black38,
                  child: IconButton(
                    // color: Colors.blue,
                    icon: Icon(
                      Icons.camera_enhance_sharp,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      getImage();
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    _name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  radius: 15,
                  foregroundColor: Colors.transparent,
                  backgroundColor: Colors.black38,
                  child: IconButton(
                    // color: Colors.blue,
                    onPressed: () {
                      createDialog(context).then((value) {
                        setState(() {
                          _name = value;
                        });
                      });
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    bio,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w100),
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  radius: 15,
                  foregroundColor: Colors.transparent,
                  backgroundColor: Colors.black38,
                  child: IconButton(
                    // color: Colors.blue,
                    onPressed: () {
                      createDialog(context).then((value) {
                        setState(() {
                          bio = value;
                        });
                      });
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Flexible(
                  child: ColorDesignButton(
                    text: "10 Followers",
                    color: Colors.green.withOpacity(0.5),
                    callBack: () {},
                  ),
                ),
                Flexible(
                  child: ColorDesignButton(
                    text: "230 Following",
                    color: Colors.red.withOpacity(0.5),
                    callBack: () {},
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<String> createDialog(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Your Name"),
            content: TextField(
              controller: _controller,
            ),
            actions: [
              MaterialButton(
                elevation: 5.0,
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                elevation: 5.0,
                child: Text("Save"),
                onPressed: () {
                  Navigator.of(context).pop(_controller.text.toString());
                },
              )
            ],
          );
        });
  }
}
