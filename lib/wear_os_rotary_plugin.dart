/// A Flutter package providing a circular scrollbar overlay for Wear OS screens.
///
/// This package provides the [WearOsScrollbar] widget, which displays a visual
/// circular scrollbar that binds to a [ScrollController] and automatically
/// updates based on scroll position.
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wearable_rotary/wearable_rotary.dart';
export 'package:wearable_rotary/wearable_rotary.dart';

/// A circular scrollbar overlay widget for Wear OS screens.
///
/// The [WearOsScrollbar] widget automatically manages a [RotaryScrollController]
/// and wraps the child with a visual circular scrollbar that tracks scroll position.
/// It's designed to work with the `wearable_rotary` package's `RotaryScrollController`
/// to provide visual feedback for rotary input scrolling on Wear OS devices.
///
/// The scrollbar is positioned around the edge of the screen, starting at the
/// 2pm marker on an analog watch and extending to the 4pm marker.
///
/// Example:
/// ```dart
/// WearOsScrollbar(
///   builder: (context, rotaryScrollController) => ListView.builder(
///     controller: rotaryScrollController,
///     itemCount: 50,
///     itemBuilder: (context, index) => ListTile(
///       title: Text('Item $index'),
///     ),
///   ),
/// )
/// ```
class WearOsScrollbar extends StatefulWidget {
  /// Creates a [WearOsScrollbar] widget.
  ///
  /// The [builder] parameter must not be null.
  const WearOsScrollbar({
    required this.builder,
    super.key,
    this.autoHide = true,
    this.threshold = 0.2,
    this.bezelCorrection = 0.5,
    this.speed = 50.0,
    this.padding = 8.0,
    this.width = 2.0,
    this.opacityAnimationCurve = Curves.easeInOut,
    this.opacityAnimationDuration = const Duration(milliseconds: 500),
    this.autoHideDuration = const Duration(milliseconds: 1500),
  });

  /// Builder function that receives the [RotaryScrollController] and builds
  /// the scrollable widget.
  ///
  /// The controller is automatically created and managed by this widget.
  /// It should be passed to the scrollable widget (e.g., [ListView], [SingleChildScrollView]).
  final Widget Function(BuildContext context, RotaryScrollController rotaryScrollController) builder;

  /// Whether to automatically hide the scrollbar after scrolling stops.
  ///
  /// If `true`, the scrollbar will fade out after [autoHideDuration].
  /// If `false`, the scrollbar will always be visible.
  ///
  /// Defaults to `true`.
  final bool autoHide;

  /// Threshold to avoid jittering when scrolling.
  ///
  /// This value is used internally to prevent small movements from causing
  /// unwanted scroll updates.
  ///
  /// Defaults to `0.2`.
  final double threshold;

  /// Bezel correction factor for Samsung devices.
  ///
  /// Samsung devices may produce steps with exact value 1.0, which this
  /// factor corrects for smoother scrolling.
  ///
  /// Defaults to `0.5`.
  final double bezelCorrection;

  /// Scroll amount in screen dimensions.
  ///
  /// This value determines how much the scroll position changes per unit
  /// of rotary input.
  ///
  /// Defaults to `50.0`.
  final double speed;

  /// Padding of the scrollbar from the screen edge.
  ///
  /// Defaults to `8.0`.
  final double padding;

  /// Width of the scrollbar track and thumb.
  ///
  /// Defaults to `2.0`.
  final double width;

  /// Animation curve for blending the scrollbar in or out.
  ///
  /// Defaults to [Curves.easeInOut].
  final Curve opacityAnimationCurve;

  /// Animation duration for blending the scrollbar in or out.
  ///
  /// Defaults to `500` milliseconds.
  final Duration opacityAnimationDuration;

  /// Duration for keeping the scrollbar visible before auto-hiding.
  ///
  /// Only applies when [autoHide] is `true`.
  ///
  /// Defaults to `1500` milliseconds.
  final Duration autoHideDuration;

  @override
  State<WearOsScrollbar> createState() => _WearOsScrollbarBuilderState();
}

class _WearOsScrollbarBuilderState extends State<WearOsScrollbar> {
  late final RotaryScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RotaryScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _WearOsScrollbar(
      controller: _controller,
      autoHide: widget.autoHide,
      threshold: widget.threshold,
      bezelCorrection: widget.bezelCorrection,
      speed: widget.speed,
      padding: widget.padding,
      width: widget.width,
      opacityAnimationCurve: widget.opacityAnimationCurve,
      opacityAnimationDuration: widget.opacityAnimationDuration,
      autoHideDuration: widget.autoHideDuration,
      child: widget.builder(context, _controller),
    );
  }
}

