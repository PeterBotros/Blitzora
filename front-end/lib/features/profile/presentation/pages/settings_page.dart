import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _emailAlerts = false;
  bool _biometricLogin = true;
  String _selectedLanguage = 'English';

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final dark = Theme.of(context).brightness == Brightness.dark;
        final fg = AppColors.fg(dark);
        final card = AppColors.card(dark);
        final primary = AppColors.primary(dark);

        final languages = ['English', 'العربية (Arabic)', 'Español (Spanish)', 'Français (French)'];

        return Container(
          color: card,
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  'Select Language',
                  style: TextStyle(color: fg, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              ...languages.map((lang) {
                final isSelected = lang.startsWith(_selectedLanguage);
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  title: Text(
                    lang,
                    style: TextStyle(
                      color: fg,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected ? Icon(Icons.check_circle, color: primary) : null,
                  onTap: () {
                    setState(() {
                      _selectedLanguage = lang.split(' ')[0];
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) {
        final dark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: AppColors.card(dark),
          title: Text('Clear Cache', style: TextStyle(color: AppColors.fg(dark))),
          content: Text('Are you sure you want to clear temporary app data?', style: TextStyle(color: AppColors.muted(dark))),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('App cache cleared successfully'), backgroundColor: Colors.green),
                );
              },
              child: Text('Clear', style: TextStyle(color: AppColors.primary(dark))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary(dark);
    final secondary = AppColors.secondary(dark);
    final bg = AppColors.background(dark);
    final card = AppColors.card(dark);
    final fg = AppColors.fg(dark);
    final muted = AppColors.muted(dark);
    final border = AppColors.border(dark);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ── Theme Section ──────────────────────────────────
            _sectionHeader('Appearance', fg),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: ValueListenableBuilder<ThemeMode>(
                valueListenable: BlitzoraApp.themeNotifier,
                builder: (context, currentThemeMode, child) {
                  final isDark = currentThemeMode == ThemeMode.dark;
                  return SwitchListTile(
                    activeColor: primary,
                    title: Text('Dark Theme', style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('Enable dark mode for comfortable night viewing', style: TextStyle(color: muted, fontSize: 12)),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (isDark ? primary : secondary).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        color: isDark ? primary : secondary,
                        size: 20,
                      ),
                    ),
                    value: isDark,
                    onChanged: (value) {
                      BlitzoraApp.themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // ── Notifications Section ────────────────────────────
            _sectionHeader('Notifications', fg),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: primary,
                    title: Text('Push Notifications', style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('Order updates, pharmacist alerts & delivery status', style: TextStyle(color: muted, fontSize: 12)),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.notifications_active_outlined, color: primary, size: 20),
                    ),
                    value: _pushNotifications,
                    onChanged: (v) => setState(() => _pushNotifications = v),
                  ),
                  Divider(height: 1, color: border, indent: 56),
                  SwitchListTile(
                    activeColor: primary,
                    title: Text('Email Newsletters', style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('Receive promotions and health care recommendations', style: TextStyle(color: muted, fontSize: 12)),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.email_outlined, color: primary, size: 20),
                    ),
                    value: _emailAlerts,
                    onChanged: (v) => setState(() => _emailAlerts = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Account & Preferences ────────────────────────────
            _sectionHeader('Preferences & Security', fg),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.translate_rounded, color: primary, size: 20),
                    ),
                    title: Text('App Language', style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_selectedLanguage, style: TextStyle(color: muted, fontSize: 13)),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios_rounded, color: muted, size: 14),
                      ],
                    ),
                    onTap: _showLanguageSelector,
                  ),
                  Divider(height: 1, color: border, indent: 56),
                  SwitchListTile(
                    activeColor: primary,
                    title: Text('Biometric Login', style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('Fast login using fingerprint or Face ID', style: TextStyle(color: muted, fontSize: 12)),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.fingerprint_rounded, color: primary, size: 20),
                    ),
                    value: _biometricLogin,
                    onChanged: (v) => setState(() => _biometricLogin = v),
                  ),
                  Divider(height: 1, color: border, indent: 56),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.lock_reset_rounded, color: primary, size: 20),
                    ),
                    title: Text('Change Password', style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: Icon(Icons.arrow_forward_ios_rounded, color: muted, size: 14),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── System settings ──────────────────────────────────
            _sectionHeader('System Settings', fg),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.cleaning_services_outlined, color: primary, size: 20),
                    ),
                    title: Text('Clear App Cache', style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: Icon(Icons.arrow_forward_ios_rounded, color: muted, size: 14),
                    onTap: _clearCache,
                  ),
                  Divider(height: 1, color: border, indent: 56),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.info_outline_rounded, color: primary, size: 20),
                    ),
                    title: Text('About Blitzora', style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: Icon(Icons.arrow_forward_ios_rounded, color: muted, size: 14),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // App Version Footer
            Center(
              child: Text(
                'Blitzora v1.0.4 - Premium',
                style: TextStyle(color: muted, fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, Color fg) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }
}
