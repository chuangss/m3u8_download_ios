import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//纯色按钮
class DButton extends StatelessWidget {
  final String? title;
  final double? radius;
  final Size? size;
  final Color? color;
  final Color? overlayColor;
  final BorderSide? side;
  final Widget? child;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final double? elevation;

  DButton({
    Key? key,
    this.title,
    this.radius,
    this.size,
    this.color,
    this.overlayColor,
    this.side,
    this.child,
    this.onPressed,
    this.padding,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(elevation ?? 0),
        enableFeedback: true,
        padding:MaterialStateProperty.all(padding ?? EdgeInsets.zero),
        minimumSize: MaterialStateProperty.all(const Size(0, 0)),
        fixedSize: (size != null) ? MaterialStateProperty.all(size) : null,
        backgroundColor: MaterialStateProperty.all(color ?? Theme.of(context).primaryColor),
        overlayColor: (overlayColor == null) ? null : MaterialStateProperty.all(overlayColor),
        shape: MaterialStateProperty.all(
          (side == null)
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius ?? ((size?.width ?? 44) / 2)),
                )
              : RoundedRectangleBorder(
                  side: side!,
                  borderRadius: BorderRadius.circular(radius ?? ((size?.width ?? 44) / 2)),
                ),
        ),
      ),
      onPressed: onPressed,
      child: child ??
          Text(
            title ?? "DButton",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white),
          ),
    );
  }
}

//自定义按钮  渐变色
class CButton extends StatelessWidget {
  final String? title;
  final double? radius;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;

  //水波纹颜色
  final Color? splashColor;
  final double? elevation;
  final Widget? child;
  final VoidCallback? onPressed;
  final BoxDecoration? decoration;

  CButton({
    Key? key,
    this.title,
    this.radius,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.elevation,
    this.child,
    this.onPressed,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _radius = radius ?? 0;
    return Card(
      margin: EdgeInsets.zero,
      shape: (_radius != 0)
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius))
          : null,
      elevation: elevation ?? 0,
      child: Ink(
        padding: EdgeInsets.zero,
        decoration: decoration ??
            BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.cyan, Colors.black]),
              borderRadius: _radius != 0 ? BorderRadius.all(Radius.circular(_radius)) : null,
              border: Border.all(color: Colors.blue),
            ),
        child: InkWell(
          focusColor: focusColor,
          hoverColor: hoverColor,
          highlightColor: highlightColor,
          splashColor: splashColor ?? Colors.black12,
          borderRadius: _radius != 0 ? BorderRadius.all(Radius.circular(_radius)) : null,
          child: child ??
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(title ?? 'CButton'),
              ),
          onTap: onPressed,
        ),
      ),
    );
  }
}

//文本按钮
class DTextButton extends StatelessWidget {
  final String? title;
  final double? radius;
  final Size? size;
  final Color? backgroundColor;
  final Widget? child;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;

  final Color? overlayColor;

  DTextButton({
    Key? key,
    this.title,
    this.radius,
    this.size,
    this.backgroundColor,
    this.child,
    this.onPressed,
    this.padding,
    this.overlayColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        enableFeedback: true,
        padding: (padding == null)
            ? MaterialStateProperty.all(EdgeInsets.zero)
            : MaterialStateProperty.all(padding),
        minimumSize: MaterialStateProperty.all(const Size(0, 0)),
        fixedSize: (size != null) ? MaterialStateProperty.all(size) : null,
        backgroundColor: MaterialStateProperty.all(backgroundColor ?? Colors.transparent),
        // shadowColor: MaterialStateProperty.all(Colors.red),
        overlayColor: (overlayColor == null) ? null : MaterialStateProperty.all(overlayColor),

        // shadowColor: MaterialStateProperty.all(color ?? Colors.transparent),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? ((size?.width ?? 44) / 2))),
        ),
      ),
      onPressed: onPressed,
      child: child ??
          Text(
            title ?? "DTextButton",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
          ),
    );
  }
}

///
typedef CBtnWidgetBuilder = Widget Function(BuildContext context, bool enter);

class COverView extends StatefulWidget {
  final CBtnWidgetBuilder builder;

  const COverView({Key? key, required this.builder}) : super(key: key);

  @override
  _COverViewState createState() => _COverViewState();
}

class _COverViewState extends State<COverView> {
  bool _isOver = false;

  void refreshUI() {
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildMouseRegion(
      check: (bool isEnter) {
        _isOver = isEnter;
        refreshUI();
      },
      child: widget.builder(context, _isOver),
    );
  }

  MouseRegion buildMouseRegion({Widget? child, Function(bool enter)? check}) {
    return MouseRegion(
      //进入
      onEnter: (PointerEnterEvent event) {
        if (check != null) check(true);
      },
      onExit: (PointerExitEvent event) {
        if (check != null) check(false);
      },
      onHover: (PointerHoverEvent event) {},
      child: child,
    );
  }
}
