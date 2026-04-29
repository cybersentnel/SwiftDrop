import 'package:flutter/material.dart';
import 'package:flutter_mekitakizi/core/theme/theme.dart';
import 'package:flutter_mekitakizi/core/constants/app_constants.dart';

class ActiveDeliveryScreen extends StatefulWidget {
  final DriverOrder order;
  const ActiveDeliveryScreen({super.key, required this.order});

  @override
  State<ActiveDeliveryScreen> createState() => _ActiveDeliveryScreenState();
}

class _ActiveDeliveryScreenState extends State<ActiveDeliveryScreen> {
  // 0 = go to restaurant, 1 = go to customer, 2 = delivered
  int _phase = 0;

  static const List<_Phase> _phases = [
    _Phase(
      title: 'Head to Restaurant',
      subtitle: 'Pick up the order',
      icon: Icons.store_outlined,
      color: AppTheme.secondary,
    ),
    _Phase(
      title: 'Head to Customer',
      subtitle: 'Deliver the order',
      icon: Icons.delivery_dining,
      color: AppTheme.primary,
    ),
    _Phase(
      title: 'Order Delivered!',
      subtitle: 'Great work',
      icon: Icons.check_circle,
      color: AppTheme.success,
    ),
  ];

  void _next() {
    if (_phase < 2) {
      setState(() => _phase++);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final phase = _phases[_phase];

    return Scaffold(
      body: Column(children: [
        // Map area
        Expanded(
          flex: 5,
          child: Stack(children: [
            Container(
              color: const Color(0xFF141820),
              child: CustomPaint(painter: _MapPainter(), child: Container()),
            ),

            Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: phase.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: phase.color.withValues(alpha: 0.5),
                        blurRadius: 24,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: Icon(phase.icon, color: Colors.white, size: 28),
                ),
                Container(
                  width: 2,
                  height: 14,
                  color: phase.color.withValues(alpha: 0.5),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      color: phase.color, shape: BoxShape.circle),
                ),
              ]),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.bg.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back,
                      color: AppTheme.textPrimary, size: 20),
                ),
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.bg.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.navigation, color: phase.color, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    _phase == 0
                        ? widget.order.pickupAddress.split(',').first
                        : widget.order.dropoffAddress.split(',').first,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ),

        Expanded(
          flex: 5,
          child: Container(
            decoration: const BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            
              Row(
                children: List.generate(_phases.length * 2 - 1, (i) {
                  if (i.isOdd) {
                    return Expanded(
                      child: Container(
                        height: 2,
                        color: i ~/ 2 < _phase ? phase.color : AppTheme.border,
                      ),
                    );
                  }
                  final idx = i ~/ 2;
                  return Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: idx <= _phase ? _phases[idx].color : AppTheme.border,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      idx <= _phase ? Icons.check : null,
                      color: Colors.white,
                      size: 14,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              Row(children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: phase.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(phase.icon, color: phase.color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        phase.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        _phase == 0
                            ? widget.order.pickupAddress
                            : _phase == 1
                                ? widget.order.dropoffAddress
                                : 'Earnings updated',
                        style: const TextStyle(
                            color: AppTheme.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                PayoutBadge(amount: widget.order.payout),
              ]),
              const SizedBox(height: 18),

              if (_phase < 2) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.receipt_outlined,
                            size: 14, color: AppTheme.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          'Order for ${widget.order.customerName}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      ...widget.order.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(children: [
                            const Icon(Icons.circle,
                                size: 5, color: AppTheme.textMuted),
                            const SizedBox(width: 8),
                            Text(
                              item,
                              style: const TextStyle(
                                  color: AppTheme.textSecondary, fontSize: 12),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],
              if (_phase == 1) ...[
                Row(children: [
                  Expanded(
                    child: _ContactBtn(
                      icon: Icons.phone_outlined,
                      label: 'Call Customer',
                      color: AppTheme.accent,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ContactBtn(
                      icon: Icons.chat_bubble_outline,
                      label: 'Message',
                      color: AppTheme.success,
                      onTap: () {},
                    ),
                  ),
                ]),
                const SizedBox(height: 14),
              ],

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(backgroundColor: phase.color),
                  child: Text(
                    _phase == 0
                        ? 'Confirm Pickup'
                        : _phase == 1
                            ? 'Confirm Delivery'
                            : 'Back to Orders',
                  ),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _Phase {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  const _Phase({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class _ContactBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ContactBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ]),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = const Color(0xFF1C2030)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final road = Paint()
      ..color = const Color(0xFF252B3B)
      ..strokeWidth = 12;
    canvas.drawLine(
        Offset(size.width * 0.15, 0), Offset(size.width * 0.25, size.height), road);
    canvas.drawLine(
        Offset(0, size.height * 0.35), Offset(size.width, size.height * 0.5), road);
    canvas.drawLine(
        Offset(size.width * 0.65, 0), Offset(size.width * 0.75, size.height), road);
    canvas.drawLine(
        Offset(0, size.height * 0.75), Offset(size.width, size.height * 0.85), road);
  }

  @override
  bool shouldRepaint(_) => false;
}
 class PayoutBadge extends StatelessWidget {
  final double amount;

  const PayoutBadge({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green),
      ),
      child: Text(
        'Ksh${amount.toStringAsFixed(2)}',
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}