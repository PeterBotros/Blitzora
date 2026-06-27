import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/wrapper/main_wrapper.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/promo_card.dart';
import '../widgets/category_item.dart';
import '../widgets/offer_card.dart';
import '../widgets/pharmacy_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary(dark);
    final accent = AppColors.accent(dark);
    final secondary = AppColors.secondary(dark);
    final bg = AppColors.background(dark);
    final card = AppColors.card(dark);
    final fg = AppColors.fg(dark);
    final muted = AppColors.muted(dark);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeTopBar(
                  primaryColor: primary, accentColor: accent, cardColor: card),

              // Location pill
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: primary, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Cairo, Egypt',
                        style: TextStyle(
                            color: fg,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () => MainWrapper.of(context)?.selectTab(1),
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, minimumSize: Size.zero),
                      child: Text('Change',
                          style: TextStyle(color: primary, fontSize: 13)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),
              HomeSearchBar(
                  cardColor: card,
                  mutedForegroundColor: muted,
                  foregroundColor: fg),
              const SizedBox(height: 20),

              // Promo cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Expanded(
                      child: PromoCard(
                          icon: Icons.access_time_rounded,
                          iconColor: primary,
                          largeText: '30 min',
                          smallText: 'Fast delivery',
                          cardColor: card,
                          textColor: fg,
                          mutedColor: muted)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: PromoCard(
                          icon: Icons.percent_rounded,
                          iconColor: accent,
                          largeText: '20% off',
                          smallText: 'First order',
                          cardColor: card,
                          textColor: fg,
                          mutedColor: muted)),
                ]),
              ),
              const SizedBox(height: 18),

              // Active Order Status Card
              ValueListenableBuilder<bool>(
                valueListenable: CartPage.hasActiveOrder,
                builder: (context, hasOrder, child) {
                  if (!hasOrder) return const SizedBox.shrink();
                  return _buildActiveOrderCard(primary, accent, card, fg, muted);
                },
              ),

              // Prescription Scan Banner
              _buildPrescriptionUploadBanner(primary, accent, card, fg, muted),

              // Daily Reminders pill organizer banner
              _buildPillReminderSummary(primary, accent, card, fg, muted),

              const SizedBox(height: 18),

              // Categories
              _SectionHeader(
                  title: 'Categories',
                  actionLabel: 'See all',
                  primary: primary,
                  fg: fg),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryItem(
                        icon: Icons.medication_rounded,
                        label: 'Medicines',
                        color: primary,
                        cardColor: card,
                        textColor: fg),
                    CategoryItem(
                        icon: Icons.favorite_border_rounded,
                        label: 'Vitamins',
                        color: primary,
                        cardColor: card,
                        textColor: fg),
                    CategoryItem(
                        icon: Icons.water_drop_outlined,
                        label: 'Skin care',
                        color: primary,
                        cardColor: card,
                        textColor: fg),
                    CategoryItem(
                        icon: Icons.monitor_heart_outlined,
                        label: 'Devices',
                        color: primary,
                        cardColor: card,
                        textColor: fg),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Nearby pharmacies
              _SectionHeader(
                  title: 'Nearby pharmacies',
                  actionLabel: 'See all',
                  primary: primary,
                  fg: fg,
                  onAction: () => MainWrapper.of(context)?.selectTab(1)),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  PharmacyCard(
                      name: 'El Ezaby – Maadi',
                      address: '10 Road 9, Maadi',
                      rating: 4.7,
                      distance: '0.8 km',
                      isOpen: true,
                      primaryColor: primary,
                      accentColor: accent,
                      cardColor: card,
                      foregroundColor: fg,
                      mutedColor: muted),
                  const SizedBox(height: 10),
                  PharmacyCard(
                      name: 'Seif – Dokki',
                      address: '3 Tahrir St, Dokki',
                      rating: 4.5,
                      distance: '1.4 km',
                      isOpen: true,
                      primaryColor: primary,
                      accentColor: accent,
                      cardColor: card,
                      foregroundColor: fg,
                      mutedColor: muted),
                ]),
              ),
              const SizedBox(height: 28),

              // Offers
              _SectionHeader(
                  title: 'Offers for you',
                  actionLabel: 'View all',
                  primary: primary,
                  fg: fg),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  OfferCard(
                      icon: Icons.local_offer_outlined,
                      iconColor: accent,
                      iconBackgroundColor: accent.withOpacity(0.15),
                      title: 'Summer health sale',
                      discount: '40% OFF',
                      description: 'On vitamins and supplements',
                      validity: 'Valid until July 31',
                      primaryColor: primary,
                      cardColor: card,
                      foregroundColor: fg,
                      mutedColor: muted),
                  const SizedBox(height: 10),
                  OfferCard(
                      icon: Icons.percent_rounded,
                      iconColor: primary,
                      iconBackgroundColor: primary.withOpacity(0.15),
                      title: 'First order special',
                      discount: '20% OFF',
                      description: 'Use code: FIRST20',
                      validity: 'For new customers',
                      primaryColor: primary,
                      cardColor: card,
                      foregroundColor: fg,
                      mutedColor: muted),
                  const SizedBox(height: 10),
                  OfferCard(
                      icon: Icons.local_shipping_outlined,
                      iconColor: secondary,
                      iconBackgroundColor: secondary.withOpacity(0.15),
                      title: 'Free delivery',
                      discount: 'FREE',
                      description: 'On orders above EGP 500',
                      validity: 'This month only',
                      primaryColor: primary,
                      cardColor: card,
                      foregroundColor: fg,
                      mutedColor: muted),
                  const SizedBox(height: 24),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveOrderCard(Color primary, Color accent, Color card, Color fg, Color muted) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: primary.withOpacity(0.12), shape: BoxShape.circle),
                child: Icon(Icons.delivery_dining_rounded, color: primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Active Medicine Order', style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text('Mahmoud is on his way • ETA 12 mins', style: TextStyle(color: muted, fontSize: 11)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => AppNavigator.pushNamed(context, AppRoutes.trackOrder),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                child: Text('Track', style: TextStyle(color: primary, fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.65,
              minHeight: 5,
              backgroundColor: muted.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionUploadBanner(Color primary, Color accent, Color card, Color fg, Color muted) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primary.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => AppNavigator.pushNamed(context, AppRoutes.prescriptionUpload),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.document_scanner_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upload Doctor Prescription',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Order prescription drugs easily in minutes',
                        style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillReminderSummary(Color primary, Color accent, Color card, Color fg, Color muted) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(Theme.of(context).brightness == Brightness.dark)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => AppNavigator.pushNamed(context, AppRoutes.pillReminder),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.schedule_rounded, color: accent, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Medication Reminders', style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text('Next: Lipitor at 09:00 PM', style: TextStyle(color: muted, fontSize: 11)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('2/3 Done', style: TextStyle(color: primary, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final Color primary;
  final Color fg;
  final VoidCallback? onAction;

  const _SectionHeader(
      {required this.title,
      required this.actionLabel,
      required this.primary,
      required this.fg,
      this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  color: fg, fontSize: 18, fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: onAction ?? () {},
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero, minimumSize: Size.zero),
            child: Text(actionLabel,
                style: TextStyle(
                    color: primary, fontSize: 13, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
