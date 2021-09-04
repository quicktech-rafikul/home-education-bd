/*
Author: QuickTech IT
Author URI: http://quicktech-ltd.com;
Description: QuickTech IT maintain standard quality for Website and Creative Design
*/

import 'dart:io';
import 'package:educationbd/Models/CourseModel.dart';
import 'package:educationbd/Models/UserModel.dart';
import 'package:educationbd/Screens/Code/CheckLogin.dart';
import 'package:educationbd/Screens/Utils/UI_Colors.dart';
import 'package:educationbd/Services/Database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class QuickTechIT_Registration extends StatefulWidget {
  @override
  _QuickTechIT_RegistrationState createState() =>
      _QuickTechIT_RegistrationState();
}

class _QuickTechIT_RegistrationState extends State<QuickTechIT_Registration> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController collegeNameController = new TextEditingController();
  TextEditingController lastExamController = new TextEditingController();
  TextEditingController passingYearController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool termsChecked = false;
  bool isPhoneAuth = false;
  bool isEmailAuth = false;

  List<String> bloodGroup = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  String _selectedBloodGroup;

  final picker = ImagePicker();

  String profilePicUrl =
      'https://st.cdjapan.co.jp/pictures/l/01/13/BLR-1001.jpg?v=1';

  List<CourseModel> courses = [];

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser.phoneNumber == null) {
      isPhoneAuth = false;
      phoneController.text = "";
    } else {
      isPhoneAuth = true;
      phoneController.text = FirebaseAuth.instance.currentUser.phoneNumber;
    }

    if (FirebaseAuth.instance.currentUser.email == null) {
      isEmailAuth = false;
      emailController.text = "";
    } else {
      isEmailAuth = true;
      emailController.text = FirebaseAuth.instance.currentUser.email;
    }

    Database().getCourses().then((value) {
      setState(() {
        courses = value;
      });
      return value;
    });

    state = AppState.free;

    super.initState();
  }

  File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Getting Started",
                      style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(3),
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Give the information to continue!",
                      style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2),
                          color: Colors.grey.shade700),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (state == AppState.free)
                          _pickImage();
                        else if (state == AppState.picked)
                          _cropImage();
                        else if (state == AppState.cropped) _clearImage();
                      },
                      child: _image == null
                          ? Container(
                              width: 100,
                              height: 100,
                              child: new CircleAvatar(
                                backgroundColor: UIColors.primaryColor,
                                child: Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.white,
                                ),
                                radius: 200.0,
                              ))
                          : Container(
                              width: 100,
                              height: 100,
                              child: new CircleAvatar(
                                backgroundColor: UIColors.primaryColor,
                                backgroundImage: new FileImage(_image),
                                radius: 200.0,
                              )),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Touch in circle to upload your image",
                      style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                          color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: TextFormField(
                        controller: nameController,
                        validator: (firstName) {
                          if (firstName.length == 0) {
                            return 'Please enter your name';
                          } else
                            return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Your Name',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: UIColors.primaryColor2,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: UIColors.primaryColor,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: TextFormField(
                        controller: collegeNameController,
                        validator: (firstName) {
                          if (firstName.length == 0) {
                            return 'Please enter your institue name';
                          } else
                            return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Institue Name',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: UIColors.primaryColor2,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: UIColors.primaryColor,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: TextFormField(
                        controller: lastExamController,
                        validator: (firstName) {
                          if (firstName.length == 0) {
                            return 'Please enter your Last Exam';
                          } else
                            return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Last Eaxm',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: UIColors.primaryColor2,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: UIColors.primaryColor,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: TextFormField(
                        controller: passingYearController,
                        validator: (firstName) {
                          if (firstName.length == 0) {
                            return 'Please enter your Passing Year';
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Passing Year',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: UIColors.primaryColor2,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: UIColors.primaryColor,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!isPhoneAuth)
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            child: Text(
                              "Phone Number",
                              style: TextStyle(
                                  fontSize: ResponsiveFlutter.of(context)
                                      .fontSize(1.8),
                                  color: Colors.grey),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: TextFormField(
                              controller: phoneController,
                              validator: (firstName) {
                                if (firstName.length == 0) {
                                  return 'Please enter your Phone Number';
                                } else
                                  return null;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: '01*********',
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.grey[100],
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 10, 20, 10),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: UIColors.primaryColor, width: 1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (!isEmailAuth)
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: TextFormField(
                              controller: emailController,
                              validator: (firstName) {
                                if (firstName.length == 0) {
                                  return 'Please enter your Email';
                                } else
                                  return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Your Email',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: UIColors.primaryColor2,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: UIColors.primaryColor,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[100],
                      ),
                      child: DropdownButtonFormField(
                        // Not necessary for Option 1
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          labelText: 'Your blood group',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: UIColors.primaryColor2,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: UIColors.primaryColor,
                              width: 1.0,
                            ),
                          ),
                        ),
                        validator: (value) =>
                            value == null ? 'Select Blood Group' : null,
                        isExpanded: true,
                        value: _selectedBloodGroup,
                        onChanged: (newValue) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            _selectedBloodGroup = newValue;
                          });
                        },
                        items: bloodGroup.map((value) {
                          return DropdownMenuItem(
                            child: new Text(value),
                            value: value,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: UIColors.primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(8))),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            String phoneNumber;
                            if (phoneController.text.length == 11) {
                              phoneNumber = "+88${phoneController.text}";
                            } else {
                              phoneNumber = phoneController.text;
                            }
                            UserModel user = new UserModel(
                                name: nameController.text,
                                collegeName: collegeNameController.text,
                                phoneNumber: phoneNumber,
                                email: emailController.text,
                                lastExamName: lastExamController.text,
                                passingYear:
                                    int.parse(passingYearController.text),
                                courseId: courses[0].id,
                                bloodGroup: _selectedBloodGroup,
                                profilePic: profilePicUrl,
                                point: 0,
                                package: 0);

                            await Database().createUser(user);

                            await CheckLogin().checkData();
                          }
                        },
                        child: Text(
                          "Create Account",
                          style: TextStyle(
                              fontSize:
                                  ResponsiveFlutter.of(context).fontSize(2.2),
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppState state;

  File imageFile;

  Future _pickImage() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        state = AppState.picked;
      });
      _cropImage();
    } else {
      _image = null;
      Get.snackbar("Image", "No Image Selected",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: UIColors.primaryColor2);
    }
  }

  Future _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        maxHeight: 300,
        maxWidth: 300,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop',
            toolbarColor: UIColors.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            hideBottomControls: true,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      setState(() {
        imageFile = croppedFile;
        _image = croppedFile;
        state = AppState.cropped;
      });
      uploadFile(_image);
      _clearImage();
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }

  Future<firebase_storage.UploadTask> uploadFile(File file) async {
    if (file == null) {
      Get.snackbar("Image", "No Image Selected",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: UIColors.primaryColor2);
      return null;
    }

    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('Profile')
        .child('/${FirebaseAuth.instance.currentUser.uid}');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(File(file.path), metadata);
    }

    uploadTask.whenComplete(() async {
      try {
        profilePicUrl = await ref.getDownloadURL();
      } catch (onError) {
        print("Error");
      }
    });

    return Future.value(uploadTask);
  }
}

enum AppState {
  free,
  picked,
  cropped,
}
