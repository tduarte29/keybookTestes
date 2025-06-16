import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../service/item_service.dart';

class KeyDetailScreen extends StatefulWidget {
  final String keyName;
  final int itemId; // Adicionamos o ID do item para buscar os detalhes

  const KeyDetailScreen({
    super.key,
    required this.keyName,
    required this.itemId,
  });

  @override
  State<KeyDetailScreen> createState() => _KeyDetailScreenState();
}

class _KeyDetailScreenState extends State<KeyDetailScreen> {
  XFile? _image;
  final picker = ImagePicker();
  late Future<Map<String, dynamic>> _itemDetails;
  final TextEditingController _obsController = TextEditingController();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _itemDetails = ItemService().getItemDetails(widget.itemId);
  }

  @override
  void dispose() {
    _obsController.dispose();
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF232323),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: Text(
                  'Tirar Foto',
                  style: GoogleFonts.inter(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    setState(() => _image = pickedFile);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: Text(
                  'Abrir Galeria',
                  style: GoogleFonts.inter(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    setState(() => _image = pickedFile);
                  }
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
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF232323),
            title: Text(
              'Deletar Chave',
              style: GoogleFonts.inter(color: Colors.red),
            ),
            content: Text(
              'Tem certeza que deseja deletar esta chave?',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.inter(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  try {
                    await ItemService().deleteItem(widget.itemId);
                    Navigator.pop(context);
                    Navigator.pop(
                      context,
                      true,
                    ); // Retorna indicando que o item foi deletado
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao deletar chave: ${e.toString()}'),
                      ),
                    );
                  }
                },
                child: Text(
                  'Deletar',
                  style: GoogleFonts.inter(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildPropertyTile(String label, String? value, IconData icon) {
    _controllers[label] = TextEditingController(text: value ?? '');

    return ListTile(
      leading: Icon(icon, color: Colors.white54, size: 20),
      title: Text(label, style: GoogleFonts.inter(color: Colors.white)),
      trailing: SizedBox(
        width: 180,
        child: TextField(
          controller: _controllers[label],
          style: GoogleFonts.inter(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Não informado',
            hintStyle: GoogleFonts.inter(color: Colors.white38),
            border: InputBorder.none,
          ),
          onChanged: (val) {
            // Aqui você pode implementar a atualização no backend
          },
        ),
      ),
      dense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.keyName,
          style: GoogleFonts.inter(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF232323),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: () async {
              // Implementar lógica para salvar todas as alterações
              try {
                // Criar objeto com os dados atualizados
                final updatedData = {
                  'nome': _controllers['Nome']?.text ?? widget.keyName,
                  'transponder': _controllers['Transponder']?.text,
                  'tipoServico': _controllers['Tipo de Serviço']?.text,
                  // Adicione todos os outros campos aqui
                  'observacoes': _obsController.text,
                };

                // Chamar o serviço para atualizar
                await ItemService().updateItem(
                  itemId: widget.itemId,
                  nome: _controllers['Nome']?.text ?? widget.keyName,
                  transponder: _controllers['Transponder']?.text,
                  tipoServico: _controllers['Tipo de Serviço']?.text,
                  // Passe todos os outros campos aqui
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chave atualizada com sucesso!'),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao atualizar chave: ${e.toString()}'),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _showDeleteDialog,
          ),
        ],
      ),
      backgroundColor: const Color(0xFF1D1D1D),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _itemDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar detalhes: ${snapshot.error}'),
            );
          }

          final itemData = snapshot.data!;

          return ListView(
            children: [
              // Seção de imagem
              GestureDetector(
                onTap: _showImagePickerOptions,
                child: Container(
                  height: 200,
                  color: const Color(0xFF181818),
                  child:
                      _image == null
                          ? Center(
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.white38,
                              size: 48,
                            ),
                          )
                          : Image.file(File(_image!.path), fit: BoxFit.cover),
                ),
              ),

              // Seção de propriedades
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detalhes da Chave',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    _buildPropertyTile('Nome', itemData['nome'], Icons.vpn_key),
                    _buildPropertyTile(
                      'Transponder',
                      itemData['transponder'],
                      Icons.memory,
                    ),
                    _buildPropertyTile(
                      'Tipo de Serviço',
                      itemData['tipoServico'],
                      Icons.build,
                    ),
                    _buildPropertyTile(
                      'Valor Cobrado',
                      itemData['valorCobrado']?.toString(),
                      Icons.attach_money,
                    ),
                    _buildPropertyTile(
                      'Marca do Veículo',
                      itemData['marcaVeiculo'],
                      Icons.directions_car,
                    ),
                    _buildPropertyTile(
                      'Modelo do Veículo',
                      itemData['modeloVeiculo'],
                      Icons.directions_car,
                    ),
                    _buildPropertyTile(
                      'Ano do Veículo',
                      itemData['anoVeiculo'],
                      Icons.calendar_today,
                    ),
                    _buildPropertyTile(
                      'Tipo de Chave',
                      itemData['tipoChave'],
                      Icons.vpn_key,
                    ),
                    _buildPropertyTile(
                      'Fornecedor',
                      itemData['fornecedor'],
                      Icons.store,
                    ),
                    _buildPropertyTile(
                      'Data de Construção',
                      itemData['dataConstrucao'],
                      Icons.date_range,
                    ),

                    // Campo de observações
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Observações',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextField(
                      controller:
                          _obsController..text = itemData['observacoes'] ?? '',
                      maxLines: 4,
                      style: GoogleFonts.inter(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Adicione observações aqui...',
                        fillColor: const Color(0xFF232323),
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
