import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; // For asynchronous operations
import 'package:flutter/services.dart' show rootBundle; // To load license text

class LicenseAgreementScreen extends StatefulWidget {
  final VoidCallback onAgree;

  LicenseAgreementScreen({required this.onAgree});

  @override
  _LicenseAgreementScreenState createState() => _LicenseAgreementScreenState();
}

class _LicenseAgreementScreenState extends State<LicenseAgreementScreen> {
  String licenseText = "";
  bool canShowButton = false;
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
    widget.onAgree();
  }

  void _handleScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (currentScroll >= maxScroll) {
        setState(() {
          canShowButton = true;
        });
      }
    }
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                text.trim(),
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.left,
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
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
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: licenseText.split('\n').map((line) {
                              String trimmedLine = line.trim();
                              if (trimmedLine.startsWith(RegExp(r'\d+\.'))) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    trimmedLine,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                );
                              } else if (trimmedLine.startsWith('- ')) {
                                return _buildBulletPoint(trimmedLine.substring(2));
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    trimmedLine,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.left,
                                  ),
                                );
                              }
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  AnimatedOpacity(
                    opacity: canShowButton ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 300),
                    child: ElevatedButton(
                      onPressed: _proceed,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      child: Text("I Agree"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
