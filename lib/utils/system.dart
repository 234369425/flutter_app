import 'package:flutter/cupertino.dart';

class SystemUtil {
  static hideSoftKeyBoard(BuildContext context) {
    FocusNode node = FocusNode();
    FocusScope.of(context).requestFocus(node);
  }

  static wrapperPadding(Widget widget, BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: widget,
    );
  }

  static keyBoardHeight(BuildContext context) {
    return EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom);
  }

  static emptyExpanded(int flex) {
    return Expanded(flex: flex, child: Text(''));
  }
}
