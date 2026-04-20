import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/auth_provider.dart';
import '../../core/theme.dart';
import '../../widgets/glass_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final roleName = auth.role.toString().split('.').last.toUpperCase();
    final email = auth.user?.email ?? 'user@example.com';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark slate matching background
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0F172A), Color(0xFF0B0E14)],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text('PROFILE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  const SizedBox(height: 40),
                  
                  // Avatar
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryCyan.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primaryCyan, width: 2),
                    ),
                    child: const Icon(Icons.person, size: 50, color: AppTheme.primaryCyan),
                  ),
                  const SizedBox(height: 20),
                  
                  // Info
                  Text(email, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      roleName,
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12, letterSpacing: 1),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Action Items
                  _buildProfileCard(Icons.settings, 'Account Settings', 'Manage password and details'),
                  const SizedBox(height: 15),
                  _buildProfileCard(Icons.notifications_active, 'Notifications', 'Alerts and emails'),
                  const SizedBox(height: 15),
                  _buildProfileCard(Icons.privacy_tip, 'Privacy Policy', 'Data compliance & HIPAA'),
                  
                  const SizedBox(height: 40),
                  
                  // Logout Button
                  GlassButton(
                    text: 'LOG OUT',
                    onPressed: () {
                      auth.signOut();
                      Navigator.of(context, rootNavigator: true).pushReplacementNamed('/login');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(IconData icon, String title, String subtitle) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primaryCyan),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.3), size: 16),
        ],
      ),
    );
  }
}
