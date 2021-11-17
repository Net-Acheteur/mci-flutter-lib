import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mci_flutter_lib/config/mci_colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SmartRefresherMCI extends StatefulWidget {
  final Widget child;
  final bool hasRefresh;
  final Future<int> Function(BuildContext) onRefresh;
  final bool hasLoading;
  final Future<int> Function() onLoading;
  final bool initialRefresh;
  final bool reversed;
  final Color colorText;
  final Color colorSpinner;
  final Color backgroundSpinner;

  const SmartRefresherMCI._(
      {Key? key,
      required this.child,
      required this.hasRefresh,
      required this.onRefresh,
      required this.hasLoading,
      required this.onLoading,
      required this.initialRefresh,
      this.reversed = false,
      Color? colorText,
      Color? colorSpinner,
      Color? backgroundSpinner})
      : colorText = colorText ?? MCIColors.grayDark,
        colorSpinner = colorSpinner ?? MCIColors.primary,
        backgroundSpinner = backgroundSpinner ?? Colors.transparent,
        super(key: key);

  factory SmartRefresherMCI(
      {Key? key,
      required Widget child,
      required Future<int> Function(BuildContext) onRefresh,
      required Future<int> Function() onLoading,
      bool initialRefresh = false,
      Color? colorText,
      Color? colorSpinner,
      Color? backgroundSpinner}) {
    return SmartRefresherMCI._(
        key: key,
        child: child,
        hasRefresh: true,
        onRefresh: onRefresh,
        hasLoading: true,
        onLoading: onLoading,
        initialRefresh: initialRefresh,
        colorText: colorText,
        colorSpinner: colorSpinner,
        backgroundSpinner: backgroundSpinner);
  }

  factory SmartRefresherMCI.refresher(
      {Key? key,
      required Widget child,
      required Future<int> Function(BuildContext) onRefresh,
      bool initialRefresh = false,
      bool reversed = false,
      Color? colorText,
      Color? colorSpinner,
      Color? backgroundSpinner}) {
    return SmartRefresherMCI._(
        key: key,
        child: child,
        hasRefresh: true,
        onRefresh: onRefresh,
        hasLoading: false,
        onLoading: () async => 0,
        initialRefresh: initialRefresh,
        reversed: reversed,
        colorText: colorText,
        colorSpinner: colorSpinner,
        backgroundSpinner: backgroundSpinner);
  }

  factory SmartRefresherMCI.loader(
      {Key? key,
      required Widget child,
      required Future<int> Function() onLoading,
      bool initialRefresh = false,
      bool reversed = false,
      Color? colorText,
      Color? colorSpinner,
      Color? backgroundSpinner}) {
    return SmartRefresherMCI._(
        key: key,
        child: child,
        hasRefresh: false,
        onRefresh: (_) async => 0,
        hasLoading: true,
        onLoading: onLoading,
        initialRefresh: initialRefresh,
        reversed: reversed,
        colorText: colorText,
        colorSpinner: colorSpinner,
        backgroundSpinner: backgroundSpinner);
  }

  @override
  _SmartRefresherMCIState createState() => _SmartRefresherMCIState();
}

class _SmartRefresherMCIState extends State<SmartRefresherMCI> {
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: widget.initialRefresh);
  }

  void _onRefresh(BuildContext context) async {
    int result = await widget.onRefresh(context);
    if (result > 0) {
      _refreshController.refreshCompleted();
    } else if (result < 0) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.refreshToIdle();
    }
  }

  void _onLoading() async {
    int result = await widget.onLoading();
    if (result > 0) {
      _refreshController.loadComplete();
    } else if (result < 0) {
      _refreshController.loadFailed();
    } else {
      _refreshController.loadNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: widget.hasRefresh,
      enablePullUp: widget.hasLoading,
      header: widget.hasRefresh
          ? SmartRefresherMCIHeader(
              colorSpinner: widget.colorSpinner,
              backgroundSpinner: widget.backgroundSpinner,
              colorText: widget.colorText,
              reversed: widget.reversed)
          : null,
      footer: widget.hasRefresh ? SmartRefresherMCIFooter(reversed: widget.reversed) : null,
      controller: _refreshController,
      onRefresh: () => _onRefresh(context),
      onLoading: _onLoading,
      child: widget.child,
    );
  }
}

class SmartRefresherMCIHeader extends StatelessWidget {
  final Color colorText;
  final Color backgroundSpinner;
  final Color colorSpinner;
  final bool reversed;

  const SmartRefresherMCIHeader(
      {Key? key,
      required this.colorText,
      required this.backgroundSpinner,
      required this.colorSpinner,
      required this.reversed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      builder: (BuildContext context, RefreshStatus? status) {
        Widget body;
        TextStyle textStyle = TextStyle(color: colorText);
        if (status == RefreshStatus.idle) {
          body = Text(AppLocalizations.of(context)!.smartRefresherPullToLoad, style: textStyle);
        } else if (status == RefreshStatus.completed) {
          body = Text(AppLocalizations.of(context)!.smartRefresherDataRefreshed, style: textStyle);
        } else if (status == RefreshStatus.refreshing) {
          body = CircularProgressIndicator(backgroundColor: backgroundSpinner, color: colorSpinner);
        } else if (status == RefreshStatus.failed) {
          body = Text(AppLocalizations.of(context)!.smartRefresherFailed, style: textStyle);
        } else if (status == RefreshStatus.canRefresh) {
          body = Text(AppLocalizations.of(context)!.smartRefresherPullToLoad, style: textStyle);
        } else {
          body = Text(AppLocalizations.of(context)!.smartRefresherNoData, style: textStyle);
        }

        if (reversed) {
          return Transform.rotate(angle: -3.14 / 1, child: Center(child: body));
        } else {
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        }
      },
      refreshStyle: RefreshStyle.Behind,
    );
  }
}

class SmartRefresherMCIFooter extends StatelessWidget {
  final bool reversed;

  const SmartRefresherMCIFooter({Key? key, required this.reversed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? status) {
        Widget body;
        if (status == LoadStatus.idle) {
          body = Text(AppLocalizations.of(context)!.smartRefresherPullToLoad);
        } else if (status == LoadStatus.loading) {
          body = const CircularProgressIndicator.adaptive();
        } else if (status == LoadStatus.failed) {
          body = Text(AppLocalizations.of(context)!.smartRefresherFailed);
        } else if (status == LoadStatus.canLoading) {
          body = Text(AppLocalizations.of(context)!.smartRefresherPullToLoad);
        } else {
          body = Text(AppLocalizations.of(context)!.smartRefresherNoData);
        }

        if (reversed) {
          return Transform.rotate(angle: -3.14 / 1, child: Center(child: body));
        } else {
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        }
      },
    );
  }
}
