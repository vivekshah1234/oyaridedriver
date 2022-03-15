import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/controllers/webViewController.dart';
import 'package:webview_flutter/webview_flutter.dart';
class WebViewEx extends StatefulWidget {
 final String url;
 final String Referencenum;
  WebViewEx(this.url,this.Referencenum,);

  @override
  _WebViewExState createState() => _WebViewExState();
}

class _WebViewExState extends State<WebViewEx> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebviewGetController webviewGetController = Get.put(WebviewGetController());

  void initState() {
    super.initState();
    toast(widget.url);
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.whiteColor,
      appBar: appBarWidget2("Payment"),
      // appBar: appBarWidget(txt: AllStrings.connectBankAccount.tr, isBackArrow: true),
      body: GetX<WebviewGetController>(
          init: WebviewGetController(),
          builder: (controller) {
            if(controller.isLoading.value){
              return Center(child: greenLoadingWidget());
            }
            return WebView(
              initialUrl: widget.url,
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
                printInfo(info: 'Page started loading: $url');
              },
              onPageFinished: (String url) {
                printInfo(info: 'Page finished loading: $url');
                printInfo(info:(url=="${ApiConstant.baseUrl1}?trxref=${widget.Referencenum}#/success&reference=${widget.Referencenum}").toString());
                if(url=="${ApiConstant.baseUrl1}?trxref=${widget.Referencenum}#/success&reference=${widget.Referencenum}"){
                  Map<String,String> map={
                    "reference":widget.Referencenum,
                    "type":"2",
                    "trip_id":""
                  };
                  webviewGetController.verifyPayment(map,context);
                }
              },
              gestureNavigationEnabled: true,
            );
          }),
    );
  }
}
