import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../widgets/promo_card.dart';
import '../widgets/category_item.dart';
import '../widgets/offer_card.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/home_location_selector.dart';
import '../widgets/home_search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.toColor(AppColors.darkPrimary);
    final accentColor = AppColors.toColor(AppColors.darkAccent);
    final backgroundColor = AppColors.toColor(AppColors.darkBackground);
    final cardColor = AppColors.toColor(AppColors.darkCard);
    final foregroundColor = AppColors.toColor(AppColors.darkForeground);
    final mutedForegroundColor =
        AppColors.toColor(AppColors.darkMutedForeground);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              HomeTopBar(
                primaryColor: primaryColor,
                accentColor: accentColor,
                cardColor: cardColor,
              ),

              // Location Selector
              HomeLocationSelector(
                primaryColor: primaryColor,
                foregroundColor: foregroundColor,
              ),

              const SizedBox(height: 20),

              // Search Bar
              HomeSearchBar(
                cardColor: cardColor,
                mutedForegroundColor: mutedForegroundColor,
                foregroundColor: foregroundColor,
              ),

              const SizedBox(height: 24),

              // Promotional Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: PromoCard(
                        icon: Icons.access_time,
                        iconColor: primaryColor,
                        largeText: '30min',
                        smallText: 'Fast Delivery',
                        cardColor: cardColor,
                        textColor: foregroundColor,
                        mutedColor: mutedForegroundColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PromoCard(
                        icon: Icons.percent,
                        iconColor: accentColor,
                        largeText: '20%',
                        smallText: 'Off First Order',
                        cardColor: cardColor,
                        textColor: foregroundColor,
                        mutedColor: mutedForegroundColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Categories Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryItem(
                      icon: Icons.medication,
                      label: 'Medicines',
                      color: primaryColor,
                      cardColor: cardColor,
                      textColor: foregroundColor,
                    ),
                    CategoryItem(
                      icon: Icons.favorite_border,
                      label: 'Vitamins',
                      color: primaryColor,
                      cardColor: cardColor,
                      textColor: foregroundColor,
                    ),
                    CategoryItem(
                      icon: Icons.auto_awesome,
                      label: 'Personal Care',
                      color: primaryColor,
                      cardColor: cardColor,
                      textColor: foregroundColor,
                    ),
                    CategoryItem(
                      icon: Icons.water_drop,
                      label: 'Devices',
                      color: primaryColor,
                      cardColor: cardColor,
                      textColor: foregroundColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Offers for You Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Offers for You',
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'View All',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    OfferCard(
                      icon: Icons.local_offer_outlined,
                      iconColor: accentColor,
                      iconBackgroundColor: accentColor.withOpacity(0.2),
                      title: 'Summer Health Sale',
                      discount: '40% OFF',
                      description: 'On vitamins and...',
                      validity: 'Valid until July 31',
                      primaryColor: primaryColor,
                      cardColor: cardColor,
                      foregroundColor: foregroundColor,
                      mutedColor: mutedForegroundColor,
                    ),
                    const SizedBox(height: 12),
                    OfferCard(
                      icon: Icons.percent,
                      iconColor: primaryColor,
                      iconBackgroundColor: primaryColor.withOpacity(0.2),
                      title: 'First Order Special',
                      discount: '20% OFF',
                      description: 'Use code: FIRST20',
                      validity: 'For new customers',
                      primaryColor: primaryColor,
                      cardColor: cardColor,
                      foregroundColor: foregroundColor,
                      mutedColor: mutedForegroundColor,
                    ),
                    const SizedBox(height: 12),
                    OfferCard(
                      icon: Icons.local_shipping_outlined,
                      iconColor: Colors.lightBlue,
                      iconBackgroundColor: Colors.lightBlue.withOpacity(0.2),
                      title: 'Free Delivery',
                      discount: '₹0',
                      description: 'On orders above ₹500',
                      validity: 'This month only',
                      primaryColor: primaryColor,
                      cardColor: cardColor,
                      foregroundColor: foregroundColor,
                      mutedColor: mutedForegroundColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
