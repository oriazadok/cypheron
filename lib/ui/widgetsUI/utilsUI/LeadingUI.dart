import 'package:flutter/material.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';

/// A reusable CircleAvatar widget with custom styling and content.
class LeadingUI extends StatelessWidget {
  final String type;

  const LeadingUI({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.deepPurpleAccent,
      child: IconsUI(type: type),
    );
  }

  Widget buildLeading(String type) {

    if(type == "avatar-person")
      return CircleAvatar(
      backgroundColor: Colors.deepPurpleAccent,
      child: IconsUI(type: type),
    ); 

    return SizedBox.shrink();
  }

}
