class MaterialOptions {
  final String actionBarColor;
  final String statusBarColor;
  final bool lightStatusBar;
  final String actionBarTitleColor;
  final String allViewTitle;
  final String actionBarTitle;
  final bool startInAllView;
  final String selectCircleStrokeColor;

  const MaterialOptions({
    this.actionBarColor,
    this.actionBarTitle,
    this.lightStatusBar,
    this.statusBarColor,
    this.actionBarTitleColor,
    this.allViewTitle,
    this.startInAllView,
    this.selectCircleStrokeColor,
  });

  Map<String, String> toJson() {
    return {
      "actionBarColor": actionBarColor ?? "",
      "actionBarTitle": actionBarTitle ?? "",
      "actionBarTitleColor": actionBarTitleColor ?? "",
      "allViewTitle": allViewTitle ?? "",
      "lightStatusBar": lightStatusBar == true ? "true" : "false",
      "statusBarColor": statusBarColor ?? "",
      "startInAllView": startInAllView == true ? "true" : "false",
      "selectCircleStrokeColor": selectCircleStrokeColor ?? ""
    };
  }
}
