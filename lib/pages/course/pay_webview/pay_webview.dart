import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning/common/routes/names.dart';
import 'package:ulearning/common/values/colors.dart';
import 'package:ulearning/pages/course/pay_webview/notifiers/pay_webview_notifier.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayWebview extends ConsumerStatefulWidget {
  const PayWebview({super.key});

  @override
  ConsumerState<PayWebview> createState() => _PayWebviewPage();
}

class _PayWebviewPage extends ConsumerState<PayWebview> {
  late final WebViewController webViewController;
  @override
  void initState() {
    super.initState();
   //
    Future.delayed(Duration.zero, () async{
      ref.read(payWebviewProvider.notifier).onUrlChanged(UrlChanged(""));
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      print(args["url"]);
      ref.read(payWebviewProvider.notifier).onUrlChanged(UrlChanged(args["url"]));
    });
  }
  @override
  void dispose() {
    if(webViewController!=null){
      webViewController.clearCache();
    }

    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
   // if (Platform.isAndroid) WebView.platform = AndroidWebView();
    final state = ref.watch(payWebviewProvider);
      return Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        body: state.url==""?Container():WebView(
          initialUrl: state.url,
          javascriptMode:JavascriptMode.unrestricted,
          javascriptChannels: Set.from([
            JavascriptChannel(
                name: 'Pay',
                onMessageReceived: (JavascriptMessage message) {
                  //This is where you receive message from
                  //4242424242424242
                  //javascript code and handle in Flutter/Dart
                  //like here, the message is just being printed
                  //in Run/LogCat window of android studio
                  print(message.message);
                  Navigator.of(context).pop(message.message);

                })
          ]),
          onWebViewCreated: (WebViewController w) {
            webViewController = w;
          },

        ),
      );

  }




  AppBar _buildAppBar() {
    return AppBar(
      title: Container(
        child: Text(
          "Pay Page",
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

}
