// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:notus_plus/notus.dart';

import 'common.dart';
import 'theme.dart';

/// Represents regular paragraph line in a Zefyr editor.
class ZefyrParagraph extends StatelessWidget {
  ZefyrParagraph({Key key, @required this.node, this.blockStyle})
      : super(key: key);

  final LineNode node;
  final TextStyle blockStyle;

  @override
  Widget build(BuildContext context) {
    final theme = ZefyrTheme.of(context);
    var style = theme.defaultLineTheme.textStyle;
    if (blockStyle != null) {
      style = style.merge(blockStyle);
    }
    return ZefyrLine(
      node: node,
      style: style,
      padding: theme.defaultLineTheme.padding,
    );
  }
}

/// Represents heading-styled line in [ZefyrEditor].
class ZefyrHeading extends StatelessWidget {
  ZefyrHeading({Key key, @required this.node, this.blockStyle})
      : assert(node.style.contains(NotusAttribute.heading)),
        super(key: key);

  final LineNode node;
  final TextStyle blockStyle;

  @override
  Widget build(BuildContext context) {
    final theme = themeOf(node, context);
    TextStyle style = theme.textStyle;
    if (blockStyle != null) {
      style = style.merge(blockStyle);
    }
    return ZefyrLine(
      node: node,
      style: style,
      padding: theme.padding,
    );
  }

  static LineTheme themeOf(LineNode node, BuildContext context) {
    final theme = ZefyrTheme.of(context);
    final style = node.style.get(NotusAttribute.heading);
    if (style == NotusAttribute.heading.level1) {
      return theme.attributeTheme.heading1;
    } else if (style == NotusAttribute.heading.level2) {
      return theme.attributeTheme.heading2;
    } else if (style == NotusAttribute.heading.level3) {
      return theme.attributeTheme.heading3;
    }
    throw UnimplementedError('Unsupported heading style $style');
  }
}
