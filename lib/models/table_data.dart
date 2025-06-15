import 'package:flutter/material.dart';

class TableData {
  final String name;
  final Color color;
  final List<KeyItemData> keys;

  TableData(this.name, this.color, [List<KeyItemData>? keys])
      : keys = keys ?? [];
}

class KeyItemData {
  final String name;
  KeyItemData(this.name);
}