import 'package:flutter/cupertino.dart';

class CustomPageRoute extends PageRouteBuilder{
  final Widget child;
  CustomPageRoute({required this.child}):
        super(
          transitionDuration: Duration(milliseconds: 300),
          reverseTransitionDuration: Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation)=>child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) => ScaleTransition(scale: animation,child: child,);
}