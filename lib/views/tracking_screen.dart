import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mekitakizi/core/theme/theme.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  int _statusIndex = 1;
  int _etaMins = 18;
  Timer? _timer;

  static const List<_Step> _steps = [
    _Step(label: 'Placed',    icon: Icons.check_circle_outline, desc: 'Restaurant received your order'),
    _Step(label: 'Preparing', icon: Icons.restaurant_outlined,  desc: 'Your food is being prepared'),
    _Step(label: 'On the Way',icon: Icons.delivery_dining,      desc: 'Driver is heading to you'),
    _Step(label: 'Delivered', icon: Icons.home_outlined,        desc: 'Enjoy your meal!'),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted && _etaMins > 0) setState(() => _etaMins--);
    });
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) setState(() => _statusIndex = 2);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_statusIndex];
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

            // Driver pin
            Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.delivery_dining, color: Colors.white, size: 28),
                ),
                Container(width: 2, height: 12, color: AppTheme.primary.withValues(alpha: 0.6)),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ]),
            ),

            // Back button
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.bg.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _statusIndex >= 2 ? AppTheme.success : AppTheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _statusIndex == 3 ? 'Delivered!' : '$_etaMins min away',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ),

        // Bottom panel
        Expanded(
          flex: 4,
          child: Container(
            decoration: const BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20)],
            ),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Current status
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDim,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(step.icon, color: AppTheme.primary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.label,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          step.desc,
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ]),
                // ignore: prefer_const_constructors
                SizedBox(height: 20),

                // Progress stepper
                Row(
                  children: List.generate(_steps.length * 2 - 1, (i) {
                    if (i.isOdd) {
                      return Expanded(
                        child: Container(
                          height: 3,
                          color: i ~/ 2 < _statusIndex
                              ? AppTheme.primary
                              : AppTheme.border,
                        ),
                      );
                    }
                    final idx = i ~/ 2;
                    final done = idx <= _statusIndex;
                    return Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: done ? AppTheme.primary : AppTheme.border,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        done ? Icons.check : null,
                        color: Colors.white,
                        size: 14,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 6),
                Row(
                  children: _steps.map((s) => Expanded(
                    child: Text(
                      s.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppTheme.textMuted, fontSize: 9),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 20),

                // Driver info
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDim,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppTheme.primary.withValues(alpha: 0.3)),
                      ),
                      child: const Center(
                        child: Text('🧑', style: TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alex Rivera',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                          Row(children: [
                            Icon(Icons.star_rounded,
                                color: AppTheme.secondary, size: 13),
                            SizedBox(width: 3),
                            Text(
                              '4.97 · 2,341 deliveries',
                              style: TextStyle(
                                  color: AppTheme.textSecondary, fontSize: 12),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Row(children: [
                      _ActionBtn(icon: Icons.phone_outlined, onTap: () {}),
                      const SizedBox(width: 8),
                      _ActionBtn(icon: Icons.chat_bubble_outline, onTap: () {}),
                    ]),
                  ]),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'Order #ORD-1042',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class _Step {
  final String label, desc;
  final IconData icon;
  const _Step({required this.label, required this.icon, required this.desc});
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: AppTheme.primaryDim,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: AppTheme.primary, size: 18),
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
      ..strokeWidth = 10;
    canvas.drawLine(
        Offset(size.width * 0.2, 0), Offset(size.width * 0.3, size.height), road);
    canvas.drawLine(
        Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.55), road);
    canvas.drawLine(
        Offset(size.width * 0.7, 0), Offset(size.width * 0.6, size.height), road);
  }

  @override
  bool shouldRepaint(_) => false;
}
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const StatusChip({
    super.key,
    required this.label,
    required this.color, required String status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

