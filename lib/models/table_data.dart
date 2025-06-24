import 'package:flutter/material.dart';

class TableData {
  final String name;
  final Color color;
  final List<KeyItemData> keys;
  final int? id;
  final DateTime? dataCriacao;

  TableData(
    this.name,
    this.color, {
    this.keys = const [],
    this.id,
    this.dataCriacao,
  });

  // Adicione um método para atualizar chaves
  TableData copyWith({List<KeyItemData>? keys}) {
    return TableData(name, color, keys: keys ?? this.keys, id: id);
  }
}

class KeyItemData {
  final String name;
  final int? id;
  final double? valorCobrado;
  final String? modeloVeiculo;

  KeyItemData(this.name, {this.id, this.valorCobrado, this.modeloVeiculo});
}
