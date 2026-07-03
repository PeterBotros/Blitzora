import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/wrapper/main_wrapper.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/offer_entity.dart';
import '../../domain/entities/pharmacy_entity.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/home_location_selector.dart';
import '../widgets/promo_card.dart';
import '../widgets/category_item.dart';
import '../widgets/offer_card.dart';
import '../../../map/presentation/pages/pharmacy_detail_page.dart';
import '../../../products/presentation/bloc/product_bloc.dart';
import '../../../products/presentation/bloc/product_event.dart';
import '../widgets/pharmacy_card.dart';

IconData _categoryIcon(String name) {
  final n = name.toLowerCase();
  if (n.contains('vitamin') || n.contains('supplement'))
    return Icons.favorite_border_rounded;
  if (n.contains('skin') || n.contains('care') || n.contains('beauty'))
    return Icons.water_drop_outlined;
  if (n.contains('device') || n.contains('equipment'))
    return Icons.monitor_heart_outlined;
  if (n.contains('baby') || n.contains('infant'))
    return Icons.child_care_rounded;
  return Icons.medication_rounded;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadHomeEvent());
  }

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
    final border = AppColors.border(dark);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(const LoadHomeEvent());
                await Future.delayed(const Duration(milliseconds: 800));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeTopBar(
                          primaryColor: primary,
                          accentColor: accent,
                          cardColor: card),

                      // ── Location selector ─────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: HomeLocationSelector(
                            primary: primary,
                            fg: fg,
                            card: card,
                            muted: muted,
                            border: border),
                      ),

                      const SizedBox(height: 20),

                      // Active order banner
                      ValueListenableBuilder<bool>(
                        valueListenable: CartPage.hasActiveOrder,
                        builder: (context, hasOrder, child) {
                          if (!hasOrder) return const SizedBox.shrink();
                          return _buildActiveOrderCard(
                              primary, accent, card, fg, muted);
                        },
                      ),

                      // Prescription / pill reminder banners (unchanged)
                      _buildPrescriptionUploadBanner(
                          primary, accent, card, fg, muted),
                      _buildPillReminderSummary(
                          primary, accent, card, fg, muted, border),

                      const SizedBox(height: 18),

                      // ── Categories ────────────────────────────────────────
                      _SectionHeader(
                          title: 'categories'.tr(),
                          actionLabel: 'see_all'.tr(),
                          primary: primary,
                          fg: fg,
                          onAction: () =>
                              MainWrapper.of(context)?.selectTab(2)),
                      const SizedBox(height: 14),
                      _buildCategories(state, primary, card, fg, muted),
                      const SizedBox(height: 18),

                      // ── Nearby Pharmacies ─────────────────────────────────
                      _SectionHeader(
                          title: 'nearby_pharmacies'.tr(),
                          actionLabel: 'see_all'.tr(),
                          primary: primary,
                          fg: fg,
                          onAction: () =>
                              MainWrapper.of(context)?.selectTab(1)),
                      const SizedBox(height: 14),
                      _buildPharmacies(state, primary, accent, card, fg, muted),
                      const SizedBox(height: 18),

                      // ── Offers ────────────────────────────────────────────
                      _SectionHeader(
                          title: 'offers_for_you'.tr(),
                          actionLabel: 'see_all'.tr(),
                          primary: primary,
                          fg: fg),
                      const SizedBox(height: 14),
                      _buildOffers(
                          state, primary, accent, secondary, card, fg, muted),
                      const SizedBox(height: 24),
                    ]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategories(
      HomeState state, Color primary, Color card, Color fg, Color muted) {
    if (state is HomeLoading) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
    }

    // Build item list from backend or fall back to defaults
    final List<Widget> items;
    if (state is HomeLoaded && state.categories.isNotEmpty) {
      items = state.categories
          .map((cat) => CategoryItem(
                icon: _categoryIcon(cat.name),
                label: cat.name,
                color: primary,
                cardColor: card,
                textColor: fg,
                onTap: () {
                  context
                      .read<ProductBloc>()
                      .add(LoadProductsEvent(categoryId: cat.id));
                  AppNavigator.pushNamed(context, AppRoutes.products);
                },
              ))
          .toList();
    } else {
      items = [
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
      ];
    }

    return SizedBox(
      height: 116, // icon 64 + gap 8 + label 32 + some breathing room
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => items[i],
      ),
    );
  }

  Widget _buildPharmacies(HomeState state, Color primary, Color accent,
      Color card, Color fg, Color muted) {
    if (state is HomeLoaded && state.pharmacies.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            children: state.pharmacies
                .take(3)
                .map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: PharmacyCard(
                        name: p.name,
                        address: p.address ?? 'Cairo, Egypt',
                        rating: 4.5,
                        distance: '—',
                        isOpen: p.isOpen,
                        primaryColor: primary,
                        accentColor: accent,
                        cardColor: card,
                        foregroundColor: fg,
                        mutedColor: muted,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    PharmacyDetailPage(pharmacy: p))))))
                .toList()),
      );
    }
    return Padding(
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
    );
  }

  Widget _buildOffers(HomeState state, Color primary, Color accent,
      Color secondary, Color card, Color fg, Color muted) {
    if (state is HomeLoaded && state.offers.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            children: state.offers
                .take(3)
                .map((o) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: OfferCard(
                        icon: Icons.local_offer_outlined,
                        iconColor: accent,
                        iconBackgroundColor: accent.withOpacity(0.15),
                        title: o.name,
                        discount: '${o.discountPercent}% OFF',
                        description: o.description ?? '',
                        validity: 'Limited time',
                        primaryColor: primary,
                        cardColor: card,
                        foregroundColor: fg,
                        mutedColor: muted)))
                .toList()),
      );
    }
    return Padding(
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
      ]),
    );
  }

  Widget _buildActiveOrderCard(
      Color primary, Color accent, Color card, Color fg, Color muted) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primary.withOpacity(0.4))),
      child: Column(children: [
        Row(children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: primary.withOpacity(0.12), shape: BoxShape.circle),
              child: Icon(Icons.delivery_dining_rounded,
                  color: primary, size: 22)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Active Medicine Order',
                    style: TextStyle(
                        color: fg, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text('Mahmoud is on his way • ETA 12 mins',
                    style: TextStyle(color: muted, fontSize: 11)),
              ])),
          TextButton(
              onPressed: () =>
                  AppNavigator.pushNamed(context, AppRoutes.trackOrder),
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, minimumSize: Size.zero),
              child: Text('Track',
                  style: TextStyle(
                      color: primary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold))),
        ]),
        const SizedBox(height: 12),
        ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
                value: 0.65,
                minHeight: 5,
                backgroundColor: muted.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(primary))),
      ]),
    );
  }

  Widget _buildPrescriptionUploadBanner(
      Color primary, Color accent, Color card, Color fg, Color muted) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [primary, primary.withOpacity(0.85)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16)),
      child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () =>
                AppNavigator.pushNamed(context, AppRoutes.prescriptionUpload),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle),
                      child: const Icon(Icons.document_scanner_rounded,
                          color: Colors.white, size: 22)),
                  const SizedBox(width: 14),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('upload_prescription'.tr(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text('upload_prescription_subtitle'.tr(),
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 11)),
                      ])),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white, size: 14),
                ])),
          )),
    );
  }

  Widget _buildPillReminderSummary(Color primary, Color accent, Color card,
      Color fg, Color muted, Color border) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border)),
      child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () =>
                AppNavigator.pushNamed(context, AppRoutes.pillReminder),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: accent.withOpacity(0.12),
                          shape: BoxShape.circle),
                      child: Icon(Icons.schedule_rounded,
                          color: accent, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('medication_reminders'.tr(),
                            style: TextStyle(
                                color: fg,
                                fontSize: 13,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text('Next: Lipitor at 09:00 PM',
                            style: TextStyle(color: muted, fontSize: 11)),
                      ])),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text('2/3 Done',
                          style: TextStyle(
                              color: primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold))),
                ])),
          )),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title, actionLabel;
  final Color primary, fg;
  final VoidCallback? onAction;
  const _SectionHeader(
      {required this.title,
      required this.actionLabel,
      required this.primary,
      required this.fg,
      this.onAction});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title,
              style: TextStyle(
                  color: fg, fontSize: 18, fontWeight: FontWeight.bold)),
          TextButton(
              onPressed: onAction ?? () {},
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, minimumSize: Size.zero),
              child: Text(actionLabel,
                  style: TextStyle(
                      color: primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500))),
        ]),
      );
}
