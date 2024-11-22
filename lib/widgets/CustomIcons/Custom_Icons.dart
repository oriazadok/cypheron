import 'package:flutter/material.dart';
import 'package:cypheron/screens/auth/SignIn.dart';
// import 'package:cypheron/screens/auth/SignUp.dart';



/// A factory class that creates different types of `IconButton` widgets based on the input type
/// and handles navigation to other screens.
class CustomIcons {
  /// Returns an `IconButton` that navigates based on the provided type string.
  static Icon buildIcon({
    required String type,
  }) {
    switch (type.toLowerCase()) {
      
      case 'add':
        return Icon(Icons.add, color: Colors.deepPurpleAccent, size: 28,);

      case 'lock':
        return Icon(Icons.lock, color: Colors.deepPurpleAccent, size: 28,);

      case 'contacts_outlined':
        return Icon(Icons.contacts_outlined, color: Colors.deepPurpleAccent, size: 80,);
      
      case 'mail':
        return Icon(Icons.mail_outline, color: Colors.deepPurpleAccent, size: 80,);

      default:
        return Icon(Icons.logout);
    }
  }

  static Widget buildIconButton({
    required String type,
    required BuildContext context, // Required for navigation
    Function(Object?)? onReturnData,
  }) {
    switch (type.toLowerCase()) {

      // case 'add-msg':
      //   return IconButton(
      //     icon: Icon(Icons.add),
      //     onPressed: () async {
      //       final result = await Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => NameScreen()), // Replace with actual screen
      //       );
      //       if (onReturnData != null) {
      //         onReturnData(result); // Pass the returned data to the callback
      //       }
      //     },
      //   );


      case 'logout':
        return IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
          },
        );

      default:
        return IconButton(
          icon: Icon(Icons.help_outline),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Unknown action for type: $type")),
            );
          },
        );
    }
  }
}



      

      // case 'add-contact':
      //   return IconButton(
      //     icon: Icon(Icons.person),
      //     onPressed: () async {
      //       final result = await Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => NameScreen()), // Replace with actual screen
      //       );
      //       if (onReturnData != null) {
      //         onReturnData(result); // Pass the returned data to the callback
      //       }
      //     },
      //   );
      // case 'email':
      //   return IconButton(
      //     icon: Icon(Icons.email),
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => EmailScreen()), // Replace with actual screen
      //       );
      //     },
      //   );
      // case 'password':
      //   return IconButton(
      //     icon: Icon(Icons.lock),
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => PasswordScreen()), // Replace with actual screen
      //       );
      //     },
      //   );
      // case 'home':
      //   return IconButton(
      //     icon: Icon(Icons.home),
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with actual screen
      //       );
      //     },
      //   );
      // case 'settings':
      //   return IconButton(
      //     icon: Icon(Icons.settings),
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => SettingsScreen()), // Replace with actual screen
      //       );
      //     },
      //   );
      // case 'logout':
      //   return IconButton(
      //     icon: Icon(Icons.logout),
      //     onPressed: () {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (context) => SignInScreen()), // Replace with actual screen
      //       );
      //     },
      //   );
    //   default:
    //     return IconButton(
    //       icon: Icon(Icons.help_outline),
    //       onPressed: () {
    //         ScaffoldMessenger.of(context).showSnackBar(
    //           SnackBar(content: Text("Unknown action for type: $type")),
    //         );
    //       },
    //     );
    // }
//   }
// }
