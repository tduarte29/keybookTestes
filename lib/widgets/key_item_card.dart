import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KeyItemCard extends StatelessWidget {
  final String keyName;
  final double? valorCobrado;
  final String? modeloVeiculo;
  final Color cardColor;
  final Color? accentColor;

  const KeyItemCard({
    super.key,
    required this.keyName,
    this.valorCobrado,
    this.modeloVeiculo,
    this.cardColor = const Color(0xFF0F0F0F),
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Linha do nome da chave (mantida igual)
          Row(
            children: [
              Icon(Icons.vpn_key, color: accentColor ?? Colors.white, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  keyName,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Linha do valor cobrado
          Row(
            children: [
              const Icon(Icons.attach_money, color: Colors.white54, size: 14),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  valorCobrado != null
                      ? 'R\$ ${valorCobrado!.toStringAsFixed(2)}'
                      : 'Valor não informado',
                  style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Linha do modelo do veículo
          Row(
            children: [
              const Icon(Icons.directions_car, color: Colors.white54, size: 14),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  modeloVeiculo ?? 'Modelo não informado',
                  style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
