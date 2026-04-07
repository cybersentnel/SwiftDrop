// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_mekitakizi/core/theme/theme.dart';
import 'package:flutter_mekitakizi/widgets/section_header.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  int _periodIndex = 0;

  static const List<String> _periods = ['Today', 'This Week', 'This Month'];

  static const List<int> _dailyEarnings = [
    320, 587, 472, 911, 638, 445, 472
  ];

  static const List<String> _dayLabels = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Today'
  ];

  static const List<_Delivery> _recentDeliveries = [
    _Delivery(name: 'Pizza Inn', address: 'Westlands', amount: 640, time: '2:14 PM', mins: 18),
    _Delivery(name: 'KFC', address: 'Kilimani', amount: 820, time: '12:48 PM', mins: 24),
    _Delivery(name: 'Chicken Inn', address: 'Karen', amount: 580, time: '11:02 AM', mins: 15),
    _Delivery(name: 'Galitos', address: 'Lavington', amount: 710, time: '10:20 AM', mins: 22),
  ];

  int get _totalEarnings {
    switch (_periodIndex) {
      case 0:
        return 4720;
      case 1:
        return 38490;
      default:
        return 124760;
    }
  }

  int get _deliveries {
    switch (_periodIndex) {
      case 0:
        return 6;
      case 1:
        return 48;
      default:
        return 187;
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxVal = _dailyEarnings.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(title: const Text('Earnings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // PERIOD SELECTOR
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: List.generate(_periods.length, (i) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _periodIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: i == _periodIndex
                            ? AppTheme.success.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _periods[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: i == _periodIndex
                              ? AppTheme.success
                              : AppTheme.textSecondary,
                          fontWeight: i == _periodIndex
                              ? FontWeight.w700
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 20),

          // MAIN EARNINGS CARD
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0E2018), Color(0xFF0E2A1E)],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppTheme.success.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _periods[_periodIndex],
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Ksh $_totalEarnings',
                  style: const TextStyle(
                    color: AppTheme.success,
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Icon(Icons.trending_up,
                        color: AppTheme.success, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '+12% vs last week',
                      style: TextStyle(
                        color: AppTheme.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    _EarningsStat(
                        label: 'Deliveries', value: '$_deliveries'),
                    Container(
                      width: 1,
                      height: 32,
                      color: AppTheme.success.withValues(alpha: 0.2),
                    ),
                    _EarningsStat(
                      label: 'Avg / delivery',
                      value:
                          'Ksh ${(_totalEarnings / _deliveries).toInt()}',
                    ),
                    Container(
                      width: 1,
                      height: 32,
                      color: AppTheme.success.withValues(alpha: 0.2),
                    ),
                    _EarningsStat(
                      label: 'Tips',
                      value:
                          'Ksh ${(_totalEarnings * 0.18).toInt()}',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // BAR CHART
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.border),
            ),
            child: SizedBox(
              height: 140,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(_dailyEarnings.length, (i) {
                  final isToday = i == _dailyEarnings.length - 1;
                  final h = (_dailyEarnings[i] / maxVal) * 120;

                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: h,
                          decoration: BoxDecoration(
                            color: isToday
                                ? AppTheme.success
                                : AppTheme.success.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _dayLabels[i],
                          style: TextStyle(
                            color: isToday
                                ? AppTheme.success
                                : AppTheme.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // NEXT PAYOUT
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: 'Next Payout'),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.account_balance_outlined,
                        color: AppTheme.success,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bank Mpesa · 0719327250',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Scheduled for Friday',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Ksh 38,490',
                      style: const TextStyle(
                        color: AppTheme.success,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // RECENT DELIVERIES
          SectionHeader(title: 'Recent Deliveries'),
          const SizedBox(height: 12),

          ..._recentDeliveries.map(
            (d) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _DeliveryRow(delivery: d),
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// STAT WIDGET
class _EarningsStat extends StatelessWidget {
  final String label;
  final String value;

  const _EarningsStat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// DELIVERY ROW
class _DeliveryRow extends StatelessWidget {
  final _Delivery delivery;

  const _DeliveryRow({required this.delivery});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.delivery_dining, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(delivery.name),
                Text(delivery.address),
              ],
            ),
          ),
          Text('Ksh ${delivery.amount}'),
        ],
      ),
    );
  }
}

// MODEL
class _Delivery {
  final String name;
  final String address;
  final String time;
  final int amount;
  final int mins;

  const _Delivery({
    required this.name,
    required this.address,
    required this.amount,
    required this.time,
    required this.mins,
  });
}