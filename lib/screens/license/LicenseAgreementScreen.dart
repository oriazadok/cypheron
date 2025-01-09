import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; // For asynchronous operations
import 'package:flutter/services.dart' show rootBundle; // To load license text

class LicenseAgreementScreen extends StatefulWidget {
  final VoidCallback onAgree; // Callback to notify parent when the user agrees

  LicenseAgreementScreen({required this.onAgree});

  @override
  _LicenseAgreementScreenState createState() => _LicenseAgreementScreenState();
}

class _LicenseAgreementScreenState extends State<LicenseAgreementScreen> {
  String licenseText = "";
  bool canShowButtons = false; // Track whether the user can see the buttons
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadLicenseText();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadLicenseText() async {
    final text = await rootBundle.loadString('assets/license_agreement.txt');
    setState(() {
      licenseText = text;
    });
  }

  Future<void> _saveUserConsent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('license_approved', true);
  }

  void _proceed() async {
    await _saveUserConsent();
    widget.onAgree(); // Notify the parent widget that the user agreed
  }

  void _handleScroll() {
    if (_scrollController.hasClients) {
      // Check if user has scrolled to the bottom
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      if (currentScroll >= maxScroll) {
        setState(() {
          canShowButtons = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("License Agreement"),
        automaticallyImplyLeading: false,
      ),
      body: licenseText.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      licenseText,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: canShowButtons ? 1.0 : 0.0, // Buttons appear gradually
                  duration: Duration(milliseconds: 300),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Agreement Required"),
                              content: Text(
                                  "You must accept the license agreement to use this app."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text("OK"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text("Disagree"),
                      ),
                      ElevatedButton(
                        onPressed: _proceed,
                        child: Text("Agree"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
