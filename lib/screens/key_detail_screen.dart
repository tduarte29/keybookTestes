import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// MODELOS AUXILIARES
class _PropertyField {
  final String label;
  final IconData icon;
  _PropertyField(this.label, this.icon);
}

// WIDGETS AUXILIARES
class _PropertyTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const _PropertyTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white54, size: 20),
      title: Text(label, style: GoogleFonts.inter(color: Colors.white)),
      trailing: SizedBox(
        width: 120,
        child: TextField(
          style: GoogleFonts.inter(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'vazio',
            hintStyle: GoogleFonts.inter(color: Colors.white38),
            border: InputBorder.none,
          ),
          onChanged: onChanged,
        ),
      ),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    );
  }
}

// TELA PRINCIPAL
class KeyDetailScreen extends StatefulWidget {
  final String keyName;
  const KeyDetailScreen({super.key, required this.keyName});

  @override
  State<KeyDetailScreen> createState() => _KeyDetailScreenState();
}

class _KeyDetailScreenState extends State<KeyDetailScreen> {
  XFile? _image;
  final picker = ImagePicker();

  // Propriedades fixas
  final List<_PropertyField> _properties = [
    _PropertyField('Transponder', Icons.memory),
    _PropertyField('Tipo de Serviço', Icons.build),
    _PropertyField('Ano do Veículo', Icons.calendar_today),
    _PropertyField('Valor Cobrado', Icons.attach_money),
    _PropertyField('Marca do Veículo', Icons.directions_car),
    _PropertyField('Modelo do Veículo', Icons.directions_car_filled),
    _PropertyField('Tipo de Chave', Icons.vpn_key),
    _PropertyField('Maquina', Icons.precision_manufacturing),
    _PropertyField('Fornecedor', Icons.store),
    _PropertyField('Data de Construção', Icons.date_range),
    _PropertyField('Observações', Icons.notes),
    _PropertyField('Corte Mecânico', Icons.cut),
    _PropertyField('Sistema do Imobilizador', Icons.security),
  ];

  final Map<String, String> _propertyValues = {};
  final TextEditingController _obsController = TextEditingController();

  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF232323),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: Text('Tirar Foto', style: GoogleFonts.inter(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _image = pickedFile;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: Text('Abrir Galeria', style: GoogleFonts.inter(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _image = pickedFile;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file, color: Colors.white),
                title: Text('Importar Documento', style: GoogleFonts.inter(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implementar importação de documento se necessário
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF232323),
        title: Text('Deletar Chave', style: GoogleFonts.inter(color: Colors.red)),
        content: Text(
          'Tem certeza que deseja deletar esta chave?',
          style: GoogleFonts.inter(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: GoogleFonts.inter(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              // TODO: Remover chave do backend aqui se necessário
              Navigator.pop(context);
              Navigator.pop(context); // Volta para a tela anterior após deletar
            },
            child: Text('Deletar Chave', style: GoogleFonts.inter(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _obsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white), // <-- Adicione esta linha
        titleTextStyle: const TextStyle(
          color: Colors.white,
        ),
        title: Text(
          widget.keyName,
          style: GoogleFonts.inter(),
        ),
        backgroundColor: const Color(0xFF232323),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: 'Deletar chave',
            onPressed: _showDeleteDialog,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: const Color(0xFF1D1D1D),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          // Imagem no topo com botão central de adicionar
          GestureDetector(
            onTap: _showImagePickerOptions,
            child: Container(
              height: 180,
              color: const Color(0xFF181818),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _image == null
                        ? Center(
                            child: Icon(Icons.add, color: Colors.white38, size: 48),
                          )
                        : Image.file(
                            File(_image!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Propriedades',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Lista de propriedades
          ..._properties.map((prop) => _PropertyTile(
                icon: prop.icon,
                label: prop.label,
                value: _propertyValues[prop.label] ?? 'vazio',
                onChanged: (val) {
                  setState(() {
                    _propertyValues[prop.label] = val;
                  });
                },
              )),
          // Campo de observação grande
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informações adicionais',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _obsController,
                  maxLines: 5,
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Digite aqui informações adicionais',
                    hintStyle: GoogleFonts.inter(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF232323),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  onChanged: (val) {
                    // TODO: Salvar observação no backend se necessário
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}