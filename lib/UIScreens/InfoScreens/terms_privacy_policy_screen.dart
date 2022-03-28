import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsPrivacyPolicyScreen extends StatefulWidget {
  final bool privacyPolicy;

  const TermsPrivacyPolicyScreen(this.privacyPolicy, {Key? key}) : super(key: key);

  @override
  _TermsPrivacyPolicyScreenState createState() => _TermsPrivacyPolicyScreenState();
}

class _TermsPrivacyPolicyScreenState extends State<TermsPrivacyPolicyScreen> {


  final Completer<WebViewController> _controller = Completer<WebViewController>();
  String termsConditionUrl = "https://oyaride.com/terms/";
  String privacyPolicyUrl = "https://oyaride.com/privacy/";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget2(widget.privacyPolicy ? "Privacy Policy" : "Terms and Conditions"),
      body: Stack(
        alignment: Alignment.center,
        children: [
          WebView(
            initialUrl: widget.privacyPolicy ? privacyPolicyUrl : termsConditionUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            debuggingEnabled: true,

            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                printInfo(info: 'blocking navigation to $request}');
                return NavigationDecision.prevent;
              }
              printInfo(info: 'allowing navigation to $request');

              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              isLoading = true;
              setState(() {});
              printInfo(info: 'Page started loading: $url');
            },
            onPageFinished: (String url) {
              printInfo(info: 'Page finished loading: $url');
              isLoading = false;
              setState(() {});
            },
            gestureNavigationEnabled: true,
          ),
          Visibility(
            visible: isLoading,
            child:greenLoadingWidget(),
          ),
        ],
      ),
    );
  }
}
