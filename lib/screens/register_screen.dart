import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1D1D),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 48),
                Image.asset(
                  'assets/logokeybook.png',
                  height: 120,
                ),
                const SizedBox(height: 48),
                Text(
                  'Registre-se agora!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 28),
                _RegisterTextField(
                  hintText: 'email ou username',
                  obscureText: false,
                ),
                const SizedBox(height: 18),
                _RegisterTextField(
                  hintText: 'password',
                  obscureText: true,
                ),
                const SizedBox(height: 18),
                _RegisterTextField(
                  hintText: 'confirm password',
                  obscureText: true,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        'Register',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já possui uma conta? ',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'clique aqui.',
                        style: GoogleFonts.inter(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final response = await http.post(
                        Uri.parse('http://127.0.0.1:8080/auth/register'),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({
                          'nome': 'TesteFlutter',
                          'email': 'flutter@teste.com',
                          'password': '123456'
                        }),
                      );
                      print('Status: ${response.statusCode}');
                      print('Corpo: ${response.body}');
                    } catch (e) {
                      print('Erro: $e');
                    }
                  },
                  child: Text('Testar Conexão'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Campo de texto customizado para registro, underline sutil e sem fundo
class _RegisterTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;

  const _RegisterTextField({
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      style: GoogleFonts.inter(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(color: Colors.grey),
        filled: false,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.2),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.2),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      ),
    );
  }
}