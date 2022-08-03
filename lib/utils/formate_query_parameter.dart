class FormatQueryParameter {
  Map<String, dynamic> replaceSpace(Map<String, dynamic> queryParameters) {
    Map<String, String?> returnMap = {};

    queryParameters.forEach((String k, dynamic v) {
      print("returnMap 11:- "  + v.toString());
      String? newValue = v;
      if (newValue != null) {
          newValue = v.replaceAll(" ", "%20");
      }
      returnMap.putIfAbsent(k, () => newValue);
    });
    print("returnMap :- "  + returnMap.toString());
    return returnMap;
  }
}
