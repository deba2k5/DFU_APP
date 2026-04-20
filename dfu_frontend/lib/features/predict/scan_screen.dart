import 'package:flutter/material.dart';
import '../../widgets/glass_widgets.dart';
import '../../core/theme.dart';
import 'dart:ui';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isProcessing = false;

  void _simulateScan() {
    setState(() => _isProcessing = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isProcessing = false);
        // Navigate to results or show success
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Simulated Camera Viewfinder
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: const Center(
              child: Icon(Icons.camera_alt, color: Colors.white24, size: 100),
            ),
          ),
          
          // Camera Overlay with Glass effect
          _buildViewfinderOverlay(),

          // UI Elements
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTopBar(context),
                _buildBottomControls(),
              ],
            ),
          ),

          // Processing Modal
          if (_isProcessing) _buildProcessingOverlay(),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const GlassCard(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            borderRadius: 12,
            child: Text(
              'ALIGN FOOT IN FRAME',
              style: TextStyle(color: AppTheme.primaryCyan, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.flash_off, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildViewfinderOverlay() {
    return Center(
      child: Container(
        width: 280,
        height: 450,
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primaryCyan.withOpacity(0.5), width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            // Corners
            _ViewfinderCorner(top: 0, left: 0, rotation: 0),
            _ViewfinderCorner(top: 0, right: 0, rotation: 1.57),
            _ViewfinderCorner(bottom: 0, left: 0, rotation: -1.57),
            _ViewfinderCorner(bottom: 0, right: 0, rotation: 3.14),
            
            // Scanning Line Animation (Placeholder)
            if (_isProcessing)
              _buildScanningLine(),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningLine() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: AppTheme.primaryCyan, blurRadius: 20, spreadRadius: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const _ControlCircle(icon: Icons.photo_library_outlined),
          GestureDetector(
            onTap: _simulateScan,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const _ControlCircle(icon: Icons.history),
        ],
      ),
    );
  }

  Widget _buildProcessingOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: GlassCard(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppTheme.primaryCyan),
              const SizedBox(height: 20),
              const Text('AI ANALYZING...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('Checking for Ulcer Severity', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewfinderCorner extends StatelessWidget {
  final double? top, bottom, left, right, rotation;
  const _ViewfinderCorner({this.top, this.bottom, this.left, this.right, this.rotation});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Transform.rotate(
        angle: rotation!,
        child: Container(
          width: 40, height: 40,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppTheme.primaryCyan, width: 4),
              left: BorderSide(color: AppTheme.primaryCyan, width: 4),
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlCircle extends StatelessWidget {
  final IconData icon;
  const _ControlCircle({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50, height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
