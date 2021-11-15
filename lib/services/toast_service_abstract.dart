import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mci_flutter_lib/config/mci_colors.dart';

part 'toast_service.dart';

abstract class ToastServiceAbstract {
  void showToast(BuildContext context, String text, Color textColor, Color backgroundColor, {Duration duration});
  void showValidToast(BuildContext context, String text);
  void showErrorToast(BuildContext context, String text);
}
