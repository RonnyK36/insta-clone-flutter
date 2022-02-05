import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/services/auth_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/pick_image.dart';
import 'package:instagram_clone/utils/snackbar.dart';
import 'package:instagram_clone/widgets/text_input_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void getProfilePicture() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void createUser() async {
    if (_image != null) {
      setState(() {
        _isLoading = true;
      });
      String result = await Auth().createUser(
        username: _usernameController.text,
        bio: _bioController.text,
        email: _emailController.text,
        password: _passwordController.text,
        file: _image!,
      );

      setState(() {
        _isLoading = false;
      });
      if (result != "success") {
        showSnackbar(content: result, context: context);
      } else {
        showSnackbar(
          content: "Account was created successfully",
          context: context,
        );
      }
    } else {
      showSnackbar(content: "Please select an image", context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Flexible(child: Container(), flex: 2),
                // logo
                SvgPicture.asset(
                  'assets/images/ic_instagram.svg',
                  color: myPrimaryColor,
                  height: 64,
                ),
                const SizedBox(height: 60),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 60, backgroundImage: MemoryImage(_image!))
                        : const CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                AssetImage("assets/images/default_profile.jpg"),
                          ),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                            onPressed: getProfilePicture,
                            icon: const Icon(Icons.add_a_photo)))
                  ],
                ),
                const SizedBox(height: 20),

                // email input
                TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: "Username",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldInput(
                  textEditingController: _emailController,
                  hintText: "Enter Email",
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldInput(
                  textEditingController: _bioController,
                  hintText: "Compose Bio",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 20,
                ),
                // password field
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: "Password",
                  isPassword: true,
                  textInputType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  textEditingController: _confirmPasswordController,
                  hintText: "Confirm Password",
                  isPassword: true,
                  textInputType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 20),
                // login button
                InkWell(
                  onTap: createUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text("Signup"),
                  ),
                ),
                // Flexible(child: Container(), flex: 2),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text("Already have an account? "),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen())),
                      child: Container(
                        child: const Text(
                          "Login.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
