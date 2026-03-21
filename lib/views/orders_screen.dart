// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_mekitakizi/core/theme/theme.dart';
import 'package:flutter_mekitakizi/core/constants/app_constants.dart';
import 'package:flutter_mekitakizi/views/tracking_screen.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final active = SampleData.orders
        .where((o) => o.status == 'On the Way' || o.status == 'Preparing')
        .toList();

    final past = SampleData.orders
        .where((o) => o.status != 'On the Way' && o.status != 'Preparing')
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('My Orders')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          if (active.isNotEmpty) ...[
            SectionHeader(title: 'Active Orders'),
            SizedBox(height: 12),
            ...active.map(
              (o) => Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: _ActiveOrderCard(order: o),
              ),
            ),
            SizedBox(height: 20),
          ],
          SectionHeader(
            title: 'Past Orders',
            action: 'Filter',
            onAction: () {},
          ),
          SizedBox(height: 12),
          ...past.map(
            (o) => Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: _PastOrderCard(order: o),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveOrderCard extends StatelessWidget {
  final Order order;
  _ActiveOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TrackingScreen()),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1008), Color(0xFF221508)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.4),
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('🛵', style: TextStyle(fontSize: 28)),
            SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  order.restaurantName,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  order.id,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ]),
            ),
            StatusChip(status: order.status),
          ]),
          SizedBox(height: 14),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.bg.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(children: [
              Icon(Icons.schedule, color: AppTheme.primary, size: 16),
              SizedBox(width: 8),
              Text(
                'Arrives in ${order.estimatedMins} minutes',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Spacer(),
              Text(
                'Track',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _PastOrderCard extends StatelessWidget {
  final Order order;
  _PastOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text(
              order.restaurantName,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          StatusChip(status: order.status),
        ]),
        SizedBox(height: 4),
        Text(
          DateFormat('MMM d, y · h:mm a').format(order.placedAt),
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
        ),
      ]),
    );
  }
}
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  // ignore: use_key_in_widget_constructors
  SectionHeader({required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        Spacer(),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class StatusChip extends StatelessWidget {
  final String status;

  // ignore: use_key_in_widget_constructors
  StatusChip({required this.status});

  Color get color {
    switch (status) {
      case 'Preparing':
        return Colors.orange;
      case 'On the Way':
        return AppTheme.primary;
      case 'Delivered':
        return AppTheme.success;
      default:
        return AppTheme.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}