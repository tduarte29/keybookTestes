import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keybook/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('email') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _rememberMe = prefs.getString('email') != null;
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await AuthService.login(_emailController.text, _passwordController.text);

      if (_rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', _emailController.text);
        await prefs.setString('password', _passwordController.text);
      }

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_getErrorMessage(e))));
      }
    }
  }

  String _getErrorMessage(dynamic error) {
    final errorStr = error.toString();
    if (errorStr.contains('401')) return 'Email ou senha incorretos';
    if (errorStr.contains('timeout')) return 'Tempo de conexão esgotado';
    if (errorStr.contains('Network is unreachable'))
      return 'Sem conexão com a internet';
    return 'Erro ao fazer login';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1D1D),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 48),
                  Image.asset('assets/logokeybook.png', height: 120),
                  const SizedBox(height: 48),
                  Text(
                    'Faça o seu Login!',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    validator:
                        (value) => value!.isEmpty ? 'Digite seu email' : null,
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Senha',
                    obscureText: true,
                    validator:
                        (value) => value!.isEmpty ? 'Digite sua senha' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged:
                            (value) =>
                                setState(() => _rememberMe = value ?? false),
                        activeColor: Colors.blue,
                      ),
                      Text(
                        'Lembrar-me',
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _buildLoginButton(),
                  const SizedBox(height: 12),
                  _buildSkipButton(),
                  const SizedBox(height: 18),
                  _buildRegisterLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: GoogleFonts.inter(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(color: Colors.grey),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          'Login',
          style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          'Pular login',
          style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Não tem uma conta? ',
          style: GoogleFonts.inter(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/register'),
          child: Text(
            'Registre-se',
            style: GoogleFonts.inter(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
