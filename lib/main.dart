import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tflite/tflite.dart';

int total = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
         // Take the Picture in a try / catch block. If anything goes wrong,
                    // catch the error.
                    try {
                      // Ensure that the camera is initialized.
                      await _initializeControllerFuture;

                      // Construct the path where the image should be saved using the
                      // pattern package.
                      final path = join(
                        // Store the picture in the temp directory.
                        // Find the temp directory using the `path_provider` plugin.
                        (await getTemporaryDirectory()).path,
                        '${DateTime.now()}.png',
                      );

                      // Attempt to take a picture and log where it's been saved.

                      XFile picture = await _controller.takePicture();
                      picture.saveTo(path);
                      // If the picture was taken, display it on a new screen.
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(path),
                        ),
                      );
                    } catch (e) {
                      // If an error occurs, log the error to the console.
                    }
      },
      child: Scaffold(
        appBar: AppBar(title: Center(child: Text('Mondec'))),
        // Wait until the controller is initialized before displaying the
        // camera preview. Use a FutureBuilder to display a loading spinner
        // until the controller has finished initializing.
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return CameraPreview(_controller);
            } else {
              // Otherwise, display a loading indicator.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  DisplayPictureScreen(this.imagePath);
  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  late List op;
  late Image img;

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
    img = Image.file(File(widget.imagePath));
    classifyImage(widget.imagePath);
  }

  @override
  Widget build(BuildContext context) {
//    Image img = Image.file(File(widget.imagePath));
//    classifyImage(widget.imagePath, total);

    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: GestureDetector(
        onTap: () {
          classifyImage(widget.imagePath);
        },
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Center(child: img)),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }


  classifyImage(String image) async {
    var output = await Tflite.runModelOnImage(
      path: image,
      numResults: 1,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    op = output!;
  FlutterTts flutterTts = FlutterTts();

  
    if (op != null) {
      if (op[0]["label"] == "50 rupees") {
        
          flutterTts.speak(" currency that you have 50 rupees");
         
      }
      if (op[0]["label"] == "50 dollar") {
        
          flutterTts.speak(" currency that you have 50 dollar");
         
      }
      if (op[0]["label"] == "100 rupees") {
         await flutterTts.speak("100 rupees");
      }
      if (op[0]["label"] == "200 rupees") {
        flutterTts.speak(" currency that you have 200 rupees");
      }
      if (op[0]["label"] == "500 rupees") {
       flutterTts.speak(" currency that you have 500 rupees");
      }

      if (op[0]["label"] == "2000 rupees") {
       await flutterTts.speak("2000 rupees");
      }
    } else
      await flutterTts.speak("not found");
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/m.tflite", labels: "assets/labels.txt");
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
