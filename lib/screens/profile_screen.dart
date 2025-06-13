import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF232323),
        title: Text('Sair da conta?', style: GoogleFonts.inter(color: Colors.white)),
        content: Text(
          'Tem certeza que deseja sair?',
          style: GoogleFonts.inter(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: GoogleFonts.inter(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text('Sair', style: GoogleFonts.inter(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF181818),
        body: Column(
          children: [
            const SizedBox(height: 32),
            // Avatar sem botão +
            Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  color: Color(0xFF232323),
                  shape: BoxShape.circle,
                ),
                // Ícone de usuário simples
                child: const Center(
                  child: Icon(Icons.person, color: Colors.white38, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Username
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
            // Opções
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.white),
                    title: Text('Conta', style: GoogleFonts.inter(color: Colors.white)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileDetailsScreen()),
                      );
                    },
                  ),
                  Divider(color: Colors.white24, height: 1),
                  ListTile(
                    leading: const Icon(Icons.security, color: Colors.white),
                    title: Text('Privacidade', style: GoogleFonts.inter(color: Colors.white)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                    onTap: () {},
                  ),
                  Divider(color: Colors.white24, height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text('Log out', style: GoogleFonts.inter(color: Colors.red)),
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

  final TextEditingController usernameController = TextEditingController(text: 'Username');
  final TextEditingController emailController = TextEditingController(text: 'email@exemplo.com');
  final TextEditingController passwordController = TextEditingController(text: '********');

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
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF232323),
        title: Text('Deletar Conta?', style: GoogleFonts.inter(color: Colors.red)),
        content: Text(
          'Tem certeza que deseja deletar sua conta? Esta ação não pode ser desfeita.',
          style: GoogleFonts.inter(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: GoogleFonts.inter(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implementar deleção real da conta
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text('Deletar', style: GoogleFonts.inter(color: Colors.white)),
          ),
        ],
      ),
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
                    content: Text('Alterações salvas!', style: GoogleFonts.inter()),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(
                'Salvar',
                style: GoogleFonts.inter(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          children: [
            // Avatar com botão +
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
                    child: const Center(
                      child: Icon(Icons.person, color: Colors.white38, size: 50),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Implementar troca de foto
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
          child: isEditing
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
                        style: GoogleFonts.inter(color: Colors.white54, fontSize: 13),
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





