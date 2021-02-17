import 'package:flutter/cupertino.dart';

class SystemUtil {
  static hideSoftKeyBoard(BuildContext context) {
    FocusNode node = FocusNode();
    FocusScope.of(context).requestFocus(node);
  }
}
