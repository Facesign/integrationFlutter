import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const webviewFacesign(),
    );
  }
}

// ignore: camel_case_types
class webviewFacesign extends StatefulWidget {
  const webviewFacesign({super.key});

  @override
  State<webviewFacesign> createState() => _webviewFacesignState();
}

// ignore: camel_case_types
class _webviewFacesignState extends State<webviewFacesign> {
  late final WebViewController controller;
  late final params = const PlatformWebViewControllerCreationParams();

  var loading = 0;

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
    } else if (status == PermissionStatus.denied) {
    } else if (status == PermissionStatus.permanentlyDenied) {}
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController(
        onPermissionRequest: (WebViewPermissionRequest request) {
      request.grant();
    })
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              loading = progress;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              loading = 0;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              loading = 100;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://app.facesign.in/home')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://app.facesign.in/home'));

    if (controller.platform is AndroidWebViewController) {
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    requestCameraPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Integration webview Facesign"),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (loading < 100)
            LinearProgressIndicator(
              value: loading / 100,
            )
        ],
      ),
    );
  }
}
