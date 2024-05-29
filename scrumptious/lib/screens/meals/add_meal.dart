import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:scrumptious/data/dummy_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrumptious/data/globals.dart';
import 'package:scrumptious/models/meal.dart';
import 'package:scrumptious/providers/filters_provider.dart';
import 'package:scrumptious/providers/meals_provider.dart';

final _logger = Logger('AddMealScreen');

class AddMealScreen extends ConsumerStatefulWidget {
  const AddMealScreen({super.key});
  @override
  ConsumerState<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends ConsumerState<AddMealScreen> {
  bool isMinutes = true;

  File? image;
  String? imagePath;
  PaletteGenerator? paletteGenerator;

  final List<TextEditingController> _ingredientControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> _stepsControllers = [
    TextEditingController()
  ];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  List<String> arrCategories = [];
  Affordability enumAffordability = Affordability.affordable;
  Complexity enumComplexity = Complexity.simple;
  int intDuration = 0;

  Map<Filter, bool> activeFilters = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegetarian: false,
    Filter.vegan: false,
    Filter.nutFree: false,
    Filter.highProtein: false,
    Filter.lowCalorie: false,
  };

  void updateFilter(Filter filterType, bool newValue) {
    setState(() {
      activeFilters[filterType] = newValue;
    });
  }

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
      final newImagePath =
          '${imageDirectory.path}/${DateTime.now().toIso8601String()}.png';

      final newImage = await imageTemp.copy(newImagePath);
      final newPalette = await PaletteGenerator.fromImageProvider(
        FileImage(newImage),
      );

      setState(() {
        image = newImage;
        imagePath = newImagePath;
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
      final newPalette = await PaletteGenerator.fromImageProvider(
        FileImage(file),
      );
      setState(() {
        image = file;
        imagePath = file.path;
        paletteGenerator = newPalette;
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

  void _showMultiSelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          title:
              const Text('Categories:', style: TextStyle(color: Colors.white)),
          confirmText:
              const Text('Confirm', style: TextStyle(color: Colors.white)),
          cancelText:
              const Text('Cancel', style: TextStyle(color: Colors.white)),
          itemsTextStyle: const TextStyle(color: Colors.white),
          selectedItemsTextStyle: const TextStyle(color: Colors.white),
          items: availableCategories
              .map((category) =>
                  MultiSelectItem(category.strId, category.strTitle))
              .toList(),
          initialValue: arrCategories,
          onConfirm: (values) {
            setState(() {
              arrCategories = values.cast<String>();
            });
          },
        );
      },
    );
  }

