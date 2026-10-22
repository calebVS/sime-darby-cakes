import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'personalized_screen.dart';
import 'points_transaction_screen.dart';
import 'my_reports_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Listen to global state
    final appState = Provider.of<AppState>(context);
    final isMalay = appState.language == 'Bahasa Melayu';
    final isDark = appState.isDarkMode;

    // 2. Dynamic Theme Colors
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F7F5);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isMalay ? 'Profil' : 'Profile',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=300',
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 3. Dynamic Display Name
                    Text(
                      appState.displayName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 4. Dynamic Language Menu Items
              _buildMenuItem(
                icon: Icons.edit_outlined,
                title: isMalay ? 'Peribadikan' : 'Personalize',
                cardColor: cardColor,
                textColor: textColor,
                borderColor: borderColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonalizeScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.receipt_long_outlined,
                title: isMalay ? 'Transaksi Mata' : 'Points Transaction',
                cardColor: cardColor,
                textColor: textColor,
                borderColor: borderColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PointsTransactionScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.description_outlined,
                title: isMalay ? 'Laporan Saya' : 'My Reports',
                cardColor: cardColor,
                textColor: textColor,
                borderColor: borderColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyReportsScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.logout_outlined,
                title: isMalay ? 'Log Keluar' : 'Log Out',
                cardColor: cardColor,
                textColor: textColor,
                borderColor: borderColor,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color cardColor,
    required Color textColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Icon(icon, color: textColor, size: 22),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}