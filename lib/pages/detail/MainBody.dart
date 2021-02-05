import 'package:flutter/cupertino.dart';

class MainBody extends StatefulWidget {
  final Widget child;
  final Color color;
  final Decoration decoration;
  final GestureTapCallback onTap;

  MainBody(
      {this.child,
      this.color = const Color(0xfff4f4f4),
      this.decoration,
      this.onTap});

  @override
  State<StatefulWidget> createState() {
    return new MainBodyState();
  }
}

class MainBodyState extends State<MainBody> {
  @override
  Widget build(BuildContext context) {
    return widget.decoration != null
        ? new Container(
            decoration: widget.decoration,
            height: double.infinity,
            width: double.infinity,
            child: new GestureDetector(
              child: widget.child,
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                if (widget.onTap != null) {
                  widget.onTap();
                }
              },
            ),
          )
        : new Container(
            color: widget.color,
            height: double.infinity,
            width: double.infinity,
            child: new GestureDetector(
              child: widget.child,
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                if (widget.onTap != null) {
                  widget.onTap();
                }
              },
            ),
          );
  }
}
