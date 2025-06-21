import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../service/item_service.dart';
import 'package:printing/printing.dart';
import '../service/pdf_export_service.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class KeyDetailScreen extends StatefulWidget {
  final String keyName;
  final int itemId;

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
  final _debounce = Debouncer(milliseconds: 1000);
  bool _isEditing = false;

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
                    Navigator.pop(context);

                    // Mostra feedback visual
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Deletando chave...')),
                    );

                    await ItemService().deleteItem(widget.itemId);

                    // Remove o feedback visual
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();

                    // Retorna indicando que o item foi deletado
                    if (mounted) {
                      Navigator.pop(context, true);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao deletar chave: ${e.toString()}'),
                        backgroundColor: Colors.red,
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

  // E atualize o método _buildPropertyTile:
  Widget _buildPropertyTile(
    String label,
    String? value,
    IconData icon, {
    bool isMonetary = false,
  }) {
    _controllers[label] = TextEditingController(text: value ?? '');

    return ListTile(
      leading: Icon(icon, color: Colors.white54, size: 20),
      title: Text(label, style: GoogleFonts.inter(color: Colors.white)),
      trailing: SizedBox(
        width: 180,
        child:
            isMonetary
                ? TextField(
                  controller: _controllers[label],
                  style: GoogleFonts.inter(color: Colors.white),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: '0,00',
                    hintStyle: GoogleFonts.inter(color: Colors.white38),
                    border: InputBorder.none,
                  ),
                  onChanged: (val) {
                    _handleMonetaryChange(label, val);
                  },
                )
                : TextField(
                  controller: _controllers[label],
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Não informado',
                    hintStyle: GoogleFonts.inter(color: Colors.white38),
                    border: InputBorder.none,
                  ),
                  onChanged: (val) => _handleFieldChange(label),
                ),
      ),
      dense: true,
    );
  }

  void _handleFieldChange(String label) {
    if (_isEditing) return;

    _isEditing = true;
    _debounce.run(() async {
      try {
        await _saveChanges();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label atualizado com sucesso'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      } catch (e) {
        debugPrint('Erro ao atualizar $label: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao atualizar $label'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        _isEditing = false;
      }
    });
  }

  void _handleMonetaryChange(String label, String value) {
    // Não formate automaticamente, só salve ao sair do campo
    _handleFieldChange(label);
  }

  Future<void> _saveChanges() async {
    final itemData = await _itemDetails;

    try {
      await ItemService().updateItem(
        itemId: widget.itemId,
        nome: _controllers['Nome']?.text ?? itemData['nome'],
        transponder:
            _controllers['Transponder']?.text ?? itemData['transponder'],
        tipoServico:
            _controllers['Tipo de Serviço']?.text ?? itemData['tipoServico'],
        anoVeiculo:
            _controllers['Ano do Veículo']?.text ?? itemData['anoVeiculo'],
        valorCobrado: _parseValorCobrado(
          _controllers['Valor Cobrado']?.text ??
              itemData['valorCobrado']!.toString(),
        ),
        marcaVeiculo:
            _controllers['Marca do Veículo']?.text ?? itemData['marcaVeiculo'],
        modeloVeiculo:
            _controllers['Modelo do Veículo']?.text ??
            itemData['modeloVeiculo'],
        tipoChave: _controllers['Tipo de Chave']?.text ?? itemData['tipoChave'],
        fornecedor: _controllers['Fornecedor']?.text ?? itemData['fornecedor'],
        dataConstrucao:
            _controllers['Data de Construção']?.text ??
            itemData['dataConstrucao'],
        observacoes: _obsController.text,
      );
    } catch (e) {
      debugPrint('Erro ao salvar valor: $e');
      rethrow;
    }
  }

  double? _parseValorCobrado(String value) {
    if (value.isEmpty) return null;

    // Remove caracteres não numéricos exceto vírgula e ponto
    final cleanValue = value.replaceAll(RegExp(r'[^0-9,\.]'), '');

    // Troca vírgula por ponto para o backend
    final normalized = cleanValue.replaceAll(',', '.');

    return double.tryParse(normalized);
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
          //Botão exportar página em pdf
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () async {
              final itemData = await _itemDetails;

              try {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Gerando PDF...'),
                    duration: Duration(seconds: 1),
                  ),
                );

                // Pré-processamento dos dados para garantir valores padrão
                final processedData = {
                  'Transponder': itemData['transponder'],
                  'Tipo de Serviço': itemData['tipoServico'],
                  'Valor Cobrado': itemData['valorCobrado']?.toStringAsFixed(2),
                  'Marca do Veículo': itemData['marcaVeiculo'],
                  'Modelo do Veículo': itemData['modeloVeiculo'],
                  'Ano do Veículo': itemData['anoVeiculo'],
                  'Tipo de Chave': itemData['tipoChave'],
                  'Fornecedor': itemData['fornecedor'],
                  'Data de Construção': itemData['dataConstrucao'],
                  'Observações': itemData['observacoes'],
                };

                await PdfExportService.exportKeyDetailsToPdf(
                  context: context,
                  keyName: widget.keyName,
                  keyDetails: processedData,
                );

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('PDF gerado com sucesso!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao gerar PDF: ${e.toString()}'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              }
            },
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

              // Seção de detalhes da chave
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
                      itemData['valorCobrado'] != null
                          ? itemData['valorCobrado'].toString().replaceAll(
                            '.',
                            ',',
                          )
                          : null,
                      Icons.attach_money,
                      isMonetary: true,
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
                      onChanged: (val) {
                        _debounce.run(() async {
                          await _saveChanges();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Observações atualizadas'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        });
                      },
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
