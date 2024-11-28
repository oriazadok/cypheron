import 'package:flutter/material.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';

/// A reusable CircleAvatar widget with custom styling and content.
class LeadingUI extends StatelessWidget {
  final IconType type;

  const LeadingUI({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildLeading(type);
  }

  Widget buildLeading(IconType type) {

    if(type == IconType.person)
      return CircleAvatar(
      backgroundColor: Colors.deepPurpleAccent,
      child: IconsUI(type: IconType.person),
    ); 

    return SizedBox.shrink();
  }

}
