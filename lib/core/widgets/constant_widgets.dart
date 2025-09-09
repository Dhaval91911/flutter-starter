import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

SizedBox height(double h) => SizedBox(height: h);

SizedBox width(double w) => SizedBox(width: w);

// Show progress indicator
showProgressIndicator() {
  return EasyLoading.show(
    maskType: EasyLoadingMaskType.black,
    status: 'Loading',
    dismissOnTap: false,
  );
}

// Dismiss progress indicator
dismissProgressIndicator() {
  return EasyLoading.dismiss();
}

// Stop for going back
void onPopInvoked(didPop) async {
  if (didPop) {
    return;
  }
  if (EasyLoading.isShow) {
    return;
  }
}
