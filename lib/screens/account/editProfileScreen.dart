import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/color.dart';
import '../../utils/constant.dart';
import '../../utils/customLoader.dart';
import '/common/cacheImage.dart';
import '/providers/profileProvider.dart';
import '/utils/commonMethod.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: TextStyle(
              letterSpacing: 4,
              fontFamily: "BankGothic",
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              navPop(context: context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Consumer<ProfileProvider>(builder: (context, data, child) {
            return Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          (_selectedImage == null)
                              ? cacheImage(
                                  image:
                                      data.profileModel!.profilePicture ?? '',
                                  radius: 100,
                                  height: 150,
                                  width: 150)
                              : Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: grey.withOpacity(0.5)),
                                      borderRadius: BorderRadius.circular(100),
                                      image: DecorationImage(
                                        image: FileImage(
                                            File(_selectedImage!.path)),
                                      )),
                                ),
                          Positioned(
                            bottom: 5,
                            right: 2,
                            child: InkWell(
                              onTap: () {
                                _showBottomSheet(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      100,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                                height: 40,
                                width: 40,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
                textField(
                    context: context,
                    controller: data.nameController,
                    hint: 'Name',
                    icon: Icons.person_outline,
                    index: 0),
                SizedBox(
                  height: 20,
                ),
                textField(
                    context: context,
                    controller: data.emailController,
                    hint: 'Email ID',
                    icon: Icons.email_outlined,
                    index: 1),
                SizedBox(
                  height: 20,
                ),
                textField(
                    context: context,
                    controller: data.phoneController,
                    hint: 'Phone Number',
                    icon: Icons.smartphone_rounded,
                    index: 2),
                SizedBox(
                  height: 20,
                ),
                textField(
                    context: context,
                    controller: data.countryController,
                    hint: 'Country',
                    icon: Icons.location_searching,
                    index: 3),
                SizedBox(
                  height: 20,
                ),
                textField(
                    context: context,
                    controller: data.cityController,
                    hint: 'City',
                    icon: Icons.location_city,
                    index: 4),
                SizedBox(
                  height: 20,
                ),
                textField(
                    context: context,
                    controller: data.areaController,
                    hint: 'Area',
                    icon: Icons.location_on_outlined,
                    index: 5),
                SizedBox(
                  height: 100,
                ),
                button(label: 'SAVE CHANGES', isNext: false, onTap: onSave),
                SizedBox(
                  height: 40,
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget textField(
          {required BuildContext context,
          required TextEditingController controller,
          required String hint,
          required IconData icon,
          required int index}) =>
      Container(
        child: TextFormField(
          keyboardType: (index == 0)
              ? TextInputType.name
              : (index == 1)
                  ? TextInputType.emailAddress
                  : (index == 2)
                      ? TextInputType.phone
                      : TextInputType.text,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: (index == 1)
              ? TextCapitalization.none
              : TextCapitalization.sentences,
          style: GoogleFonts.mulish(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: white,
          ),
          controller: controller,
          inputFormatters: [
            if (index == 0) LengthLimitingTextInputFormatter(50),
            if (index == 1) LengthLimitingTextInputFormatter(50),
            if (index == 2) LengthLimitingTextInputFormatter(10)
          ],
          decoration: InputDecoration(
              suffixIcon: Icon(
                icon,
                color: white.withOpacity(0.5),
                size: 20,
              ),
              hintText: hint,
              hintStyle: GoogleFonts.mulish(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: white.withOpacity(0.5),
              ),
              isDense: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Color(0xffC4C4C4).withOpacity(0.2)),
        ),
      );

  Future<void> getPicker(ImageSource imageSource) async {
    try {
      XFile? image = await ImagePicker().pickImage(
        source: imageSource,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      // _selectedImage = File(image!.path);

      _imageCropper(File(image!.path));
    } on CameraException catch (e) {
      // TODO
      customToast(context: context, msg: e.description.toString(), type: 0);
    }
  }

  Future<void> _imageCropper(File photo) async {
    CroppedFile? cropPhoto = await ImageCropper().cropImage(
        sourcePath: photo.path,
        maxWidth: 1024,
        maxHeight: 1024,
        compressFormat: ImageCompressFormat.png,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
    setState(() {
      if (cropPhoto != null) {
        _selectedImage = File(cropPhoto!.path);

        log('==>>>${_selectedImage!.path}');
        log('==>>>${_selectedImage!.path.toString().split('/').last.replaceAll('\'', '')}');
      }
    });
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) => CupertinoActionSheet(
              message: Text('Choose Image'),
              actions: [
                CupertinoActionSheetAction(
                    onPressed: () {
                      // permissionServiceCall(ImageSource.camera);
                      getPicker(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Text('Camera')),
                CupertinoActionSheetAction(
                    onPressed: () {
                      // permissionServiceCall(ImageSource.gallery);
                      getPicker(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: Text('Gallery')),
              ],
            ));
  }

  Future<void> onSave() async {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    Map<String, String> data = {};
    if (pro.nameController.text.isEmpty) {
      customToast(context: context, msg: 'Name Required', type: 0);
    } else if (pro.emailController.text.isEmpty) {
      customToast(context: context, msg: 'Email ID required', type: 0);
    } else if (!emailExpression.hasMatch(pro.emailController.text)) {
      customToast(context: context, msg: 'Enter valid Email ID', type: 0);
    } else if (pro.phoneController.text.isEmpty) {
      customToast(context: context, msg: 'Phone number required', type: 0);
    } else if (pro.countryController.text.isEmpty) {
      customToast(context: context, msg: 'Country required', type: 0);
    } else if (pro.cityController.text.isEmpty) {
      customToast(context: context, msg: 'City required', type: 0);
    } else if (pro.areaController.text.isEmpty) {
      customToast(context: context, msg: 'Area required', type: 0);
    }
    /*else if (_selectedImage == null) {
      customToast(context: context, msg: 'Please select profile image', type: 0);
    }*/
    else {
      SharedPreferences pref = await SharedPreferences.getInstance();
      data = {
        'user_id': pref.getString(userIdKey) ?? '',
        'name': pro.nameController.text,
        'email': pro.emailController.text,
        'contact_number': pro.phoneController.text,
        'country': pro.countryController.text,
        'city': pro.cityController.text,
        'area': pro.areaController.text,
        // 'profile_picture': _selectedImage!.path.toString(),
      };
      if (_selectedImage == null) {
        pro.editProfile(context: context, data: data).then((value) {
          if (pro.isEdit) {
            navPop(context: context);
          }
        });
      } else {
        pro
            .editProfileIMG(
                context: context,
                data: data,
                filePath: _selectedImage!.path.toString())
            .then((value) {
          if (pro.isEdit) {
            navPop(context: context);
          }
        });
      }
    }

    log('RegData------------>>>>$data');
  }

  void checkCameraPermissio(ImageSource imageSource) async {
    FocusScope.of(context).requestFocus(FocusNode());
    var status = await Permission.camera.status;
    log("permissionText--->>>>  $status");
    Map<Permission, PermissionStatus> statuses =
        await [Permission.camera, Permission.storage].request();
    log("status---->>>>  $statuses");
    if (statuses[Permission.camera] == PermissionStatus.granted ||
        statuses[Permission.storage] == PermissionStatus.granted) {
      log("1111");
      getPicker(imageSource);
    }

    if (await Permission.camera.request().isGranted) {
      log("2222");

      getPicker(imageSource);
    } else if (await Permission.camera.request().isDenied) {
      log("2222");
      openAppSettings();
      //imagePickerOptions();
    }
  }

  void permissionServiceCall(ImageSource imageSource) async {
    if (imageSource == ImageSource.camera) {
      var cameraStatus = await Permission.camera.request();
      if (cameraStatus.isGranted) {
        getPicker(imageSource);
      } else if (cameraStatus.isDenied) {
        cameraStatus = await Permission.camera.request();
      } else if (cameraStatus.isPermanentlyDenied) {
        openAppSettings();
      }
    } else {
      var storageStatus = await Permission.storage.request();
      if (storageStatus.isGranted) {
        getPicker(imageSource);
      } else if (storageStatus.isDenied) {
        storageStatus = await Permission.storage.request();
      } else if (storageStatus.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }
}
