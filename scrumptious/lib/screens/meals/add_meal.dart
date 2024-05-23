import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
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
  Future pickImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;
      final imageTemp = File(pickedImage.path);

      // Get the directory to save the image

      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final imagePath = '$path/assets/${DateTime.now().toIso8601String()}.png';

      // Copy the image to the new path
      // final newImage = await imageTemp.copy(imagePath); broken

      // setState(() => this.image = newImage);
    } on PlatformException catch (e) {
      _logger.warning('Failed to pick image: $e');
    }
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
            const TextField(
              style:
                  TextStyle(color: Colors.white), // Set the text color to white
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
                if (image != null) Image.file(image!),
                IconButton(
                  icon: const Icon(Icons.camera),
                  onPressed: () async {
                    await pickImage();
                  },
                ),
                const SizedBox(width: 8.0),
                const Expanded(
                  child: TextField(
                    style: TextStyle(
                        color: Colors.white), // Set the text color to white
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
