// ignore_for_file: prefer_const_declarations

import 'package:flutter/material.dart';
import 'package:flutter_mekitakizi/core/theme/theme.dart';
import 'package:flutter_mekitakizi/core/constants/app_constants.dart';
import 'package:flutter_mekitakizi/views/orders_screen.dart';
import 'package:flutter_mekitakizi/views/role_select_screen.dart';
import 'package:flutter_mekitakizi/driver/active_delivery_screen.dart';
import 'package:flutter_mekitakizi/driver/earnings_screen.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  int _navIndex = 0;
  bool _isOnline = true;
  late List<DriverOrder> _orders;

  @override
  void initState() {
    super.initState();
    _orders = List<DriverOrder>.from(SampleData.availableOrders);
  }

  void _acceptOrder(DriverOrder o) {
    setState(() => _orders.remove(o));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ActiveDeliveryScreen(order: o)),
    );
  }

  void _declineOrder(DriverOrder o) => setState(() => _orders.remove(o));

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _OrdersTab(
        isOnline: _isOnline,
        orders: _orders,
        onToggleOnline: () => setState(() => _isOnline = !_isOnline),
        onAccept: _acceptOrder,
        onDecline: _declineOrder,
      ),
      const EarningsScreen(),
      _DriverProfileTab(
        onSwitchRole: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RoleSelectScreen()),
        ),
      ),
    ];

    return Scaffold(
      body: screens[_navIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: _navIndex,
          onTap: (i) => setState(() => _navIndex = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(Icons.list_alt),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Earnings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
class _OrdersTab extends StatelessWidget {
  final bool isOnline;
  final List<DriverOrder> orders;
  final VoidCallback onToggleOnline;
  final ValueChanged<DriverOrder> onAccept, onDecline;

  const _OrdersTab({
    required this.isOnline,
    required this.orders,
    required this.onToggleOnline,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverAppBar(
        pinned: true,
        title: Row(children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.delivery_dining, color: AppTheme.success, size: 18),
          ),
          const SizedBox(width: 10),
          const Text('SwiftDrop Driver'),
        ]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: onToggleOnline,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isOnline ? AppTheme.successDim : AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isOnline
                        ? AppTheme.success.withValues(alpha: 0.5)
                        : AppTheme.border,
                  ),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isOnline ? AppTheme.success : AppTheme.textMuted,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: isOnline ? AppTheme.success : AppTheme.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),

      // Status banner
      SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isOnline ? AppTheme.success.withValues(alpha: 0.08) : AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isOnline ? AppTheme.success.withValues(alpha: 0.3) : AppTheme.border,
            ),
          ),
          child: Row(children: [
            Text(isOnline ? '🟢' : '🔴', style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  isOnline ? "You're online" : "You're offline",
                  style: TextStyle(
                    color: isOnline ? AppTheme.success : AppTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  isOnline
                      ? '${orders.length} orders available nearby'
                      : 'Go online to start receiving orders',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12),
                ),
              ]),
            ),
            if (isOnline)
              const Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(
                  'sh1,500',
                  style: TextStyle(
                    color: AppTheme.success,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                Text('Today',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              ]),
          ]),
        ),
      ),

      if (isOnline && orders.isNotEmpty) ...[
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: SectionHeader(title: 'Available Orders'),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _DriverOrderCard(
                  order: orders[i],
                  onAccept: () => onAccept(orders[i]),
                  onDecline: () => onDecline(orders[i]),
                ),
              ),
              childCount: orders.length,
            ),
          ),
        ),
      ] else if (isOnline)
        const SliverFillRemaining(
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('🛵', style: TextStyle(fontSize: 56)),
              SizedBox(height: 16),
              Text('No orders right now',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary)),
              SizedBox(height: 6),
              Text('Hang tight — new orders will appear here',
                  style: TextStyle(color: AppTheme.textSecondary)),
            ]),
          ),
        )
      else
        const SliverFillRemaining(
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('💤', style: TextStyle(fontSize: 56)),
              SizedBox(height: 16),
              Text("You're offline",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary)),
              SizedBox(height: 6),
              Text('Tap Online to start receiving deliveries',
                  style: TextStyle(color: AppTheme.textSecondary)),
            ]),
          ),
        ),
    ]);
  }
}

// ── Driver order card ─────────────────────────────────────
class _DriverOrderCard extends StatelessWidget {
  final DriverOrder order;
  final VoidCallback onAccept, onDecline;

  const _DriverOrderCard({
    required this.order,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(
                  order.pickupName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              PayoutBadge(amount: order.payout),
            ]),
            const SizedBox(height: 12),

            // Route
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                      color: AppTheme.primary, shape: BoxShape.circle),
                ),
                Container(width: 2, height: 28, color: AppTheme.border),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                      color: AppTheme.success, shape: BoxShape.circle),
                ),
              ]),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    order.pickupAddress,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    order.dropoffAddress,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
              ),
            ]),
            const SizedBox(height: 12),

            Row(children: [
              _Stat(icon: Icons.near_me_outlined, label: '${order.distanceKm} km'),
              const SizedBox(width: 16),
              _Stat(icon: Icons.schedule_outlined, label: '~${order.estimatedMins} min'),
              const SizedBox(width: 16),
              _Stat(icon: Icons.person_outline, label: order.customerName),
            ]),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.bg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(children: [
                const Icon(Icons.receipt_outlined,
                    size: 14, color: AppTheme.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.items.join(' · '),
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ]),
            ),
          ]),
        ),

        // Accept / Decline
        Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppTheme.border)),
          ),
          child: Row(children: [
            Expanded(
              child: TextButton(
                onPressed: onDecline,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(18)),
                  ),
                ),
                child: const Text(
                  'Decline',
                  style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Container(width: 1, height: 48, color: AppTheme.border),
            Expanded(
              child: TextButton(
                onPressed: onAccept,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(18)),
                  ),
                ),
                child: const Text(
                  'Accept',
                  style: TextStyle(
                    color: AppTheme.success,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Stat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 13, color: AppTheme.textSecondary),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
    ]);
  }
}

class _DriverProfileTab extends StatelessWidget {
  final VoidCallback onSwitchRole;
  const _DriverProfileTab({required this.onSwitchRole});

  @override
  Widget build(BuildContext context) {
    final items = const [
      ('Vehicle Info', Icons.two_wheeler_outlined),
      ('Bank Account', Icons.account_balance_outlined),
      ('Documents', Icons.badge_outlined),
      ('Notifications', Icons.notifications_outlined),
      ('Help & Support', Icons.help_outline),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Driver Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.successDim,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppTheme.success.withValues(alpha: 0.4), width: 2),
                ),
                child: const Center(
                  child: Text('🧑', style: TextStyle(fontSize: 36)),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Felix Reyian',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Text(
                'Driver since March 2023',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 10),
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.star_rounded, color: AppTheme.secondary, size: 18),
                SizedBox(width: 4),
                Text(
                  '4.97',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                  ),
                ),
                Text(
                  ' · 2,000 deliveries',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                ),
              ]),
            ]),
          ),
          const SizedBox(height: 24),
          ...items.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: ListTile(
                leading: Icon(item.$2, color: AppTheme.textSecondary, size: 20),
                title: Text(
                  item.$1,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right,
                    color: AppTheme.textMuted, size: 18),
                onTap: () {},
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: ListTile(
              leading: const Icon(Icons.swap_horiz,
                  color: AppTheme.primary, size: 20),
              title: const Text(
                'Switch to Customer',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: onSwitchRole,
            ),
          ),
        ],
      ),
    );
  }
}
