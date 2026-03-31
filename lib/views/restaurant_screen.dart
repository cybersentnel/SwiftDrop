// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_mekitakizi/core/theme/theme.dart';
import 'package:flutter_mekitakizi/core/constants/app_constants.dart';
import 'package:flutter_mekitakizi/views/cart_screen.dart';

class RestaurantScreen extends StatefulWidget {
  final Restaurant restaurant;
  final List<CartItem> cartItems;
  final VoidCallback onCartUpdated;

  const RestaurantScreen({
    super.key,
    required this.restaurant,
    required this.cartItems,
    required this.onCartUpdated,
  });

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  Map<String, List<MenuItem>> get _grouped {
    final map = <String, List<MenuItem>>{};
    for (final item in widget.restaurant.menu) {
      map.putIfAbsent(item.category, () => []).add(item);
    }
    return map;
  }

  int _quantityOf(String itemId) {
    final found = widget.cartItems.where((c) => c.item.id == itemId);
    return found.isEmpty ? 0 : found.first.quantity;
  }

  void _increment(MenuItem item) {
    setState(() {
      final idx = widget.cartItems.indexWhere((c) => c.item.id == item.id);
      if (idx >= 0) {
        widget.cartItems[idx].quantity++;
      } else {
        widget.cartItems.add(CartItem(item: item));
      }
      widget.onCartUpdated();
    });
  }

  void _decrement(MenuItem item) {
    setState(() {
      final idx = widget.cartItems.indexWhere((c) => c.item.id == item.id);
      if (idx >= 0) {
        widget.cartItems[idx].quantity--;
        if (widget.cartItems[idx].quantity == 0) {
          widget.cartItems.removeAt(idx);
        }
      }
      widget.onCartUpdated();
    });
  }

  int get _cartTotal => widget.cartItems.fold(0, (s, i) => s + i.quantity);
  double get _cartPrice => widget.cartItems.fold(0.0, (s, i) => s + i.total);

  @override
  Widget build(BuildContext context) {
    final grouped = _grouped;
    final catColor = AppTheme.categoryColors[widget.restaurant.category] ?? AppTheme.primary;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: catColor.withValues(alpha: 0.08),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Text(widget.restaurant.imageEmoji,
                        style: const TextStyle(fontSize: 80)),
                  ],
                ),
              ),
            ),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.bg.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text(
                        widget.restaurant.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    StarRating(rating: widget.restaurant.rating),
                  ]),

                  SizedBox(height: 8),

                  DeliveryInfo(
                    deliveryFee: widget.restaurant.deliveryFee,
                    distanceKm: widget.restaurant.distanceKm,
                    deliveryMins: widget.restaurant.deliveryMins,
                  ),
                  SizedBox(height: 12),
                  Text(
                    widget.restaurant.address,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  ),
                  SizedBox(height: 16),
                  AppDivider(),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),

          ...grouped.entries.expand((entry) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _MenuItemTile(
                      item: entry.value[i],
                      quantity: _quantityOf(entry.value[i].id),
                      onIncrement: () => _increment(entry.value[i]),
                      onDecrement: () => _decrement(entry.value[i]),
                    ),
                  ),
                  childCount: entry.value.length,
                ),
              ),
            ),
          ]),
          

          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      bottomNavigationBar: _cartTotal > 0
          ? _CartFooter(
              itemCount: _cartTotal,
              price: _cartPrice,
              deliveryFee: widget.restaurant.deliveryFee,
              onViewCart: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartScreen(
                    cartItems: widget.cartItems,
                    onCartUpdated: () => setState(() {}),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class StarRating extends StatelessWidget {
    final double rating;

    // ignore: use_key_in_widget_constructors, prefer_const_constructors_in_immutables
    StarRating({required this.rating});

    @override
    Widget build(BuildContext context) {
        return Row(
            children: List.generate(5, (i) {
                return Icon(
                    i < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                );
            }),
        );
    }
}
class DeliveryInfo extends StatelessWidget {
  final double deliveryFee;
  final double distanceKm;
  final int deliveryMins;

  // ignore: use_key_in_widget_constructors, prefer_const_constructors_in_immutables
  DeliveryInfo({
    required this.deliveryFee,
    required this.distanceKm,
    required this.deliveryMins,
  });
  
 @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.delivery_dining, size: 16, color: AppTheme.primary),
        SizedBox(width: 6),
        Text(
          '\$$deliveryFee • ${distanceKm}km • ${deliveryMins}min',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}
// ignore: use_key_in_widget_constructors
class AppDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(color: AppTheme.border, thickness: 1);
  }
}

class _MenuItemTile extends StatelessWidget {
  final MenuItem item;
  final int quantity;
  final VoidCallback onIncrement, onDecrement;

  const _MenuItemTile({
    required this.item,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: quantity > 0 ? AppTheme.primary.withValues(alpha: 0.35) : AppTheme.border,
        ),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(item.emoji, style: const TextStyle(fontSize: 36)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              if (item.isPopular)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryDim,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Popular',
                    style: TextStyle(
                      color: AppTheme.secondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ]),
            const SizedBox(height: 3),
            Text(
              item.description,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(children: [
              Text(
                '\$${item.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              if (quantity == 0)
                GestureDetector(
                  onTap: onIncrement,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDim,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4)),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
              else
                Row(children: [
                  _QtyBtn(icon: Icons.remove, onTap: onDecrement),
                  SizedBox(
                    width: 32,
                    child: Center(
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  _QtyBtn(icon: Icons.add, onTap: onIncrement),
                ]),
            ]),
          ]),
        ),
      ]),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}

class _CartFooter extends StatelessWidget {
  final int itemCount;
  final double price, deliveryFee;
  final VoidCallback onViewCart;

  const _CartFooter({
    required this.itemCount,
    required this.price,
    required this.deliveryFee,
    required this.onViewCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onViewCart,
          child: Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$itemCount',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
              ),
            ),
            const Spacer(),
            const Text('View Cart'),
            const Spacer(),
            Text(
              '\$${(price + deliveryFee).toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ]),
        ),
      ),
    );
  }
}
