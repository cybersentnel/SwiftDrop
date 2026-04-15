// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_mekitakizi/core/theme/theme.dart';
import 'package:flutter_mekitakizi/core/constants/app_constants.dart';
import 'package:flutter_mekitakizi/views/restaurant_screen.dart';
import 'package:flutter_mekitakizi/views/orders_screen.dart';
import 'package:flutter_mekitakizi/views/cart_screen.dart';

class CategoryPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CategoryPill({super.key, 
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppTheme.primary : AppTheme.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppTheme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  String _selectedCategory = 'All';
  final List<CartItem> _cartItems = [];

  final List<String> _categories = [
    'All', 'Burgers', 'Pizza', 'Sushi', 'Indian', 'Healthy', 'Coffee',
  ];

  List<Restaurant> get _filtered {
    if (_selectedCategory == 'All') return SampleData.restaurants;
    return SampleData.restaurants
        .where((r) => r.category == _selectedCategory)
        .toList();
  }

  int get _cartCount => _cartItems.fold(0, (s, i) => s + i.quantity);

  void _goToRestaurant(Restaurant r) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => RestaurantScreen(
        restaurant: r,
        cartItems: _cartItems,
        onCartUpdated: () => setState(() {}),
      ),
    ));
  }

  void _goToCart() {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => CartScreen(
        cartItems: _cartItems,
        onCartUpdated: () => setState(() {}),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _BrowseTab(
        categories: _categories,
        selectedCategory: _selectedCategory,
        filtered: _filtered,
        cartCount: _cartCount,
        onCategoryChange: (c) => setState(() => _selectedCategory = c),
        onRestaurantTap: _goToRestaurant,
        onCartTap: _goToCart,
      ),
      OrdersScreen(),
      _ProfileTab(),
    ];

    return Scaffold(
      body: screens[_navIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: _navIndex,
          onTap: (i) => setState(() => _navIndex = i),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Discover'),
            BottomNavigationBarItem(
              icon: Stack(children: [
                Icon(Icons.receipt_long_outlined),
                if (SampleData.orders.any((o) => o.status == 'On the Way'))
                  Positioned(top: 0, right: 0, child: Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                        color: AppTheme.primary, shape: BoxShape.circle),
                  )),
              ]),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class _BrowseTab extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final List<Restaurant> filtered;
  final int cartCount;
  final ValueChanged<String> onCategoryChange;
  final ValueChanged<Restaurant> onRestaurantTap;
  final VoidCallback onCartTap;

  const _BrowseTab({
    required this.categories, required this.selectedCategory,
    required this.filtered, required this.cartCount,
    required this.onCategoryChange, required this.onRestaurantTap,
    required this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverAppBar(
        floating: true,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Delivering to', style: TextStyle(
              color: AppTheme.textSecondary, fontSize: 12,
              fontWeight: FontWeight.normal)),
          Row(children: [
            Text('Nairobi, Kenya', style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary)),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 18, color: AppTheme.primary),
          ]),
        ]),
        actions: [
          Stack(children: [
            IconButton(
                icon: Icon(Icons.shopping_bag_outlined),
                onPressed: onCartTap),
            if (cartCount > 0)
              Positioned(top: 6, right: 6, child: Container(
                width: 16, height: 16,
                decoration: BoxDecoration(
                    color: AppTheme.primary, shape: BoxShape.circle),
                child: Center(child: Text('$cartCount',
                    style: TextStyle(color: Colors.white,
                        fontSize: 9, fontWeight: FontWeight.bold))),
              )),
          ]),
        ],
      ),

      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Search bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(children: [
                Icon(Icons.search, color: AppTheme.textMuted, size: 20),
                SizedBox(width: 10),
                Text('Search restaurants, dishes...',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 14)),
              ]),
            ),
            SizedBox(height: 20),

            // Featured banner
            _FeaturedBanner(
              restaurant: SampleData.restaurants.firstWhere((r) => r.isFeatured),
              onTap: (r) => onRestaurantTap(r),
            ),
            SizedBox(height: 20),

            SizedBox(height: 12),
          ]),
        ),
      ),

      SliverToBoxAdapter(
        child: SizedBox(
          height: 40,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => SizedBox(width: 8),
            itemBuilder: (_, i) => CategoryPill(
              label: categories[i],
              selected: categories[i] == selectedCategory,
              onTap: () => onCategoryChange(categories[i]),
            ),
          ),
        ),
      ),

      SliverToBoxAdapter(child: SizedBox(height: 20)),
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverToBoxAdapter(

        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 12)),

      SliverPadding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 100),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, i) => Padding(
              padding: EdgeInsets.only(bottom: 14),
              child: _RestaurantCard(
                restaurant: filtered[i],
                onTap: () => onRestaurantTap(filtered[i]),
              ),
            ),
            childCount: filtered.length,
          ),
        ),
      ),
    ]);
  }
}

