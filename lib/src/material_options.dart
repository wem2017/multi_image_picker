class MaterialOptions {
  final String actionBarColor;
  final String statusBarColor;
  final bool lightStatusBar;
  final String actionBarTitleColor;
  final String allViewTitle;
  final String actionBarTitle;
  final bool startInAllView;
  final String selectCircleStrokeColor;
  final String selectionLimitReachedText;

  const MaterialOptions({
    this.actionBarColor,
    this.actionBarTitle,
    this.lightStatusBar,
    this.statusBarColor,
    this.actionBarTitleColor,
    this.allViewTitle,
    this.startInAllView,
    this.selectCircleStrokeColor,
    this.selectionLimitReachedText,
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
      "selectCircleStrokeColor": selectCircleStrokeColor ?? "",
      "selectionLimitReachedText": selectionLimitReachedText ?? "",
    };
  }
}
