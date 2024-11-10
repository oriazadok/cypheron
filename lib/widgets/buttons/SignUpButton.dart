import 'package:flutter/material.dart';
import 'package:cypheron/screens/auth/SignUp.dart';

/// A button widget for navigating to the SignUp screen.
/// 
/// When tapped, this button will take the user to the SignUp screen,
/// where they can register a new account.
class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(30.0),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUp()),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 18.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            gradient: LinearGradient(
              colors: [Color(0xFF2B2B2B), Color(0xFF1C1C1C)], // Dark gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.purple[600]!, // Outline color
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.purple[300], // Lighter text color for better contrast
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
