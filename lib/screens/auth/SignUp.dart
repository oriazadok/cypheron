import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart'; // For hashing the password
import 'dart:convert'; // For utf8 encoding

import 'package:cypheron/services/HiveService.dart'; // To store user data
import 'package:cypheron/models/UserModel.dart'; // The UserModel
import 'package:cypheron/screens/Home.dart'; // The UserModel


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();  // Form key to validate the form

  // Controllers to handle input data
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name input field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              
              // Phone number input field
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Email input field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Password input field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    UserModel? signUpSuccessful = await _handleSignUp();
                    print("signUpSuccessful: $signUpSuccessful");
                    if (signUpSuccessful != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(user: signUpSuccessful),
                        ),
                      );
                    } 
                  }
                },
                child: Text('Sign Up'),
              ),

            ],
          ),
        ),
      ),
    );
  }

  // Function to handle sign-up logic
  Future<UserModel?> _handleSignUp() async {
    // Hash the password
    var hashedPassword = sha256.convert(utf8.encode(_passwordController.text)).toString();

    // Create a new UserModel
    UserModel newUser = UserModel(
      name: _nameController.text,
      phoneNumber: _phoneController.text,
      email: _emailController.text,
      hashedPassword: hashedPassword,
    );

    // Store the user using Hive
    bool isAdded = await HiveService.addUser(newUser);

    if (isAdded) {
      UserModel? reloadUser = await HiveService.getUserByEmail(_emailController.text);
      print("reloadUser: $reloadUser");

      // Validate if the user exists and the hashed password matches
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
