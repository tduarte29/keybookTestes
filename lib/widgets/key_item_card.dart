import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KeyItemCard extends StatelessWidget {
  final String keyName;
  final Color cardColor;
  final Color? accentColor;

  const KeyItemCard({
    super.key,
    required this.keyName,
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
          Row(
            children: [
              const Icon(Icons.settings, color: Colors.white54, size: 14),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Trans...',
                  style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'vazio',
                  style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.category, color: Colors.white54, size: 14),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Tipo d',
                  style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'vazio',
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