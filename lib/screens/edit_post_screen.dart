// ignore_for_file: prefer_typing_uninitialized_variables, use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors, prefer_if_null_operators, avoid_print

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:travel/models/user.dart';
import 'package:travel/resources/firestore_methods.dart';
import 'package:travel/utils/utils.dart';

const List<String> list = <String>[
  'Where to eat',
  'Where to stay',
  'What to do'
];

class EditPostScreen extends StatefulWidget {
  final snap;
  const EditPostScreen({Key? key, required this.snap}) : super(key: key);
  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  bool _isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  String _postTypeOption = list.first;
  Uint8List? _file;
  String? _selectedImageUrl;


  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text,
          _file!,
          uid,
          _countryController.text,
          _cityController.text,
          _postTypeOption,
          username,
          profImage);

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Posted!', context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void _changeImage(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Change image'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List? file = await pickImage(ImageSource.camera);
                if (file != null) {
                  setState(() {
                    _file = file;
                  });
                }
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List? file = await pickImage(ImageSource.gallery);
                if (file != null) {
                  setState(() {
                    _file = file;
                  });
                }
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _countryController.dispose();
    _cityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Edit'),
        actions: [
          TextButton(
            onPressed: () => postImage(user.uid, user.username, user.photoUrl),
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          _isLoading
              ? const LinearProgressIndicator()
              : const Padding(padding: EdgeInsets.only(top: 0)),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextField(
                  controller:
                      TextEditingController(text: widget.snap['description']),
                  onChanged: (newValue) {},
                  decoration: InputDecoration(
                    hintText: 'Introduceți descrierea',
                  ),
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: GestureDetector(
                    onTap: () => _changeImage(context),
                    child: _file != null
                        ? Image.memory(
                            _file!) // Afișează noua imagine dacă există
                        : Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(_selectedImageUrl != null
                                    ? _selectedImageUrl
                                    : widget.snap['postUrl']),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add Country
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller:
                        TextEditingController(text: widget.snap['country']),
                    onChanged: (newValue) {
                      // Aici poți gestiona schimbările în text
                    },
                    decoration: InputDecoration(
                      hintText: 'Introduceți tara',
                    ),
                  ),
                ),

                SizedBox(height: 10),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                    controller:
                        TextEditingController(text: widget.snap['city']),
                    onChanged: (newValue) {
                      // Aici poți gestiona schimbările în text
                    },
                    decoration: InputDecoration(
                      hintText: 'Introduceți descrierea',
                    ),
                  ),
                ),

                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Choose your post type',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(width: 10), // Space between text and dropdown

                    DropdownButton<String>(
                      value: _postTypeOption,
                      onChanged: (String? newValue) {
                        print("Valoarea selectată: $newValue");
                        setState(() {
                          _postTypeOption = newValue!;
                        });
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
