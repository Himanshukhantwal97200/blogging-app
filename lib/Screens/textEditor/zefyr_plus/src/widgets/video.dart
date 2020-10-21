import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:notus_plus/notus.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import '../../zefyr.dart';
import 'editable_box.dart';

abstract class ZefyrVideoDelegate {
  Widget buildVideo(BuildContext context);
  void dispose();
  void initState(String videoUrl, VoidCallback setState);
}

class ZefyrVideo extends StatefulWidget {
  const ZefyrVideo({Key key, @required this.node, @required this.delegate})
      : super(key: key);

  final EmbedNode node;
  final ZefyrVideoDelegate delegate;

  @override
  _ZefyrVideoState createState() => _ZefyrVideoState();
}

class _ZefyrVideoState extends State<ZefyrVideo> {
  Widget video;

  String get videoSource {
    EmbedAttribute attribute = widget.node.style.get(NotusAttribute.embed);
    return attribute.value['source'] as String;
  }

  @override
  void initState() {
    super.initState();
    widget.delegate.initState(videoSource, () {
      setState(() {});
    });
    video = widget.delegate.buildVideo(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ZefyrTheme.of(context);
    return _EditableVideo(
      node: widget.node,
      child: Padding(
        padding: theme.defaultLineTheme.padding,
        child: video ?? SizedBox.shrink(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.delegate?.dispose();
  }
}

class _EditableVideo extends SingleChildRenderObjectWidget {
  _EditableVideo({@required Widget child, @required this.node})
      : assert(node != null),
        super(child: child);

  final EmbedNode node;

  @override
  RenderEditableVideo createRenderObject(BuildContext context) {
    return RenderEditableVideo(node: node);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderEditableVideo renderObject) {
    renderObject..node = node;
  }
}

class RenderEditableVideo extends RenderBox
    with RenderObjectWithChildMixin<RenderBox>, RenderProxyBoxMixin<RenderBox>
    implements RenderEditableBox {
  RenderEditableVideo({
    RenderImage child,
    @required EmbedNode node,
  }) : node = node {
    this.child = child;
  }

  @override
  EmbedNode node;

  // TODO: Customize caret height offset instead of adjusting here by 2px.
  @override
  double get preferredLineHeight => size.height + 2.0;

  @override
  SelectionOrder get selectionOrder => SelectionOrder.foreground;

  @override
  TextSelection getLocalSelection(TextSelection documentSelection) {
    if (!intersectsWithSelection(documentSelection)) return null;

    var nodeBase = node.documentOffset;
    int nodeExtent = nodeBase + node.length;
    int base = math.max(0, documentSelection.baseOffset - nodeBase);
    int extent =
        math.min(documentSelection.extentOffset, nodeExtent) - nodeBase;
    return documentSelection.copyWith(baseOffset: base, extentOffset: extent);
  }

  @override
  List<ui.TextBox> getEndpointsForSelection(TextSelection selection) {
    TextSelection local = getLocalSelection(selection);
    if (local.isCollapsed) {
      final dx = local.extentOffset == 0 ? _childOffset.dx : size.width;
      return [
        ui.TextBox.fromLTRBD(dx, 0.0, dx, size.height, TextDirection.ltr),
      ];
    }

    final rect = _childRect;
    return [
      ui.TextBox.fromLTRBD(
          rect.left, rect.top, rect.left, rect.bottom, TextDirection.ltr),
      ui.TextBox.fromLTRBD(
          rect.right, rect.top, rect.right, rect.bottom, TextDirection.ltr),
    ];
  }

  @override
  TextPosition getPositionForOffset(Offset offset) {
    int position = node.documentOffset;

    if (offset.dx > size.width / 2) {
      position++;
    }
    return TextPosition(offset: position);
  }

  @override
  TextRange getWordBoundary(TextPosition position) {
    final start = node.documentOffset;
    return TextRange(start: start, end: start + 1);
  }

  @override
  bool intersectsWithSelection(TextSelection selection) {
    final int base = node.documentOffset;
    final int extent = base + node.length;
    return base <= selection.extentOffset && selection.baseOffset <= extent;
  }

  @override
  Offset getOffsetForCaret(TextPosition position, Rect caretPrototype) {
    final pos = position.offset - node.documentOffset;
    Offset caretOffset = _childOffset - Offset(kHorizontalPadding, 0.0);
    if (pos == 1) {
      caretOffset =
          caretOffset + Offset(_lastChildSize.width + kHorizontalPadding, 0.0);
    }
    return caretOffset;
  }

  @override
  void paintSelection(PaintingContext context, Offset offset,
      TextSelection selection, Color selectionColor) {
    final localSelection = getLocalSelection(selection);
    assert(localSelection != null);
    if (!localSelection.isCollapsed) {
      final Paint paint = Paint()
        ..color = selectionColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;
      final rect =
          Rect.fromLTWH(0.0, 0.0, _lastChildSize.width, _lastChildSize.height);
      context.canvas.drawRect(rect.shift(offset + _childOffset), paint);
    }
  }

  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset + _childOffset);
  }

  static const double kHorizontalPadding = 1.0;

  Size _lastChildSize;

  Offset get _childOffset {
    final dx = (size.width - _lastChildSize.width) / 2 + kHorizontalPadding;
    final dy = (size.height - _lastChildSize.height) / 2;
    return Offset(dx, dy);
  }

  Rect get _childRect {
    return Rect.fromLTWH(_childOffset.dx, _childOffset.dy, _lastChildSize.width,
        _lastChildSize.height);
  }

  @override
  void performLayout() {
    assert(constraints.hasBoundedWidth);
    if (child != null) {
      // Make constraints use 16:9 aspect ratio.
      final width = constraints.maxWidth - kHorizontalPadding * 2;
      final childConstraints = constraints.copyWith(
        minWidth: 0.0,
        maxWidth: width,
        minHeight: 0.0,
        maxHeight: (width * 9 / 16).floorToDouble(),
      );
      child.layout(childConstraints, parentUsesSize: true);
      _lastChildSize = child.size;
      size = Size(constraints.maxWidth, _lastChildSize.height);
    } else {
      performResize();
    }
  }
}
