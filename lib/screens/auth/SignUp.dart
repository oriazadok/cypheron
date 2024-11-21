import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart'; // For hashing the password
import 'dart:convert'; // For utf8 encoding

import 'package:cypheron/ui/screensUI/AuthUI.dart';
import 'package:cypheron/ui/widgetsUI/FormUI.dart';

import 'package:cypheron/services/HiveService.dart'; // To store user data
import 'package:cypheron/models/UserModel.dart'; // The UserModel
import 'package:cypheron/widgets/form_elements/GenericTextFormField.dart';
import 'package:cypheron/screens/Home.dart'; // The Home screen to navigate to after signup

/// SignUp screen allows new users to register by providing their information.
/// On successful registration, the user is redirected to the Home screen.
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  
  // Controllers to handle user input for name, phone, email, and password
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),  // Screen title
      ),
      body: AuthUI(
        form: FormUI(
          title: 'Sign Up',

          inputFields: [
            GenericTextFormField.getTextFormField(
              type: 'name',
              controller: _nameController,
            ),
            GenericTextFormField.getTextFormField(
              type: 'phone',
              controller: _phoneController,
            ),
            GenericTextFormField.getTextFormField(
              type: 'email',
              controller: _emailController,
            ),
            GenericTextFormField.getTextFormField(
              type: 'password',
              controller: _passwordController,
            ),
          ],

          onClick: () async {
            // Calls the signup function and checks if it returns a valid user
            UserModel? signUpSuccessful = await _handleSignUp();

            if (signUpSuccessful != null) {
              // If signup is successful, navigate to Home screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(user: signUpSuccessful),
                ),
              );
            } 
          },

          buttonText: 'Sign Up',
           
        ),
      ),
    );
  }

  /// Handles signup logic by creating a new user, storing it in Hive, 
  /// and reloading the user from the database to ensure data consistency.
  Future<UserModel?> _handleSignUp() async {
    // Hash the password using SHA256 for security
    var hashedPassword = sha256.convert(utf8.encode(_passwordController.text)).toString();

    // Create a new UserModel instance with the provided details
    UserModel newUser = UserModel(
      name: _nameController.text,
      phoneNumber: _phoneController.text,
      email: _emailController.text,
      hashedPassword: hashedPassword,
    );

    // Attempt to store the new user in Hive
    bool isAdded = await HiveService.addUser(newUser);

    if (isAdded) {
      // Reload the user from Hive to verify it was saved correctly
      UserModel? reloadUser = await HiveService.getUserByEmail(_emailController.text);

      // Return the reloaded user if successful, else print an error and return null
      if (reloadUser != null) {
        return reloadUser;
      } else {
        print("Failed to fetch user.");
        return null;
      }
    } else {
      print("Failed to add user.");
      return null;
    }
  }
}
