part of 'toast_service_abstract.dart';

class ToastService implements ToastServiceAbstract {
  @override
  showToast(BuildContext context, String text, Color textColor, Color backgroundColor,
      {Duration duration = const Duration(seconds: 5)}) {
    FToast fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: backgroundColor,
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );

    fToast.showToast(
        child: toast,
        toastDuration: duration,
        positionedToastBuilder: (context, child) {
          return Positioned(child: child, left: 25, right: 25, bottom: 75 + MediaQuery.of(context).viewPadding.bottom);
        });
  }

  @override
  void showErrorToast(BuildContext context, String text) {
    showToast(context, text, Colors.white, MCIColors.secondary);
  }

  @override
  void showValidToast(BuildContext context, String text) {
    showToast(context, text, Colors.white, Colors.black);
  }
}
