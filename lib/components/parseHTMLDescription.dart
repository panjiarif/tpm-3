import 'package:flutter/material.dart';

Text parseHtmlDescription(String htmlString) {
  final regex = RegExp(r'<strong>(.*?)</strong>');
  final spans = <TextSpan>[];
  int currentIndex = 0;

  for (final match in regex.allMatches(htmlString)) {
    if (match.start > currentIndex) {
      spans
          .add(TextSpan(text: htmlString.substring(currentIndex, match.start)));
    }
    spans.add(TextSpan(
      text: match.group(1),
      style: const TextStyle(fontWeight: FontWeight.bold),
    ));
    currentIndex = match.end;
  }

  if (currentIndex < htmlString.length) {
    spans.add(TextSpan(text: htmlString.substring(currentIndex)));
  }

  return Text.rich(
    TextSpan(children: spans),
    maxLines: 3,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(),
  );
}