  void saveMeal() {
    List<String> arrIngredients = [];
    List<String> arrSteps = [];
    for (var controller in _ingredientControllers) {
      arrIngredients.add(controller.text);
    }
    for (var controller in _stepsControllers) {
      arrSteps.add(controller.text);
    }
    final newMeal = Meal(
      strId: DateTime.now().toIso8601String(),
      arrCategories: arrCategories,
      strTitle: _titleController.text,
      strImageUrl: imagePath ?? '',
      arrIngredients: arrIngredients,
      arrSteps: arrSteps,
      intDuration: intDuration,
      enumComplexity: enumComplexity,
      enumAffordability: enumAffordability,
      bIsGlutenFree: activeFilters[Filter.glutenFree]!,
      bIsLactoseFree: activeFilters[Filter.lactoseFree]!,
      bIsVegan: activeFilters[Filter.vegan]!,
      bIsVegetarian: activeFilters[Filter.vegetarian]!,
      bIsNutFree: activeFilters[Filter.nutFree]!,
      bIsHighProtein: activeFilters[Filter.highProtein]!,
      bIsLowCalorie: activeFilters[Filter.lowCalorie]!,
      bIsUnder30Mins: intDuration < 30,
      bIsUnder1Hour: intDuration < 60,
    );
    ref.read(mealProvider.notifier).updateMeals([newMeal]);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Meal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Name:',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            _showMultiSelect(context);
                          },
                          child: const Text(
                            'Categories',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                  const SizedBox(width: 12.0),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<Affordability>(
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      items: Affordability.values.map((affordability) {
                        return DropdownMenuItem(
                          value: affordability,
                          child: Text(getAffordabilitySign(affordability),
                              style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          enumAffordability = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<Complexity>(
                      decoration: const InputDecoration(
                        labelText: 'Difficulty',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      items: Complexity.values.map((complexity) {
                        return DropdownMenuItem(
                          value: complexity,
                          child: Text(capitalizeString(complexity.name),
                              style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          enumComplexity = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                        controller: _durationController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Duration:',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ]),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Type:',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      items: const [
                        DropdownMenuItem<String>(
                          value: "Hours",
                          child: Text(
                            "Hours",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: "Minutes",
                          child: Text(
                            "Minutes",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == "Minutes") {
                          setState(() {
                            intDuration = int.parse(_durationController.text);
                          });
                        } else {
                          setState(() {
                            intDuration =
                                int.parse(_durationController.text) * 60;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28.0),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Ingredients:",
                      style: TextStyle(color: Colors.white, fontSize: 18))),
              for (var controller in _ingredientControllers)
                SizedBox(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText:
                          '${_ingredientControllers.indexOf(controller) + 1}:',
                      labelStyle: const TextStyle(color: Colors.white),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _ingredientControllers.remove(controller);
                          });
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _ingredientControllers.add(TextEditingController());
                  });
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16.0),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Steps:",
                      style: TextStyle(color: Colors.white, fontSize: 18))),
              for (var controller in _stepsControllers)
                SizedBox(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText:
                          '${_stepsControllers.indexOf(controller) + 1}:',
                      labelStyle: const TextStyle(color: Colors.white),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _stepsControllers.remove(controller);
                          });
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _ingredientControllers.add(TextEditingController());
                  });
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                child: Column(children: [
                  SwitchListTile(
                    value: activeFilters[Filter.glutenFree]!,
                    onChanged: (bIsChecked) {
                      updateFilter(Filter.glutenFree, bIsChecked);
                    },
                    title: Text('Gluten-free',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground)),
                    subtitle: Text('This meal is gluten-free.',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground)),
                    activeColor: Theme.of(context).colorScheme.tertiary,
                    contentPadding: const EdgeInsets.only(left: 34, right: 22),
                  ),
                  SwitchListTile(
                    value: activeFilters[Filter.lactoseFree]!,
                    onChanged: (bIsChecked) {
                      updateFilter(Filter.lactoseFree, bIsChecked);
                    },
                    title: Text('Lactose-free',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground)),
                    subtitle: Text('This meal is lactose-free.',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground)),
                    activeColor: Theme.of(context).colorScheme.tertiary,
                    contentPadding: const EdgeInsets.only(left: 34, right: 22),
                  ),
                  SwitchListTile(
                    value: activeFilters[Filter.nutFree]!,
                    onChanged: (bIsChecked) {
                      updateFilter(Filter.nutFree, bIsChecked);
                    },
                    title: Text('Nut-free',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground)),
                    subtitle: Text('This meal is nut-free.',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground)),
                    activeColor: Theme.of(context).colorScheme.tertiary,
                    contentPadding: const EdgeInsets.only(left: 34, right: 22),
                  ),
                  SwitchListTile(
                    value: activeFilters[Filter.vegetarian]!,
                    onChanged: (bIsChecked) {
                      updateFilter(Filter.vegetarian, bIsChecked);
                    },
                    title: Text('Vegetarian',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground)),
                    subtitle: Text('This meal is vegetarian friendly.',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground)),
                    activeColor: Theme.of(context).colorScheme.tertiary,
                    contentPadding: const EdgeInsets.only(left: 34, right: 22),
                  ),
                  SwitchListTile(
                    value: activeFilters[Filter.vegan]!,
                    onChanged: (bIsChecked) {
                      updateFilter(Filter.vegan, bIsChecked);
                    },
                    title: Text('Vegan',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground)),
                    subtitle: Text('This meal is vegan friendly.',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground)),
                    activeColor: Theme.of(context).colorScheme.tertiary,
                    contentPadding: const EdgeInsets.only(left: 34, right: 22),
                  ),
                  SwitchListTile(
                    value: activeFilters[Filter.highProtein]!,
                    onChanged: (bIsChecked) {
                      updateFilter(Filter.highProtein, bIsChecked);
                    },
                    title: Text('High Protein',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground)),
                    subtitle: Text('This meal is high in protein.',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground)),
                    activeColor: Theme.of(context).colorScheme.tertiary,
                    contentPadding: const EdgeInsets.only(left: 34, right: 22),
                  ),
                  SwitchListTile(
                    value: activeFilters[Filter.lowCalorie]!,
                    onChanged: (bIsChecked) {
                      updateFilter(Filter.lowCalorie, bIsChecked);
                    },
                    title: Text('Low Calorie',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground)),
                    subtitle: Text('This meal is low in calories.',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground)),
                    activeColor: Theme.of(context).colorScheme.tertiary,
                    contentPadding: const EdgeInsets.only(left: 34, right: 22),
                  ),
                ]),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  saveMeal();
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
