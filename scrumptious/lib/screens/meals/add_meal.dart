import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:scrumptious/data/dummy_data.dart';
import 'package:path_provider/path_provider.dart';

final _logger = Logger('AddMealScreen');

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});
  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  File? image;
  PaletteGenerator? paletteGenerator;
  Future pickImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;
      final imageTemp = File(pickedImage.path);

      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final imageDirectory = Directory('$path/assets');
      if (!await imageDirectory.exists()) {
        await imageDirectory.create(recursive: true);
      }
      final imagePath =
          '${imageDirectory.path}/${DateTime.now().toIso8601String()}.png';

      final newImage = await imageTemp.copy(imagePath);
      final newPalette = await PaletteGenerator.fromImageProvider(
        FileImage(newImage),
      );

      setState(() {
        image = newImage;
        paletteGenerator = newPalette;
      });
    } on PlatformException catch (e) {
      _logger.warning('Failed to pick image: $e');
    }
  }

  Future<void> _cropImage() async {
    ImageCropper imageCropper = ImageCropper();
    final croppedFile = await imageCropper.cropImage(
      sourcePath: image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
    );

    if (croppedFile != null) {
      final file = File(croppedFile.path);
      setState(() {
        image = file;
      });
    }
  }

  Color get iconColor {
    final color = paletteGenerator?.dominantColor?.color ?? Colors.white;
    return Color.fromRGBO(
      255 - color.red,
      255 - color.green,
      255 - color.blue,
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Meal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                await pickImage();
              },
              child: Stack(
                children: <Widget>[
                  if (image is File)
                    Image.file(
                      image!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                    )
                  else
                    Image.asset(
                      'assets/placeholder.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                  if (image is File) ...[
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: IconButton(
                        icon: Icon(Icons.crop, color: iconColor),
                        onPressed: _cropImage,
                      ),
                    ),
                    Positioned(
                      left: 00,
                      bottom: 0,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: iconColor),
                        onPressed: () {
                          setState(() {
                            image = null;
                            paletteGenerator = null;
                          });
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
                labelStyle: TextStyle(color: Colors.white),
              ),
              items: availableCategories.map((category) {
                return DropdownMenuItem(
                  value: category.strId,
                  child: Text(category.strTitle,
                      style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16.0),
            const SizedBox(height: 16.0),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.camera),
                  onPressed: () async {
                    await pickImage();
                  },
                ),
                const SizedBox(width: 8.0),
                const Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Steps',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    maxLines: null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement button functionality
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
