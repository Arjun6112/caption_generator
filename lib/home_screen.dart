import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final picker = ImagePicker();
  late Future<XFile?> xFile;
  bool isFilePicked = false;
  bool isLoading = false;

  var captionList = [
    ['Witty', true],
    ['Sarcastic', false],
    ['Funny', false],
    ['Motivational', false],
    ['Inspirational', false],
    ['Sad', false]
  ];

  var generatedCaptions = '';
  var selectedStyle = '';

  void generateCaption() async {
    var selectedStyle =
        captionList.firstWhere((element) => element[1] == true)[0];
    setState(() {
      isLoading = true;
    });

    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: "AIzaSyDDdwSbghq0s25jbMWiC1ei6TDfGTUNUaY",
    );

    var prompt =
        'Generate 5 Instagram captions for this picture. Keep it really short and $selectedStyle.';
    final content = [
      Content.multi([
        TextPart(prompt),
        // The only accepted mime types are image/*.
        DataPart(
            'image/jpeg', await xFile.then((value) => value!.readAsBytes())),
      ])
    ];
    await model.generateContent(content).then((value) => {
          generatedCaptions = value.text!,
          setState(() {
            isLoading = false;
          }),
          print(value.text!)
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              'Capgest',
              style: GoogleFonts.robotoFlex(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          body: Stack(children: [
            background(),
            Center(
              child: isFilePicked
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: FutureBuilder<XFile?>(
                            future: xFile,
                            builder: (context, snap) {
                              if (snap.hasData) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.file(
                                    height: 250,
                                    width: 250,
                                    File(snap.data!.path),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
                              return const Center(
                                child: Text('Invalid Image'),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black45,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                fixedSize: const Size(250, 50)),
                            onPressed: () {
                              generateCaption();
                            },
                            child: isLoading
                                ? const Center(
                                    child: CupertinoActivityIndicator(
                                    color: Colors.white,
                                    radius: 14,
                                  ))
                                : Text('Generate  ✨',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                        color: Colors.white))),
                        const SizedBox(height: 10),
                        const Divider(
                          color: Colors.white,
                          thickness: 1,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  for (var i = 0; i < captionList.length; i++)
                                    CaptionStyle(
                                      caption: captionList[i][0].toString(),
                                      isSelected: captionList[i][1] == true,
                                      onTap: () {
                               
                               
                                        print(captionList[i][0].toString());
                                        setState(() {
                                          for (var element in captionList) {
                                            element[1] = false;
                                          }
                                          captionList[i][1] = true;
                                        });
                                        generateCaption();
                                      },
                                    )
                                ],
                              ),
                            )),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            generatedCaptions,
                            style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black38,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                fixedSize: const Size(250, 180)),
                            onPressed: () async {
                              xFile = picker
                                  .pickImage(
                                    source: ImageSource.gallery,
                                  )
                                  .whenComplete(() => setState(() {
                                        isFilePicked = true;
                                      }));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Upload Image',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                        color: Colors.white)),
                                const SizedBox(height: 15),
                                const Icon(Icons.add,
                                    size: 50, color: Colors.white)
                              ],
                            ))
                      ],
                    ),
            )
          ])),
    );
  }
}

Widget background() {
  return Stack(children: [
    Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 500,
        width: 500,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.deepOrange,
        ),
      ),
    ),
    Align(
      alignment: Alignment.center,
      child: Container(
        height: 500,
        width: 500,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
      ),
    ),
    Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 500,
        width: 500,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
      ),
    ),
    BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: Container(color: Colors.transparent)),
  ]);
}

class CaptionStyle extends StatelessWidget {
  const CaptionStyle(
      {super.key, this.onTap, required this.caption, required this.isSelected});
  final void Function()? onTap;
  final String caption;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(
            left: 8,
          ),
          decoration: BoxDecoration(
              color: isSelected ? Colors.white54 : Colors.black38,
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              maxLines: 1,
              caption,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
