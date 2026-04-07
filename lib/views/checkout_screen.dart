import 'package:flutter/material.dart';
import 'package:flutter_mekitakizi/core/theme/theme.dart';
import 'package:flutter_mekitakizi/views/tracking_screen.dart';


class CheckoutScreen extends StatefulWidget {
  final int total;
  const CheckoutScreen({super.key, required this.total});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late String address;

  
  int _paymentIndex = 0;
  int _timeIndex = 0;
  bool _placing = false;

  static const int _deliveryFee = 100;
  static const int _serviceFee = 50;

  final List<_Payment> _payments = const [
    _Payment(label: 'M-Pesa', icon: Icons.phone_android, subtitle: 'Pay via M-Pesa'),
    _Payment(label: 'Cash on Delivery', icon: Icons.payments_outlined, subtitle: 'Pay the driver'),
    _Payment(label: 'Visa •••• 4242', icon: Icons.credit_card, subtitle: 'Expires 09/27'),
  ];

  final List<String> _times = const [
    'ASAP (~20 min)',
    'In 30 minutes',
    'In 45 minutes',
    'Schedule for later',
  ];

  Future<void> _placeOrder() async {
    setState(() => _placing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TrackingScreen()),
      );
    }
  }

  int get _grandTotal => widget.total + _serviceFee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Delivery address
          _Section(
            title: 'Delivery Address',
            icon: Icons.location_on_outlined,
            iconColor: AppTheme.primary,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Heri Homes', style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 15,
                  color: AppTheme.textPrimary)),
              // ignore: prefer_const_constructors
              SizedBox(height: 2),
              const Text('Ideal Homes', style: TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13)),
              // ignore: prefer_const_constructors
              SizedBox(height: 10),
              const Text('Nairobi, Kenya', style: TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13)),

              const SizedBox(height: 10),

              GestureDetector(
                onTap: () async {
  final controller = TextEditingController();
  final result = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Change Address'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your delivery address',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, controller.text);
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );

  if (result != null && result.trim().isNotEmpty) {
    setState(() {
      address = result.trim();
    });
  }
  controller.dispose();
},
                child: const Text('Change address', style: TextStyle(
                    color: AppTheme.primary, fontSize: 13,
                    fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
          const SizedBox(height: 14),

          // Delivery time
          _Section(
            title: 'Delivery Time',
            icon: Icons.schedule_outlined,
            iconColor: AppTheme.secondary,
            child: Column(
              children: List.generate(_times.length, (i) => GestureDetector(
                onTap: () => setState(() => _timeIndex = i),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: _timeIndex == i ? AppTheme.primaryDim : AppTheme.bg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: _timeIndex == i
                            ? AppTheme.primary.withValues(alpha: 0.4)
                            : AppTheme.border),
                  ),
                  child: Row(children: [
                    Text(_times[i], style: TextStyle(
                        color: _timeIndex == i
                            ? AppTheme.primary : AppTheme.textPrimary,
                        fontWeight: _timeIndex == i
                            ? FontWeight.w700 : FontWeight.normal,
                        fontSize: 14)),
                    const Spacer(),
                    if (_timeIndex == i)
                      const Icon(Icons.check_circle,
                          color: AppTheme.primary, size: 18),
                  ]),
                ),
              )),
            ),
          ),
          const SizedBox(height: 14),

          // Payment
          _Section(
            title: 'Payment Method',
            icon: Icons.credit_card_outlined,
            iconColor: AppTheme.success,
            child: Column(
              children: List.generate(_payments.length, (i) => GestureDetector(
                onTap: () => setState(() => _paymentIndex = i),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _paymentIndex == i ? AppTheme.primaryDim : AppTheme.bg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: _paymentIndex == i
                            ? AppTheme.primary.withValues(alpha: 0.4)
                            : AppTheme.border),
                  ),
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(8)),
                      child: Icon(_payments[i].icon, size: 18,
                          color: _paymentIndex == i
                              ? AppTheme.primary : AppTheme.textSecondary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_payments[i].label, style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14,
                              color: _paymentIndex == i
                                  ? AppTheme.primary : AppTheme.textPrimary)),
                          Text(_payments[i].subtitle, style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 12)),
                        ])),
                    if (_paymentIndex == i)
                      const Icon(Icons.check_circle,
                          color: AppTheme.primary, size: 18),
                  ]),
                ),
              )),
            ),
          ),
          const SizedBox(height: 14),

          // Order summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(children: [
              const Row(children: [
                Icon(Icons.receipt_outlined, size: 16,
                    color: AppTheme.textSecondary),
                SizedBox(width: 8),
                Text('Order Summary', style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary, fontSize: 14)),
              ]),
              const SizedBox(height: 12),
              _SummaryRow('Subtotal',
                  'KSh ${widget.total - _deliveryFee}'),
              const SizedBox(height: 6),
              const _SummaryRow('Delivery fee', 'KSh $_deliveryFee'),
              const SizedBox(height: 6),
              const _SummaryRow('Service fee', 'KSh $_serviceFee'),
              const SizedBox(height: 10),
              const Divider(color: AppTheme.border),
              const SizedBox(height: 10),
              _SummaryRow('Total', 'KSh $_grandTotal', bold: true),
            ]),
          ),
          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 16, right: 16, top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 12,
        ),
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(top: BorderSide(color: AppTheme.border)),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _placing ? null : _placeOrder,
            child: _placing
                ? const SizedBox(width: 20, height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white))
                : Text('Place Order  ·  KSh $_grandTotal'),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  const _Section({
    required this.title, required this.icon,
    required this.iconColor, required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary, fontSize: 14)),
        ]),
        const SizedBox(height: 14),
        child,
      ]),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  const _SummaryRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(label, style: TextStyle(
          color: bold ? AppTheme.textPrimary : AppTheme.textSecondary,
          fontSize: bold ? 15 : 13,
          fontWeight: bold ? FontWeight.w800 : FontWeight.normal)),
      const Spacer(),
      Text(value, style: TextStyle(
          color: AppTheme.textPrimary,
          fontSize: bold ? 17 : 13,
          fontWeight: bold ? FontWeight.w900 : FontWeight.w600)),
    ]);
  }
}

class _Payment {
  final String label, subtitle;
  final IconData icon;
  const _Payment({required this.label, required this.icon, required this.subtitle});
}
