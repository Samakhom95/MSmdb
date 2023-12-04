import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:movie_silver/services/api_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as img;

class FullImageScreen extends StatefulWidget {
  final String imgUrl;
  const FullImageScreen({super.key, required this.imgUrl});

  @override
  State<FullImageScreen> createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  final uuid = const Uuid();

 late Uint8List imageFile;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    var response = await http.get(Uri.parse('${TMDB_BASE_IMAGE_URL}w500/${widget.imgUrl}'));
    if (response.statusCode == 200) {
      // Use the 'image' package to decode the response body into a Uint8List
      var decodedImage = img.decodeImage(response.bodyBytes);
      if (decodedImage != null) {
        setState(() {
          // Set the decoded image as the imageFile
          imageFile = Uint8List.fromList(img.encodePng(decodedImage));
        });
      }
    } else {
      throw Exception('Failed to load image');
    }
  }

  void save(image) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = await File('${directory.path}/${uuid.v4()}.png').create();
    await imagePath.writeAsBytes(image);
    await GallerySaver.saveImage(
      imagePath.path,
    );
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Image Saved!!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.save_alt_rounded), onPressed:() => {save(imageFile)},)
        ],
      ),
      backgroundColor: Colors.black87,
      body: ListView(
        physics: const BouncingScrollPhysics(),

        children: [
          const SizedBox(
            height: 60,
          ),
          PinchZoomReleaseUnzoomWidget(
            child: Image.network(
              fit: BoxFit.cover,
              '${TMDB_BASE_IMAGE_URL}w500/${widget.imgUrl}',
            ),
          ),
        ],
      ),
    );
  }
}
