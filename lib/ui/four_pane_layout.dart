import 'package:flutter/material.dart';

/// Four-pane layout: top-left / bottom-left / center / right.
///
/// Side pane widths are fixed (they do not stretch with the window) but can
/// be resized by dragging the pane boundaries. The center pane takes the
/// remaining width.
class FourPaneLayout extends StatefulWidget {
  const FourPaneLayout({
    required this.topLeft,
    required this.bottomLeft,
    required this.center,
    required this.right,
    super.key,
  });

  static const leftHandleKey = Key('fourPaneLayout.leftHandle');
  static const rightHandleKey = Key('fourPaneLayout.rightHandle');
  static const leftSplitHandleKey = Key('fourPaneLayout.leftSplitHandle');

  final Widget topLeft;
  final Widget bottomLeft;
  final Widget center;
  final Widget right;

  @override
  State<FourPaneLayout> createState() => _FourPaneLayoutState();
}

class _FourPaneLayoutState extends State<FourPaneLayout> {
  static const _minPaneWidth = 160.0;
  static const _maxPaneWidth = 480.0;

  double _leftWidth = 240;
  double _rightWidth = 300;

  /// Fraction of the left column height taken by the top-left pane.
  double _leftSplit = 0.5;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: _leftWidth,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final available =
                  constraints.maxHeight - _ResizeHandle.thickness;
              final topHeight = available * _leftSplit;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: topHeight, child: widget.topLeft),
                  _ResizeHandle(
                    key: FourPaneLayout.leftSplitHandleKey,
                    axis: Axis.vertical,
                    onDrag: (delta) => setState(() {
                      _leftSplit = ((topHeight + delta) / available).clamp(
                        0.15,
                        0.85,
                      );
                    }),
                  ),
                  Expanded(child: widget.bottomLeft),
                ],
              );
            },
          ),
        ),
        _ResizeHandle(
          key: FourPaneLayout.leftHandleKey,
          axis: Axis.horizontal,
          onDrag: (delta) => setState(() {
            _leftWidth = (_leftWidth + delta).clamp(
              _minPaneWidth,
              _maxPaneWidth,
            );
          }),
        ),
        Expanded(child: widget.center),
        _ResizeHandle(
          key: FourPaneLayout.rightHandleKey,
          axis: Axis.horizontal,
          onDrag: (delta) => setState(() {
            _rightWidth = (_rightWidth - delta).clamp(
              _minPaneWidth,
              _maxPaneWidth,
            );
          }),
        ),
        SizedBox(width: _rightWidth, child: widget.right),
      ],
    );
  }
}

/// Draggable pane boundary. [axis] is the drag direction: horizontal for
/// vertical boundaries (width resize), vertical for horizontal ones.
class _ResizeHandle extends StatelessWidget {
  const _ResizeHandle({required this.axis, required this.onDrag, super.key});

  static const thickness = 8.0;

  final Axis axis;
  final ValueChanged<double> onDrag;

  @override
  Widget build(BuildContext context) {
    final dividerColor = Theme.of(context).colorScheme.outlineVariant;
    final horizontal = axis == Axis.horizontal;
    return MouseRegion(
      cursor: horizontal
          ? SystemMouseCursors.resizeColumn
          : SystemMouseCursors.resizeRow,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: horizontal
            ? (details) => onDrag(details.delta.dx)
            : null,
        onVerticalDragUpdate: horizontal
            ? null
            : (details) => onDrag(details.delta.dy),
        child: SizedBox(
          width: horizontal ? thickness : null,
          height: horizontal ? null : thickness,
          child: Center(
            child: Container(
              width: horizontal ? 1 : null,
              height: horizontal ? null : 1,
              color: dividerColor,
            ),
          ),
        ),
      ),
    );
  }
}
