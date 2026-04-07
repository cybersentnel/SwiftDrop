// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_mekitakizi/core/theme/theme.dart';
import 'package:flutter_mekitakizi/core/constants/app_constants.dart';
import 'package:flutter_mekitakizi/views/tracking_screen.dart';
import 'package:intl/intl.dart';

 
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final active = SampleData.orders
        .where((o) => o.status == 'On the Way' || o.status == 'Preparing')
        .toList();
    final past = SampleData.orders
        .where((o) => o.status != 'On the Way' && o.status != 'Preparing')
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (active.isNotEmpty) ...[
            SizedBox(height: 12),
            ...active.map((o) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ActiveOrderCard(order: o),
            )),
            SizedBox(height: 20),
          ],
          
          SizedBox(height: 12),
          ...past.map((o) => Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: _PastOrderCard(order: o),
          )),
        ],
      ),
    );
  }
}

class _ActiveOrderCard extends StatelessWidget {
  final Order order;
  const _ActiveOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const TrackingScreen())),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1008), Color(0xFF221508)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('🛵', style: TextStyle(fontSize: 28)),
            SizedBox(width: 12),
            Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(order.restaurantName, style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 16,
                  color: AppTheme.textPrimary)),
              Text(order.id, style: TextStyle(
                  color: AppTheme.textSecondary, fontSize: 12)),
            ])),
          ]),
          SizedBox(height: 14),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppTheme.bg.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              Icon(Icons.schedule, color: AppTheme.primary, size: 16),
              SizedBox(width: 8),
              Text('Arrives in ~${order.estimatedMins} minutes',
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600, fontSize: 13)),
              const Spacer(),
              const Text('Track', style: TextStyle(
                  color: AppTheme.primary, fontWeight: FontWeight.w700,
                  fontSize: 13)),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_ios,
                  color: AppTheme.primary, size: 12),
            ]),
          ),
          const SizedBox(height: 12),
          Row(children: List.generate(4, (i) => Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: i <= 1 ? AppTheme.primary : AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ))),
          const SizedBox(height: 6),
          const Row(children: [
            Text('Placed', style: TextStyle(
                color: AppTheme.textSecondary, fontSize: 10)),
            Spacer(),
            Text('Preparing', style: TextStyle(
                color: AppTheme.primary, fontSize: 10,
                fontWeight: FontWeight.w700)),
            Spacer(),
            Text('On the Way', style: TextStyle(
                color: AppTheme.textMuted, fontSize: 10)),
            Spacer(),
            Text('Delivered', style: TextStyle(
                color: AppTheme.textMuted, fontSize: 10)),
          ]),
        ]),
      ),
    );
  }
}

class _PastOrderCard extends StatelessWidget {
  final Order order;
  const _PastOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(order.restaurantName, style: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 15,
              color: AppTheme.textPrimary))),
        ]),
        SizedBox(height: 4),
        Text(DateFormat('MMM d, y · h:mm a').format(order.placedAt),
            style: TextStyle(
                color: AppTheme.textSecondary, fontSize: 12)),
        SizedBox(height: 8),
        Text(order.itemNames.join(', '),
            style: TextStyle(
                color: AppTheme.textSecondary, fontSize: 13),
            maxLines: 1, overflow: TextOverflow.ellipsis),
        SizedBox(height: 10),
        Row(children: [
          Text('KSh ${order.total.toInt()}', style: TextStyle(
              fontWeight: FontWeight.w800, fontSize: 15,
              color: AppTheme.textPrimary)),
          SizedBox(width: 6),
          Text('· ${order.itemNames.length} items',
              style: TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13)),
          Spacer(),
          if (order.status == 'Delivered')
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primary,
                side: const BorderSide(color: AppTheme.primary),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                minimumSize: const Size(0, 32),
                textStyle: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700),
              ),
              child: const Text('Reorder'),
            ),
        ]),
      ]),
    );
  }
}
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const StatusChip({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}