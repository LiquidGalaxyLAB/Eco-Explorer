import 'package:flutter/material.dart';
import '../constants/strings.dart';

class ControllerButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  final String? tooltip;

  const ControllerButton({
    super.key,
    required this.onPressed,
    required this.iconData,
    this.tooltip,
  });

  @override
  State<ControllerButton> createState() => _ControllerButtonState();
}

class _ControllerButtonState extends State<ControllerButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final size = Constants.totalWidth(context) * 0.125;
    final iconSize = Constants.totalWidth(context) * 0.08;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTapUp: (_) => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        transform: Matrix4.translationValues(0, _isPressed ? 2.0 : 0.0, 0),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
            boxShadow: _isPressed
                ? [] : [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              widget.iconData,
              color: Colors.white,
              size: iconSize,
            ),
            onPressed: widget.onPressed,
            tooltip: widget.tooltip,
          ),
        ),
      ),
    );
  }
}
