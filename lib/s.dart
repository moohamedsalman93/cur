// import 'dart:io';
// import 'dart:ui' as ui;
// import 'dart:typed_data';

// import 'package:msapp1/screen_loader.dart';
// import 'package:flutter/material.dart';

// import 'package:image_picker/image_picker.dart';

// import 'inbox_widget.dart';
// import 'classifier.dart';
// import 'language_page.dart';
// import 'tts.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   HomePageState createState() => HomePageState();
// }

// class HomePageState extends State<HomePage> {
//   final ImagePicker _picker = ImagePicker();
//   final Classifier _classifier = Classifier();
//   XFile? image;
//   String? result;

//   //Picture Handler
//   Future getImage(bool isCamera) async {
//     if (isCamera) {
//       image = await _picker.pickImage(
//           source: ImageSource.camera,
//           imageQuality: 100,
//           maxWidth: 224,
//           maxHeight: 224);
//     } else {
//       image = await _picker.pickImage(source: ImageSource.gallery);
//     }
//     setState(() {});

//     if (image != null) {
//       if (mounted) {
//         ScreenLoaderWidget.show(context);
//       }
//       debugPrint("Selected Image: ${image?.path}");

//       // Uint8List bytesList = await image!.readAsBytes();
//       // final buffer = await ui.ImmutableBuffer.fromUint8List(bytesList);
//       // final descriptor = await ui.ImageDescriptor.encoded(buffer);
//       // final imageWidth = descriptor.width;
//       // final imageHeight = descriptor.height;
//       // debugPrint("Width: $imageWidth, Height: $imageHeight");
//       // descriptor.dispose();
//       // buffer.dispose();

//       result = await _classifier.processImage(image!.path);
//       if (mounted) {
//         ScreenLoaderWidget.hide(context);
//       }
//       TTS.speak(result ?? "Unexpected error occured. Please try again.");
//     }
//   }

//   //InitState
//   @override
//   void initState() {
//     super.initState();
//     TTS.initTts();
//   }

//   //Dispose
//   @override
//   void dispose() {
//     super.dispose();
//     TTS.stopTTS();
//     _classifier.disposeClassifier();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         child: SafeArea(
//           child: Scaffold(
//             backgroundColor: Colors.black,
//             body: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   InkBox(
//                     icon: Icons.visibility,
//                     heading:
//                         'Hello, Welcome to your Currency detection \napplication',
//                     color: 0xffed622b,
//                     onTap: () => TTS.speak(
//                         'Hello, welcome to your Currency detection application'),
//                   ),
//                   const SizedBox(height: 10),
//                   SizedBox(
//                     height: 190.0,
//                     width: 200.0,
//                     child: Semantics(
//                       label: 'picked_image',
//                       child: image == null
//                           ? const Center(
//                               child: Text('Pick a image',
//                                   style: TextStyle(color: Colors.white)))
//                           : Image.file(
//                               File(image!.path),
//                               errorBuilder: (BuildContext context, Object error,
//                                       StackTrace? stackTrace) =>
//                                   const Center(
//                                       child: Text(
//                                           'This image type is not supported',
//                                           style:
//                                               TextStyle(color: Colors.white))),
//                             ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   InkBox(
//                     icon: Icons.photo_camera,
//                     heading: 'Take picture',
//                     color: 0xffff3266,
//                     onTap: () => getImage(true),
//                     onDoubleTab: () {
//                       TTS.speak('Take picture');
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   Expanded(
//                     child: GridView(
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 8.0,
//                         mainAxisSpacing: 12.0,
//                       ),
//                       physics: const BouncingScrollPhysics(),
//                       children: <Widget>[
//                         InkBox(
//                           icon: Icons.speaker_phone,
//                           heading: 'Repeat result',
//                           color: 0xff3399fe,
//                           onTap: () => TTS.speak(result ?? "No history found"),
//                           onDoubleTab: () => TTS.speak("Repeat result"),
//                         ),
//                         InkBox(
//                           color: 0xfff4c83f,
//                           heading: 'Change language',
//                           icon: Icons.language,
//                           onTap: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const LanguagePage())),
//                           onDoubleTab: () => {
//                             TTS.speak('Change language')
//                           }, // navigate to the second_page
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         onWillPop: () async => false);
//   }
// }