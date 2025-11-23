import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo "B"
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'B',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Right side icons
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () {},
                        ),
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.notifications_outlined,
                                  color: Colors.white),
                              onPressed: () {},
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'P',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Location Selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Downtown',
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Change',
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

              const SizedBox(height: 20),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search medicines, health pro',
                      hintStyle: TextStyle(color: mutedForegroundColor),
                      prefixIcon:
                          Icon(Icons.search, color: mutedForegroundColor),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    style: TextStyle(color: foregroundColor),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Promotional Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _PromoCard(
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
                      child: _PromoCard(
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
                    _CategoryItem(
                      icon: Icons.medication,
                      label: 'Medicines',
                      color: primaryColor,
                      cardColor: cardColor,
                      textColor: foregroundColor,
                    ),
                    _CategoryItem(
                      icon: Icons.favorite_border,
                      label: 'Vitamins',
                      color: primaryColor,
                      cardColor: cardColor,
                      textColor: foregroundColor,
                    ),
                    _CategoryItem(
                      icon: Icons.auto_awesome,
                      label: 'Personal Care',
                      color: primaryColor,
                      cardColor: cardColor,
                      textColor: foregroundColor,
                    ),
                    _CategoryItem(
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
                    _OfferCard(
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
                    _OfferCard(
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
                    _OfferCard(
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
              const SizedBox(height: 40),

              // How It Works Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'How It Works',
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _HowItWorksItem(
                      icon: Icons.search,
                      iconColor: primaryColor,
                      title: 'Search',
                      description: 'Find medicines easily',
                      foregroundColor: foregroundColor,
                      mutedColor: mutedForegroundColor,
                    ),
                    _HowItWorksItem(
                      icon: Icons.shopping_bag_outlined,
                      iconColor: Colors.lightBlue,
                      title: 'Add to Cart',
                      description: 'Select & add items',
                      foregroundColor: foregroundColor,
                      mutedColor: mutedForegroundColor,
                    ),
                    _HowItWorksItem(
                      icon: Icons.local_shipping_outlined,
                      iconColor: accentColor,
                      title: 'Delivery',
                      description: '30 min delivery',
                      foregroundColor: foregroundColor,
                      mutedColor: mutedForegroundColor,
                    ),
                    _HowItWorksItem(
                      icon: Icons.check_circle_outline,
                      iconColor: primaryColor,
                      title: 'Enjoy',
                      description: 'Stay healthy',
                      foregroundColor: foregroundColor,
                      mutedColor: mutedForegroundColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Nearby Pharmacies Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nearby Pharmacies',
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
                        'View Map',
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
                    _PharmacyCard(
                      name: 'MedPlus Pharmacy',
                      address: '123 Main Street, Downtown',
                      rating: 4.8,
                      distance: '0.5 km',
                      isOpen: true,
                      primaryColor: primaryColor,
                      accentColor: accentColor,
                      cardColor: cardColor,
                      foregroundColor: foregroundColor,
                      mutedColor: mutedForegroundColor,
                    ),
                    const SizedBox(height: 12),
                    _PharmacyCard(
                      name: 'HealthCare Pharmacy',
                      address: '456 Park Avenue, Central',
                      rating: 4.6,
                      distance: '1.2 km',
                      isOpen: true,
                      primaryColor: primaryColor,
                      accentColor: accentColor,
                      cardColor: cardColor,
                      foregroundColor: foregroundColor,
                      mutedColor: mutedForegroundColor,
                    ),
                    const SizedBox(height: 12),
                    _PharmacyCard(
                      name: 'Apollo Pharmacy',
                      address: '789 Oak Road, Eastside',
                      rating: 4.9,
                      distance: '2.0 km',
                      isOpen: false,
                      primaryColor: primaryColor,
                      accentColor: accentColor,
                      cardColor: cardColor,
                      foregroundColor: foregroundColor,
                      mutedColor: mutedForegroundColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border(
            top: BorderSide(
              color: AppColors.toColor(AppColors.darkBorder),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: primaryColor,
          unselectedItemColor: mutedForegroundColor,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart_outlined),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              label: 'Map',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// Promotional Card Widget
class _PromoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String largeText;
  final String smallText;
  final Color cardColor;
  final Color textColor;
  final Color mutedColor;

  const _PromoCard({
    required this.icon,
    required this.iconColor,
    required this.largeText,
    required this.smallText,
    required this.cardColor,
    required this.textColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 12),
          Text(
            largeText,
            style: TextStyle(
              color: iconColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            smallText,
            style: TextStyle(
              color: mutedColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// Category Item Widget
class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color cardColor;
  final Color textColor;

  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.cardColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Offer Card Widget
class _OfferCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String discount;
  final String description;
  final String validity;
  final Color primaryColor;
  final Color cardColor;
  final Color foregroundColor;
  final Color mutedColor;

  const _OfferCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    required this.discount,
    required this.description,
    required this.validity,
    required this.primaryColor,
    required this.cardColor,
    required this.foregroundColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: foregroundColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      discount,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      validity,
                      style: TextStyle(
                        color: mutedColor,
                        fontSize: 12,
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
                        'Apply',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// How It Works Item Widget
class _HowItWorksItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final Color foregroundColor;
  final Color mutedColor;

  const _HowItWorksItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.foregroundColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              color: mutedColor,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Pharmacy Card Widget
class _PharmacyCard extends StatelessWidget {
  final String name;
  final String address;
  final double rating;
  final String distance;
  final bool isOpen;
  final Color primaryColor;
  final Color accentColor;
  final Color cardColor;
  final Color foregroundColor;
  final Color mutedColor;

  const _PharmacyCard({
    required this.name,
    required this.address,
    required this.rating,
    required this.distance,
    required this.isOpen,
    required this.primaryColor,
    required this.accentColor,
    required this.cardColor,
    required this.foregroundColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.location_on,
              color: primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: accentColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: mutedColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      distance,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isOpen
                  ? Colors.lightBlue.withOpacity(0.2)
                  : mutedColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isOpen ? 'Open' : 'Closed',
              style: TextStyle(
                color: isOpen ? Colors.lightBlue : mutedColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
