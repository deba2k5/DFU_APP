import 'package:flutter/material.dart';
import '../../widgets/glass_widgets.dart';
import '../../core/theme.dart';

class ResultScreen extends StatelessWidget {
  final int stage; // 0-3
  final double confidence;

  const ResultScreen({
    super.key,
    this.stage = 2,
    this.confidence = 0.89,
  });

  @override
  Widget build(BuildContext context) {
    final severityColor = _getSeverityColor(stage);
    final stageText = _getStageText(stage);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF0F172A), Color(0xFF0B0E14)],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(context),
                  const SizedBox(height: 30),
                  _buildImagePreview(),
                  const SizedBox(height: 30),
                  _buildResultsCard(severityColor, stageText, context),
                  const SizedBox(height: 20),
                  _buildRecommendationCard(stage),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: GlassButton(
                          text: 'SAVE REPORT',
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildSecondaryButton('SHARE'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        const Text(
          'AI ANALYSIS RESULT',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        const Icon(Icons.more_vert, color: Colors.white),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white10),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1576091160550-217359f49f4c?auto=format&fit=crop&q=80&w=400'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black45,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24),
          ),
          child: const Icon(Icons.zoom_in, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildResultsCard(Color severityColor, String stageText, BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ULCER SEVERITY',
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stageText,
                    style: TextStyle(color: severityColor, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.analytics_outlined, color: severityColor, size: 30),
              ),
            ],
          ),
          const Divider(height: 40, color: Colors.white10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric('Confidence', '${(confidence * 100).toInt()}%'),
              _buildMetric('Model', 'DenseNet-121'),
              _buildMetric('Grade', 'Wagner $stage'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)),
      ],
    );
  }

  Widget _buildRecommendationCard(int stage) {
    return GlassCard(
      opacity: 0.1,
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppTheme.primaryCyan),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              _getRecommendation(stage),
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: TextButton(
        onPressed: () {},
        child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Color _getSeverityColor(int stage) {
    switch (stage) {
      case 0: return AppTheme.mintGreen;
      case 1: return Colors.yellowAccent;
      case 2: return Colors.orangeAccent;
      case 3: return Colors.redAccent;
      default: return Colors.blueAccent;
    }
  }

  String _getStageText(int stage) {
    switch (stage) {
      case 0: return 'NORMAL / STAGE 0';
      case 1: return 'MILD / STAGE 1';
      case 2: return 'MODERATE / STAGE 2';
      case 3: return 'CRITICAL / STAGE 3';
      default: return 'UNKNOWN';
    }
  }

  String _getRecommendation(int stage) {
    if (stage >= 2) return 'URGENT: Recommended immediate clinical inspection and debridement.';
    return 'Observation required. Schedule follow-up scan in 48 hours.';
  }
}
