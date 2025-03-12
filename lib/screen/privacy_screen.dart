import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  WebViewScreen({required this.url, required this.title});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late InAppWebViewController webViewController;
  bool isConnected = true;
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();
    connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    _checkInternetConnection();
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkInternetConnection() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      isConnected = (result != ConnectivityResult.none);
    });
  }

  /// ✅ Handles external URLs (WhatsApp, Phone, Email, Intent Links)
  Future<NavigationActionPolicy> _handleExternalLinks(
      InAppWebViewController controller, NavigationAction navigationAction) async {
    var uri = navigationAction.request.url;

    if (uri != null) {
      String urlString = uri.toString();
      print("Navigating to: $urlString");

      // ✅ 1. Fix `intent://` Unknown URL Scheme
      if (urlString.startsWith("intent://")) {
        try {
          // Extract the actual HTTP URL from the intent:// link
          Uri fallbackUrl;
          String cleanUrl = urlString.replaceFirst("intent://", "https://");

          if (cleanUrl.contains(";")) {
            cleanUrl = cleanUrl.split(";")[0]; // Extracts only the URL part
          }

          fallbackUrl = Uri.parse(cleanUrl);
          print("Converted intent:// to: $fallbackUrl");

          if (await canLaunchUrl(fallbackUrl)) {
            await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
          }
        } catch (e) {
          print("Error opening intent:// link: $e");
        }
        return NavigationActionPolicy.CANCEL;
      }

      // ✅ 2. Handle External Apps (WhatsApp, Email, Phone, SMS)
      if (urlString.startsWith("whatsapp://") ||
          urlString.startsWith("mailto:") ||
          urlString.startsWith("tel:") ||
          urlString.startsWith("sms:")) {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          print("Could not launch external app: $urlString");
        }
        return NavigationActionPolicy.CANCEL;
      }

      // ✅ 3. Allow normal HTTP/HTTPS navigation inside WebView
      if (uri.scheme == "http" || uri.scheme == "https") {
        return NavigationActionPolicy.ALLOW;
      }
    }

    return NavigationActionPolicy.CANCEL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: isConnected
          ? InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          return await _handleExternalLinks(controller, navigationAction);
        },
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
              resources: resources, action: PermissionRequestResponseAction.GRANT);
        },
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text('No Internet Connection', style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkInternetConnection,
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
