import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/wrapper/main_wrapper.dart';
import '../../../cart/presentation/pages/cart_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _handleSignOut(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signed out successfully'), backgroundColor: Colors.green),
    );
    AppNavigator.toLogin(context);
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
    final destructive = AppColors.toColor(AppColors.darkDestructive);

    const email    = 'ahmed@blitzora.com';
    const fullName = 'Ahmed Mohamed';
    const username = 'ahmed_m';

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text('My profile', style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => AppNavigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // ── Avatar card ────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                color: card, borderRadius: BorderRadius.circular(AppTheme.radius),
                border: Border.all(color: border)),
              child: Column(children: [
                Stack(alignment: Alignment.bottomRight, children: [
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [primary, secondary],
                        begin: Alignment.topLeft, end: Alignment.bottomRight)),
                    child: const Center(
                      child: Text('A', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)))),
                  Positioned(right: 4, bottom: 4,
                    child: Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(
                        color: primary, shape: BoxShape.circle,
                        border: Border.all(color: bg, width: 2)),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16))),
                ]),
                const SizedBox(height: 14),
                Text(fullName, style: TextStyle(color: fg, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(email, style: TextStyle(color: muted, fontSize: 13)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primary.withOpacity(0.3))),
                  child: Text('Premium member', style: TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.w500))),
              ]),
            ),
            const SizedBox(height: 24),

            // ── Stats row ──────────────────────────────────────
            Row(children: [
              _StatCard(value: '12', label: 'Orders', primary: primary, card: card, border: border, fg: fg, muted: muted),
              const SizedBox(width: 12),
              _StatCard(value: '3', label: 'Favourites', primary: primary, card: card, border: border, fg: fg, muted: muted),
              const SizedBox(width: 12),
              _StatCard(value: '4.8', label: 'Rating', primary: primary, card: card, border: border, fg: fg, muted: muted),
            ]),
            const SizedBox(height: 24),

            // ── Profile fields ─────────────────────────────────
            Text('Profile information', style: TextStyle(color: fg, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Update your personal details', style: TextStyle(color: muted, fontSize: 13)),
            const SizedBox(height: 16),
            _FieldLabel('Email', fg: fg),
            const SizedBox(height: 6),
            TextFormField(initialValue: email, enabled: false,
              style: TextStyle(color: muted), decoration: const InputDecoration()),
            const SizedBox(height: 4),
            Text('Email cannot be changed', style: TextStyle(color: muted, fontSize: 11)),
            const SizedBox(height: 14),
            _FieldLabel('Full name', fg: fg),
            const SizedBox(height: 6),
            TextFormField(initialValue: fullName, style: TextStyle(color: fg),
              decoration: const InputDecoration(hintText: 'Enter your full name')),
            const SizedBox(height: 14),
            _FieldLabel('Username', fg: fg),
            const SizedBox(height: 6),
            TextFormField(initialValue: username, style: TextStyle(color: fg),
              decoration: InputDecoration(hintText: 'Enter your username',
                prefixIcon: Icon(Icons.alternate_email_rounded, color: muted, size: 18))),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusSm))),
                child: const Text('Save changes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))),
            const SizedBox(height: 32),

            // ── Quick actions ──────────────────────────────────
            Text('Account', style: TextStyle(color: fg, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _MenuTile(
              icon: Icons.shopping_bag_outlined,
              label: 'My orders',
              trailing: '12',
              primary: primary,
              card: card,
              border: border,
              fg: fg,
              muted: muted,
              onTap: () {
                if (CartPage.hasActiveOrder.value) {
                  AppNavigator.pushNamed(context, AppRoutes.trackOrder);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No active orders. Try placing an order in the Cart tab!')),
                  );
                }
              },
            ),
            const SizedBox(height: 8),
            _MenuTile(
              icon: Icons.favorite_border_rounded,
              label: 'Favourite pharmacies',
              trailing: '3',
              primary: primary,
              card: card,
              border: border,
              fg: fg,
              muted: muted,
              onTap: () => MainWrapper.of(context)?.selectTab(1),
            ),
            const SizedBox(height: 8),
            _MenuTile(
              icon: Icons.location_on_outlined,
              label: 'Saved addresses',
              trailing: '2',
              primary: primary,
              card: card,
              border: border,
              fg: fg,
              muted: muted,
              onTap: () {},
            ),
            const SizedBox(height: 8),
            _MenuTile(
              icon: Icons.settings_outlined,
              label: 'App Settings',
              primary: primary,
              card: card,
              border: border,
              fg: fg,
              muted: muted,
              onTap: () => AppNavigator.pushNamed(context, AppRoutes.settings),
            ),
            const SizedBox(height: 24),

            // ── Sign out ───────────────────────────────────────
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(AppTheme.radius), border: Border.all(color: border)),
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Account actions', style: TextStyle(color: fg, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _handleSignOut(context),
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text('Sign out', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: destructive,
                      side: BorderSide(color: destructive.withOpacity(0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusSm)))),
                ),
              ])),
            const SizedBox(height: 30),
          ]),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label; final Color fg;
  const _FieldLabel(this.label, {required this.fg});
  @override
  Widget build(BuildContext context) =>
      Text(label, style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.w500));
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final Color primary, card, border, fg, muted;
  const _StatCard({required this.value, required this.label, required this.primary,
      required this.card, required this.border, required this.fg, required this.muted});
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(14), border: Border.all(color: border)),
      child: Column(children: [
        Text(value, style: TextStyle(color: primary, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: muted, fontSize: 11)),
      ])));
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final Color primary, card, border, fg, muted;
  final VoidCallback onTap;
  const _MenuTile({required this.icon, required this.label, this.trailing,
      required this.primary, required this.card, required this.border, required this.fg, required this.muted, required this.onTap});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(12), border: Border.all(color: border)),
    child: ListTile(
      onTap: onTap,
      leading: Container(width: 36, height: 36,
        decoration: BoxDecoration(color: primary.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: primary, size: 18)),
      title: Text(label, style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        if (trailing != null) Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: primary.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
          child: Text(trailing!, style: TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.w500))),
        const SizedBox(width: 6),
        Icon(Icons.arrow_forward_ios_rounded, color: muted, size: 14),
      ]),
    ));
}
