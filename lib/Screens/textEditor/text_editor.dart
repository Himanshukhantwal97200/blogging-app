import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quill_delta_plus/quill_delta.dart';
import 'zefyr_plus/zefyr.dart';
import 'package:image_picker/image_picker.dart';

class TextEditor extends StatefulWidget {
  static String id = '/textEditor';
  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  ZefyrController _controller;

  FocusNode _focusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert("Start Writing Here\n");
    return NotusDocument.fromDelta(delta);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey _key = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
      ),
      body: Container(
        child: ZefyrScaffold(
          child: ZefyrEditor(
            key: _key,
            padding: EdgeInsets.all(16),
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            imageDelegate: MyAppZefyrImageDelegate(),
            mode: ZefyrMode.edit,
            keyboardAppearance: Brightness.light,
          ),
        ),
      ),
    );
  }
}

class MyAppZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
  @override
  Future<String> pickImage(ImageSource source) async {
    final file = await ImagePicker.pickImage(source: source);
    if (file == null) return null;
    return file.uri.toString();
  }

  @override
  Widget buildImage(BuildContext context, String key) {
    final file = File.fromUri(Uri.parse(key));
    final image = FileImage(file);
    return Image(image: image);
  }

  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;
}
