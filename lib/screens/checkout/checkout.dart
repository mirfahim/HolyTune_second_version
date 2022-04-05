import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:loading_overlay/loading_overlay.dart';

class CheckoutSP extends StatefulWidget {
  var checkoutUrl;

  CheckoutSP({
    Key key,
    this.checkoutUrl,
  }) : super(key: key);

  @override
  State<CheckoutSP> createState() => _CheckoutSPState();
}

class _CheckoutSPState extends State<CheckoutSP> {
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      color: Colors.blue.shade200,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(widget.checkoutUrl)),
          onLoadStop: (InAppWebViewController controller, dynamic url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      ),
    );
  }
}
