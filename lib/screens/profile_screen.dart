import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../service/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF232323),
            title: Text(
              'Sair da conta?',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            content: Text(
              'Tem certeza que deseja sair?',
              style: GoogleFonts.inter(color: Colors.white70),
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
                  Navigator.pop(context);
                  await _performLogout(context);
                },
                child: Text(
                  'Sair',
                  style: GoogleFonts.inter(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    final scaffold = ScaffoldMessenger.of(context);

    try {
      scaffold.showSnackBar(
        const SnackBar(content: Text('Encerrando sessão...')),
      );

      await AuthService.logout();

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      if (!mounted) return;
      scaffold.hideCurrentSnackBar();
      scaffold.showSnackBar(
        SnackBar(
          content: Text('Erro ao sair: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF181818),
        body: Column(
          children: [
            const SizedBox(height: 32),
            Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  color: Color(0xFF232323),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.person, color: Colors.white38, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Username',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.white),
                    title: Text(
                      'Conta',
                      style: GoogleFonts.inter(color: Colors.white),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.white54,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileDetailsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(color: Colors.white24, height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      'Log out',
                      style: GoogleFonts.inter(color: Colors.red),
                    ),
                    onTap: () => _showLogoutDialog(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// O resto do seu código (ProfileDetailsScreen e _EditableField) permanece igual

// NOVA TELA: Detalhes do Perfil
class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  bool isEditingUsername = false;
  bool isEditingEmail = false;
  bool isEditingPassword = false;

  final TextEditingController usernameController = TextEditingController(
    text: 'Username',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'email@exemplo.com',
  );
  final TextEditingController passwordController = TextEditingController(
    text: '********',
  );

  XFile? _image;
  final picker = ImagePicker();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF232323),
            title: Text(
              'Deletar Conta?',
              style: GoogleFonts.inter(color: Colors.red),
            ),
            content: Text(
              'Tem certeza que deseja deletar sua conta? Esta ação não pode ser desfeita.',
              style: GoogleFonts.inter(color: Colors.white70),
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
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implementar deleção real da conta
                  Navigator.pushReplacementNamed(context, '/login');
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

  void _showImagePickerOptions() async {
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
                    setState(() {
                      _image = pickedFile;
                    });
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
                    setState(() {
                      _image = pickedFile;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF181818),
        appBar: AppBar(
          backgroundColor: const Color(0xFF181818),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            TextButton(
              onPressed: () {
                // TODO: Salvar alterações no backend
                setState(() {
                  isEditingUsername = false;
                  isEditingEmail = false;
                  isEditingPassword = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Alterações salvas!',
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(
                'Salvar',
                style: GoogleFonts.inter(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          children: [
            // Avatar com botão + (menor) e imagem
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: const BoxDecoration(
                      color: Color(0xFF232323),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child:
                          _image == null
                              ? const Center(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white38,
                                  size: 50,
                                ),
                              )
                              : Image.file(
                                File(_image!.path),
                                fit: BoxFit.cover,
                                width: 110,
                                height: 110,
                              ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: _showImagePickerOptions,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.all(3), // menor
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 25,
                        ), // menor
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Username
            _EditableField(
              label: 'Username',
              controller: usernameController,
              isEditing: isEditingUsername,
              onEdit: () => setState(() => isEditingUsername = true),
              onChanged: (val) {},
              onDone: () => setState(() => isEditingUsername = false),
            ),
            const SizedBox(height: 18),
            // Email
            _EditableField(
              label: 'Email',
              controller: emailController,
              isEditing: isEditingEmail,
              onEdit: () => setState(() => isEditingEmail = true),
              onChanged: (val) {},
              onDone: () => setState(() => isEditingEmail = false),
            ),
            const SizedBox(height: 18),
            // Senha
            _EditableField(
              label: 'Senha',
              controller: passwordController,
              isEditing: isEditingPassword,
              obscureText: true,
              onEdit: () => setState(() => isEditingPassword = true),
              onChanged: (val) {},
              onDone: () => setState(() => isEditingPassword = false),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _showDeleteAccountDialog,
                child: Text(
                  'Deletar Conta',
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget auxiliar para campos editáveis
class _EditableField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEditing;
  final bool obscureText;
  final VoidCallback onEdit;
  final ValueChanged<String> onChanged;
  final VoidCallback onDone;

  const _EditableField({
    required this.label,
    required this.controller,
    required this.isEditing,
    required this.onEdit,
    required this.onChanged,
    required this.onDone,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child:
              isEditing
                  ? TextField(
                    controller: controller,
                    obscureText: obscureText,
                    style: GoogleFonts.inter(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: label,
                      labelStyle: GoogleFonts.inter(color: Colors.white70),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    ),
                    onChanged: onChanged,
                    onEditingComplete: onDone,
                    autofocus: true,
                  )
                  : GestureDetector(
                    onTap: onEdit,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: GoogleFonts.inter(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          obscureText ? '********' : controller.text,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(color: Colors.white24, height: 1),
                      ],
                    ),
                  ),
        ),
        if (!isEditing)
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white54, size: 20),
            onPressed: onEdit,
          ),
      ],
    );
  }
}
