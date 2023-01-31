library rotating_widgets;

import 'dart:async';

import 'package:flutter/material.dart';

class RotatingWidget extends StatefulWidget {
  /// `RotatingWidget` with customizable option to allow rotation across `X-Axis`, `Y-Axis` and `Z-axis`
  /// change the `angle(in radians)` by which rotation occurs along each axis.
  ///
  /// `NOTE:`
  /// Example: Let rotation occur only on X-Axis
  ///
  /// ```
  /// RotatingWidget(
  ///   ...
  ///   rotateX: true,
  ///   rotateY: false,
  ///   rotateZ: false,
  /// )
  /// ```
  ///
  const RotatingWidget(
      {required this.child,
        required this.controller,
        this.rotateX = true,
        this.rotateY = true,
        this.rotateZ = false,
        this.duration = const Duration(seconds: 1),
        this.angleRadianX = 0.01,
        this.angleRadianY = 0.01,
        this.angleRadianZ = 0.01});

  /// [child] refers the `widget` being turned into a rotate-able widget
  final Widget child;

  /// [controller] is used to listen for a change in the autoplay property, that
  /// can be changed by the user swiping (or panning) on the widget
  final RotatingWidgetsController controller;

  /// [rotateX] is a [boolean] for whether the widget should rotate around X-Axis
  final bool rotateX;

  /// [rotateY] is a [boolean] for whether the widget should rotate around Y-Axis
  ///
  /// But user can use these flags to limit rotation axis on `autoplay` as well
  final bool rotateY;

  /// [rotateZ] is a [boolean] for whether the widget should rotate around Z-Axis
  ///
  /// But user can use these flags to limit rotation axis on `autoplay` as well
  final bool rotateZ;

  /// The [angleRadianX] refers to angle by which widget turns across X-Axis, per unit [Offset] along that axis
  final double angleRadianX;

  /// The [angleRadianY] refers to angle by which widget turns across Y-Axis, per unit [Offset] along that axis
  final double angleRadianY;

  /// The [angleRadianZ] refers to angle by which widget turns across Z-Axis, per unit [Offset] along both axis
  final double angleRadianZ;

  /// The [duration] refers to the duration between which said [widget] rotates around individual axis by said angle
  final Duration duration;

  @override
  _RotatingWidgetState createState() => _RotatingWidgetState();
}

class _RotatingWidgetState extends State<RotatingWidget> {
  late Offset _offset;
  late Offset _animationOffset;
  late Timer _timer;
  double dispX = 0.0;
  double dispY = 0.0;
  double dispZ = 0.0;

  @override
  void initState() {
    _offset = Offset.zero;
    _animationOffset = checkDuration();
    _animationSequence();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Offset checkDuration() {
    int microseconds = widget.duration.inMicroseconds ~/ 500;
    return Offset(widget.angleRadianX / microseconds, widget.angleRadianY / microseconds);
  }

  void executeRotation(Offset targetOffset) {
    setState(() {
      if (widget.rotateX) dispX = widget.angleRadianX * targetOffset.dy;
      if (widget.rotateY) dispY = widget.angleRadianY * -1 * targetOffset.dx;
      if (widget.rotateZ) dispZ = widget.angleRadianY * -1 * targetOffset.distance;
    });
    _offset = targetOffset;
  }

  _animationSequence() {
    _timer = Timer.periodic(Duration(microseconds: 500), (val) {
      if (widget.controller.getAutoplay) {
        executeRotation(_offset + _animationOffset);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanUpdate: (details) {
          if (widget.controller.getAutoplay) widget.controller.setAutoplay(false);
          executeRotation(_offset + details.delta);
        },
        onDoubleTap: () {
          if (widget.controller.getAutoplay) widget.controller.setAutoplay(false);
          dispX = 0;
          dispY = 0;
          dispZ = 0;
          executeRotation(Offset.zero);
        },
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(dispX)
            ..rotateY(dispY)
            ..rotateZ(dispZ),
          alignment: FractionalOffset.center,
          child: widget.child,
        ));
  }
}

/// Controller for RotatingWidgets. Used to listen for changes to the [autoplay] property,
/// exposes also setter, getter and toggler
class RotatingWidgetsController {
  RotatingWidgetsController({required bool autoplayEnabled}) : autoplay = ValueNotifier(autoplayEnabled);

  /// [autoplay] notifier, sends a notification to listeners when changed
  late ValueNotifier<bool> autoplay;
  /// getter
  get getAutoplay => autoplay.value;
  /// setter
  void setAutoplay(bool newValue) {
    autoplay.value = newValue;
  }
  /// toggles true/false
  void toggleAutoplay() {
    autoplay.value = !autoplay.value;
  }
}

