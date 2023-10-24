import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;

  Badge({required this.child, required this.value});
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            constraints: const BoxConstraints(minWidth: 16, maxHeight: 18),
            height: 20,
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
                child: Text(
              value,
            )),
          ),
        )
      ],
    );
  }
}
