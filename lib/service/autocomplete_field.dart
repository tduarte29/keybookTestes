// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import '../service/item_service.dart';
//
// class AutoCompleteField extends StatelessWidget {
//   final String label;
//   final String? value;
//   final IconData icon;
//   final TextEditingController controller;
//   final Function(String) onChanged;
//   final Future<List<String>> Function(String) suggestionsCallback;
//
//   const AutoCompleteField({
//     super.key,
//     required this.label,
//     required this.value,
//     required this.icon,
//     required this.controller,
//     required this.onChanged,
//     required this.suggestionsCallback,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.white54, size: 20),
//       title: Text(label, style: GoogleFonts.inter(color: Colors.white)),
//       trailing: SizedBox(
//         width: 180,
//         child: TypeAheadField<String>(
//           controller: controller,
//           // Moved outside textFieldConfiguration
//           builder: (context, controller, focusNode) {
//             return TextField(
//               controller: controller,
//               focusNode: focusNode,
//               style: GoogleFonts.inter(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: 'Não informado',
//                 hintStyle: GoogleFonts.inter(color: Colors.white38),
//                 border: InputBorder.none,
//               ),
//               onChanged: onChanged,
//             );
//           },
//           suggestionsCallback: suggestionsCallback,
//           itemBuilder: (context, suggestion) {
//             return ListTile(
//               title: Text(
//                 suggestion,
//                 style: GoogleFonts.inter(color: Colors.white),
//               ),
//             );
//           },
//           onSelected: (suggestion) {
//             // Changed from onSuggestionSelected
//             controller.text = suggestion;
//             onChanged(suggestion);
//           },
//           noItemsFoundBuilder:
//               (context) => Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   'Nenhum item encontrado',
//                   style: GoogleFonts.inter(color: Colors.white54),
//                 ),
//               ),
//         ),
//       ),
//       dense: true,
//     );
//   }
// }
