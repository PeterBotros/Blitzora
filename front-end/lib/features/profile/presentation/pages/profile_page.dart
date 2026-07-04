import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
    context.read<ProfileBloc>().add(const LoadProfileEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _populateControllers(ProfileEntity profile) {
    _nameController.text = profile.fullName ?? '';
    _usernameController.text = profile.username;
    _phoneController.text = profile.phone ?? '';
  }

  void _handleSaveChanges() {
    context.read<ProfileBloc>().add(UpdateProfileEvent(
          fullName: _nameController.text.trim(),
          username: _usernameController.text.trim(),
          phone: _phoneController.text.trim(),
        ));
  }

  void _handleSignOut() {
    context.read<ProfileBloc>().add(const LogoutProfileEvent());
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

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded || state is ProfileUpdated) {
          final profile = state is ProfileLoaded
              ? state.profile
              : (state as ProfileUpdated).profile;
          _populateControllers(profile);
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('profile_updated'.tr()),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else if (state is ProfileLoggedOut) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('signed_out'.tr()),
              backgroundColor: Colors.green,
            ),
          );
          AppNavigator.toLogin(context);
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ProfileLoading;

        ProfileEntity? profile;
        if (state is ProfileLoaded) profile = state.profile;
        if (state is ProfileUpdated) profile = state.profile;

        final email = profile?.email ?? '—';
        final fullName = profile?.displayName ?? '—';
        final avatarLetter = profile?.avatarLetter ?? fullName[0].toUpperCase();

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            title: Text('my_profile'.tr(),
                style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () =>
                    AppNavigator.pushNamed(context, AppRoutes.settings),
              ),
            ],
          ),
          body: isLoading && profile == null
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Avatar card ──────────────────────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 28),
                          decoration: BoxDecoration(
                            color: card,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radius),
                            border: Border.all(color: border),
                          ),
                          child: Column(children: [
                            Stack(alignment: Alignment.bottomRight, children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [primary, secondary],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    avatarLetter,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 4,
                                bottom: 4,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: bg, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ]),
                            const SizedBox(height: 14),
                            Text(
                              fullName,
                              style: TextStyle(
                                color: fg,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(email,
                                style: TextStyle(color: muted, fontSize: 13)),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: primary.withOpacity(0.3)),
                              ),
                              child: Text(
                                profile?.role == 'admin'
                                    ? 'admin'.tr()
                                    : 'premium_member'.tr(),
                                style: TextStyle(
                                  color: primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(height: 24),

                        // ── Profile fields ───────────────────────────────────
                        Text('profile_info'.tr(),
                            style: TextStyle(
                                color: fg,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('update_personal_details'.tr(),
                            style: TextStyle(color: muted, fontSize: 13)),
                        const SizedBox(height: 16),

                        _FieldLabel('email'.tr(), fg: fg),
                        const SizedBox(height: 6),
                        TextFormField(
                          initialValue: email,
                          enabled: false,
                          style: TextStyle(color: muted),
                          decoration: const InputDecoration(),
                        ),
                        const SizedBox(height: 4),
                        Text('email_cannot_be_changed'.tr(),
                            style: TextStyle(color: muted, fontSize: 11)),
                        const SizedBox(height: 14),

                        _FieldLabel('full_name'.tr(), fg: fg),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _nameController,
                          style: TextStyle(color: fg),
                          decoration:
                              InputDecoration(hintText: 'enter_full_name'.tr()),
                        ),
                        const SizedBox(height: 14),

                        _FieldLabel('username'.tr(), fg: fg),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _usernameController,
                          style: TextStyle(color: fg),
                          decoration: InputDecoration(
                            hintText: 'enter_username'.tr(),
                            prefixIcon: Icon(Icons.alternate_email_rounded,
                                color: muted, size: 18),
                          ),
                        ),
                        const SizedBox(height: 14),

                        _FieldLabel('phone'.tr(), fg: fg),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(color: fg),
                          decoration:
                              InputDecoration(hintText: 'enter_phone'.tr()),
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleSaveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppTheme.radiusSm),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text('save_changes'.tr(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // ── Quick actions ────────────────────────────────────
                        Text('account'.tr(),
                            style: TextStyle(
                                color: fg,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        _MenuTile(
                          icon: Icons.shopping_bag_outlined,
                          label: 'my_orders'.tr(),
                          trailing: '${profile?.ordersCount ?? 0}',
                          primary: primary,
                          card: card,
                          border: border,
                          fg: fg,
                          muted: muted,
                          onTap: () {
                            if (CartPage.hasActiveOrder.value) {
                              AppNavigator.pushNamed(
                                  context, AppRoutes.trackOrder);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('no_active_orders'.tr()),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        _MenuTile(
                          icon: Icons.favorite_border_rounded,
                          label: 'favourite_products'.tr(),
                          trailing: '${profile?.favoritesCount ?? 0}',
                          primary: primary,
                          card: card,
                          border: border,
                          fg: fg,
                          muted: muted,
                          onTap: () => AppNavigator.pushNamed(
                              context, AppRoutes.favorites),
                        ),
                        const SizedBox(height: 8),
                        _MenuTile(
                          icon: Icons.location_on_outlined,
                          label: 'saved_addresses'.tr(),
                          trailing: '2',
                          primary: primary,
                          card: card,
                          border: border,
                          fg: fg,
                          muted: muted,
                          onTap: () {},
                        ),
                        const SizedBox(height: 24),

                        // ── Sign out ─────────────────────────────────────────
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: card,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radius),
                            border: Border.all(color: border),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('account_actions'.tr(),
                                  style: TextStyle(
                                      color: fg,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: isLoading ? null : _handleSignOut,
                                  icon: const Icon(Icons.logout_rounded,
                                      size: 18),
                                  label: Text('sign_out'.tr(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: destructive,
                                    side: BorderSide(
                                        color: destructive.withOpacity(0.5)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppTheme.radiusSm),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final Color fg;
  const _FieldLabel(this.label, {required this.fg});
  @override
  Widget build(BuildContext context) => Text(
        label,
        style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.w500),
      );
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final Color primary, card, border, fg, muted;
  const _StatCard(
      {required this.value,
      required this.label,
      required this.primary,
      required this.card,
      required this.border,
      required this.fg,
      required this.muted});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Column(children: [
          Text(value,
              style: TextStyle(
                  color: primary, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: muted, fontSize: 11)),
        ]),
      );
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final Color primary, card, border, fg, muted;
  final VoidCallback onTap;
  const _MenuTile(
      {required this.icon,
      required this.label,
      this.trailing,
      required this.primary,
      required this.card,
      required this.border,
      required this.fg,
      required this.muted,
      required this.onTap});
  @override
  Widget build(BuildContext context) => Material(
        color: card,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: ListTile(
            onTap: onTap,
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: primary, size: 18),
            ),
            title: Text(label,
                style: TextStyle(
                    color: fg, fontSize: 14, fontWeight: FontWeight.w500)),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              if (trailing != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(trailing!,
                      style: TextStyle(
                          color: primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500)),
                ),
              const SizedBox(width: 6),
              Icon(Icons.arrow_forward_ios_rounded, color: muted, size: 14),
            ]),
          ),
        ),
      );
}
