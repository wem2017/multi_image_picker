class MaterialOptions {
  final String actionBarColor;
  final String statusBarColor;
  final bool lightStatusBar;
  final String actionBarTitleColor;
  final String allViewTitle;
  final String actionBarTitle;

  const MaterialOptions({
    this.actionBarColor,
    this.actionBarTitle,
    this.lightStatusBar,
    this.statusBarColor,
    this.actionBarTitleColor,
    this.allViewTitle,
  });

  Map<String, String> toJson() {
    return {
      "actionBarColor": actionBarColor ?? "",
      "actionBarTitle": actionBarTitle ?? "",
      "actionBarTitleColor": actionBarTitleColor ?? "",
      "allViewTitle": allViewTitle ?? "",
      "lightStatusBar": lightStatusBar == true ? "true" : "false",
      "statusBarColor": statusBarColor ?? ""
    };
  }
}
