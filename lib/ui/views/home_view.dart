import 'dart:io';
import 'dart:ui' as ui;
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/logout_view.dart';
import 'package:compound/ui/widgets/text_link.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  File _imageFile;
  List<Face> _faces;
  bool isLoading = false;
  ui.Image _image;

  Future getImage(bool isCamera) async {
    File image;
    if (isCamera) {
      // ignore: deprecated_member_use
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      // ignore: deprecated_member_use
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _imageFile = image;
      isLoading = true;
    });
    detectFaces(_imageFile);
  }

  detectFaces(File imageFile) async {
    final image = FirebaseVisionImage.fromFile(imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector();
    List<Face> faces = await faceDetector.processImage(image);
    if (mounted) {
      setState(() {
        _imageFile = imageFile;
        _faces = faces;
        _loadImage(imageFile);
      });
    }
  }

  _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then(
      (value) => setState(() {
        _image = value;
        isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff050210),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            isLoading
                ? Center(child: CircularProgressIndicator())
                : (_imageFile == null)
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextLink('Selecione uma imagem!!'),
                        ),
                      )
                    : Center(
                        child: Column(
                          children: <Widget>[
                            FittedBox(
                              child: SizedBox(
                                width: _image.width.toDouble(),
                                height: _image.height.toDouble(),
                                child: CustomPaint(
                                  painter: FacePainter(_image, _faces),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
            verticalSpaceSmall,
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 3.0,
                  ),
                  child: FloatingActionButton(
                    elevation: 2,
                    backgroundColor: Color(0xff222222),
                    heroTag: null,
                    onPressed: () {
                      getImage(true);
                    },
                    tooltip: 'Camera',
                    child: Icon(Icons.add_a_photo),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 3.0,
                  ),
                  child: FloatingActionButton(
                    elevation: 2,
                    backgroundColor: Color(0xff222222),
                    heroTag: null,
                    onPressed: () {
                      getImage(false);
                    },
                    tooltip: 'Gallery',
                    child: Icon(Icons.folder),
                  ),
                ),
                FloatingActionButton(
                  elevation: 2,
                  backgroundColor: Color(0xff222222),
                  heroTag: null,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LogoutView()));
                  },
                  tooltip: 'Logout',
                  child: Icon(Icons.login_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;
  final List<Rect> rects = [];

  FacePainter(this.image, this.faces) {
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13.0
      ..color = Colors.yellow;

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return image != oldDelegate.image || faces != oldDelegate.faces;
  }
}
