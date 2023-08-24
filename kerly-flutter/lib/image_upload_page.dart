import 'package:flutter/material.dart';
import 'package:kerly/item_control_page.dart';
import 'package:kerly/item_detail_page.dart';
import 'file_upload.dart';

class ImageUploadPage extends StatefulWidget {
  final int id;
  final String username;
  final String itemName;
  final String itemType;
  const ImageUploadPage({Key? key, required this.id, required this.username, required this.itemType, required this.itemName}) : super(key: key);

  @override
  State<ImageUploadPage> createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _uploadFileAndNavigate();
  }

  Future<void> _uploadFileAndNavigate() async {
    setState(() {
      _isLoading = true;
    });

    await FileUpload.deleteFile(widget.id);
    await FileUpload.uploadFile(widget.id, widget.username, widget.itemType, widget.itemName);

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ItemDetailPage(id: widget.id),
    //   ),
    // );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ItemControlPage(),
      ),
    );


    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