/// Internal implementation of the scrollbar overlay widget.
class _WearOsScrollbar extends StatefulWidget {
  const _WearOsScrollbar({
    required this.controller,
    required this.child,
    this.autoHide = true,
    this.threshold = 0.2,
    this.bezelCorrection = 0.5,
    this.speed = 50.0,
    this.padding = 8.0,
    this.width = 2.0,
    this.opacityAnimationCurve = Curves.easeInOut,
    this.opacityAnimationDuration = const Duration(milliseconds: 500),
    this.autoHideDuration = const Duration(milliseconds: 1500),
  });

  final ScrollController controller;
  final Widget child;
  final bool autoHide;
  final double threshold;
  final double bezelCorrection;
  final double speed;
  final double padding;
  final double width;
  final Curve opacityAnimationCurve;
  final Duration opacityAnimationDuration;
  final Duration autoHideDuration;

  @override
  State<_WearOsScrollbar> createState() => _WearOsScrollbarState();
}

class _WearOsScrollbarState extends State<_WearOsScrollbar> {
  double _position = 0;
  double _maxPosition = 0;
  double _thumbSize = 0;
  bool _isScrollBarShown = false;
  Timer? _hideTimer;

  void _onScrolled() {
    if (widget.controller.hasClients) {
      setState(() {
        _isScrollBarShown = true;
        _updateScrollValues();
      });
      _hideAfterDelay();
    }
  }

  void _hideAfterDelay() {
    if (widget.autoHide) {
      _hideTimer?.cancel();
      _hideTimer = Timer(widget.autoHideDuration, () {
        if (mounted) {
          setState(() => _isScrollBarShown = false);
        }
        _hideTimer = null;
      });
    }
  }

  void _updateScrollValues() {
    if (!widget.controller.hasClients) {
      return;
    }
    _maxPosition = widget.controller.position.maxScrollExtent;
    _thumbSize = 1 / ((_maxPosition / widget.controller.position.viewportDimension) + 1);
    _position = widget.controller.offset / math.max(_maxPosition, 1);
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScrolled);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollValues();
      setState(() {});
      _hideAfterDelay();
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    widget.controller.removeListener(_onScrolled);
    super.dispose();
  }

  Widget _addAnimatedOpacity({required Widget child}) {
    return widget.autoHide
        ? AnimatedOpacity(
            opacity: _isScrollBarShown ? 1.0 : 0.0,
            duration: widget.opacityAnimationDuration,
            curve: widget.opacityAnimationCurve,
            child: child,
          )
        : child;
  }

  Widget _buildTrack(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _RoundProgressBarPainter(
        // Using withOpacity for Flutter 3.0+ compatibility
        color: Theme.of(context).highlightColor.withOpacity(0.2), // ignore: deprecated_member_use
        trackPadding: widget.padding,
        trackWidth: widget.width,
      ),
    );
  }

  Widget _buildThumb(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _RoundProgressBarPainter(
        start: _position * (1 - _thumbSize),
        length: _thumbSize,
        // Using withOpacity for Flutter 3.0+ compatibility
        color: Theme.of(context).highlightColor.withOpacity(1), // ignore: deprecated_member_use
        trackPadding: widget.padding,
        trackWidth: widget.width,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        IgnorePointer(
          child: _addAnimatedOpacity(
            child: Stack(
              children: [
                _buildTrack(context),
                _buildThumb(context),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// A custom painter that draws a circular progress bar.
///
/// The progress bar starts at the 2pm marker on an analog watch and extends
/// to the 4pm marker. It's used to draw both the track and thumb of the
/// scrollbar.
class _RoundProgressBarPainter extends CustomPainter {
  /// Creates a [_RoundProgressBarPainter] with the given parameters.
  const _RoundProgressBarPainter({
    required this.color,
    required this.trackWidth,
    required this.trackPadding,
    this.start = 0.0,
    this.length = 1.0,
  });

  /// Starting angle for the progress bar (2pm marker on analog watch).
  static const double _startingAngle = (math.pi * 2) * (-2 / 24);

  /// Angle length for the progress bar (2pm to 4pm on analog watch).
  static const double _angleLength = (math.pi * 2) * (2 / 12);

  /// Color of the progress bar.
  final Color color;

  /// Width of the progress bar track.
  final double trackWidth;

  /// Padding from the screen edge.
  final double trackPadding;

  /// Starting position of the progress bar (0.0 to 1.0).
  final double start;

  /// Length of the progress bar (0.0 to 1.0).
  final double length;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = trackWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final centerOffset = Offset(size.width / 2, size.height / 2);
    final innerWidth = size.width - trackPadding * 2 - trackWidth;
    final innerHeight = size.height - trackPadding * 2 - trackWidth;

    final path = Path()
      ..arcTo(
        Rect.fromCenter(center: centerOffset, width: innerWidth, height: innerHeight),
        _startingAngle + _angleLength * start,
        _angleLength * length,
        true,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _RoundProgressBarPainter oldDelegate) {
    return color != oldDelegate.color ||
        start != oldDelegate.start ||
        length != oldDelegate.length ||
        trackWidth != oldDelegate.trackWidth ||
        trackPadding != oldDelegate.trackPadding;
  }
}
