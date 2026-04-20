import 'package:flutter/material.dart';
import '../../widgets/glass_widgets.dart';
import '../../core/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient (Matching Splash)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Color(0xFF0B0E14), Color(0xFF1E293B)],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your details to access the clinical portal',
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                  ),
                  const Spacer(),
                  GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number / Email',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: GlassButton(
                            text: 'SEND OTP',
                            onPressed: () {
                              // OTP Logic
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Expanded(child: Divider(color: Colors.white24)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('OR', style: TextStyle(color: Colors.white.withOpacity(0.5))),
                            ),
                            const Expanded(child: Divider(color: Colors.white24)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSocialButton('Continue with Google', Icons.g_mobiledata),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppTheme.primaryCyan),
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, IconData icon) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: const TextStyle(color: Colors.white)),
        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }
}