class _FeaturedBanner extends StatelessWidget {
  final Restaurant restaurant;
  final ValueChanged<Restaurant> onTap;
  const _FeaturedBanner({required this.restaurant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(restaurant),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1008), Color(0xFF2A180A)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
        ),
        child: Stack(children: [
          Positioned(right: 20, top: 0, bottom: 0,
            child: Center(child: Text(restaurant.imageEmoji,
                style: TextStyle(fontSize: 72)))),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text('FEATURED', style: TextStyle(
                      color: Colors.white, fontSize: 10,
                      fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                ),
                SizedBox(height: 8),
                Text(restaurant.name, style: TextStyle(
                    color: AppTheme.textPrimary, fontSize: 20,
                    fontWeight: FontWeight.w800)),
                SizedBox(height: 6),
                DeliveryInfo(
                  deliveryFee: restaurant.deliveryFee,
                  distanceKm: restaurant.distanceKm,
                  deliveryMins: restaurant.deliveryMins,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;
  const _RestaurantCard({required this.restaurant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final catColor =
        AppTheme.categoryColors[restaurant.category] ?? AppTheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 130,
            decoration: BoxDecoration(
              color: catColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(children: [
              Center(child: Text(restaurant.imageEmoji,
                  style: TextStyle(fontSize: 64))),
              Positioned(top: 10, right: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: catColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(restaurant.category, style: TextStyle(
                      color: catColor, fontSize: 11,
                      fontWeight: FontWeight.w700)),
                )),
            ]),
          ),
          Padding(
            padding: EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(children: [
                Expanded(child: Text(restaurant.name, style: TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 15,
                    color: AppTheme.textPrimary))),
                StarRating(rating: restaurant.rating),
              ]),
              SizedBox(height: 6),
              DeliveryInfo(
                deliveryFee: restaurant.deliveryFee,
                distanceKm: restaurant.distanceKm,
                deliveryMins: restaurant.deliveryMins,
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Saved Addresses', Icons.location_on_outlined),
      ('Payment Methods', Icons.credit_card_outlined),
      ('Promo Codes', Icons.local_offer_outlined),
      ('Notifications', Icons.notifications_outlined),
      ('Help & Support', Icons.help_outline),
      ('Settings', Icons.settings_outlined),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Center(child: Column(children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.4), width: 2),
            ),
            child: Center(
                child: Text('👤', style: TextStyle(fontSize: 36))),
          ),
          SizedBox(height: 12),
          Text('Doras Pesian', style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary)),
          Text('pesiandoras@gmail.com',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
        ])),
        SizedBox(height: 28),
        ...items.map((item) => Container(
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: ListTile(
            leading: Icon(item.$2, color: AppTheme.textSecondary, size: 20),
            title: Text(item.$1, style: TextStyle(
                color: AppTheme.textPrimary, fontSize: 14,
                fontWeight: FontWeight.w500)),
            trailing: Icon(Icons.chevron_right,
                color: AppTheme.textMuted, size: 18),
            onTap: () {},
          ),
        )),
      ]),
    );
  }
}