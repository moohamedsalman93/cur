// import 'package:camera/camera.dart';
// import 'package:cur/main.dart';
// import 'package:flutter/material.dart';
// import 'package:tflite/tflite.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   CameraImage? cameraImage;
//   CameraController? cameraController;
//   String output = '';
//   FlutterTts flutterTts = FlutterTts();

//   @override
//   void initState() {
//     super.initState();
//     loadCamera();
//     loadmodel();
//   }

//   loadCamera() {
//     cameraController = CameraController(cameras![0], ResolutionPreset.veryHigh);
//     cameraController!.initialize().then((value) => {
//           if (mounted)
//             {
//               setState((() {
//                 cameraController!.startImageStream((imageStream) {
//                   cameraImage = imageStream;
//                   runModel();
//                 });
//               }))
//             }
//         });
//   }

//   runModel() async {
//     if (cameraImage != null) {
//       var prediction = await Tflite.runModelOnFrame(
//           bytesList: cameraImage!.planes.map((plane) {
//             return plane.bytes;
//           }).toList(),
//           imageHeight: cameraImage!.height,
//           imageWidth: cameraImage!.width,
//           numResults: 2,
//           threshold: 0.5,
//           imageMean: 127.5,
//           imageStd: 127.5,
//           asynch: true);
//       prediction!.forEach((element) {
//         setState(() {
//           output = element['label'];
//         });
//         flutterTts.speak(output);
//       });
//     }
//   }

//   loadmodel() async {
//     await Tflite.loadModel(
//         model: "assets/m.tflite", labels: "assets/labels.txt");
//   }

//   @override
//   Widget build(BuildContext context) {
//     var h = MediaQuery.of(context).size.height;
//     var w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Colors.grey,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Center(child: Text('Currency')),
//       ),
//       body: Column(children: [
//         Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Container(
//               height: h * 0.7,
//               width: w,
//               child: !cameraController!.value.isInitialized
//                   ? Container()
//                   : AspectRatio(
//                       aspectRatio: cameraController!.value.aspectRatio,
//                       child: CameraPreview(cameraController!))),
//         ),
//         Text(
//           output,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         )
//       ]),
//     );
//   }
// }
