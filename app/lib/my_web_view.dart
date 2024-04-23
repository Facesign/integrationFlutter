import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Mywebview extends StatefulWidget {
  const Mywebview({super.key, required this.controller});

  final WebViewController controller;

  @override
  State<Mywebview> createState() => _MywebviewState();
}

class _MywebviewState extends State<Mywebview> {
  var loading = 0;
  @override
  void initState() {
    super.initState();
    widget.controller.setNavigationDelegate(NavigationDelegate(
      onPageStarted: (url) {
        setState(() {
          loading = 0;
        });
      },
      onProgress: (progress) {
        setState(() {
          loading = progress;
        });
      },
      onPageFinished: (url) {
        setState(() {
          loading = 100;
        });
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: widget.controller),
        if (loading < 100)
          LinearProgressIndicator(
            value: loading / 100,
          )
      ],
    );
  }
}
