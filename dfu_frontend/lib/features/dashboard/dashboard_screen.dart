import 'package:flutter/material.dart';
import '../../widgets/glass_widgets.dart';
import '../../core/theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          CustomScrollView(
            slivers: [
              _buildHeader(context),
              _buildStatsGrid(context),
              _buildRecentScans(context),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning,',
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
                ),
                Text(
                  'Dr. Henderson',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=doc'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        delegate: SliverChildListDelegate([
          _buildStatCard('Active Cases', '24', Icons.people_outline, AppTheme.primaryCyan),
          _buildStatCard('Critical', '03', Icons.warning_amber_rounded, Colors.redAccent),
          _buildStatCard('Scans/Today', '12', Icons.camera_alt_outlined, AppTheme.mintGreen),
          _buildStatCard('Pending', '08', Icons.hourglass_empty, Colors.orangeAccent),
        ]),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              Text(title, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentScans(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Summaries', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: AppTheme.primaryCyan))),
              ],
            ),
            const SizedBox(height: 10),
            _buildScanItem('Robert Fox', 'Stage 2 - Moderate', '2 mins ago', Colors.orange),
            _buildScanItem('Jane Cooper', 'Stage 0 - Normal', '15 mins ago', AppTheme.mintGreen),
            _buildScanItem('Cody Fisher', 'Stage 3 - High Risk', '1 hour ago', Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildScanItem(String name, String status, String time, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.description_outlined, color: color),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(status, style: TextStyle(color: color.withOpacity(0.8), fontSize: 13)),
                ],
              ),
            ),
            Text(time, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        border: const Border(top: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppTheme.primaryCyan,
        unselectedItemColor: Colors.white.withOpacity(0.4),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt_outlined), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.history_toggle_off), label: 'Records'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
