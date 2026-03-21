// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_mekitakizi/core/theme/theme.dart';
import 'package:flutter_mekitakizi/core/constants/app_constants.dart';
import 'package:flutter_mekitakizi/views/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final VoidCallback onCartUpdated;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onCartUpdated,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoCtrl = TextEditingController();
  String? _appliedPromo;
  bool _promoError = false;

  double get _subtotal => widget.cartItems.fold(0.0, (s, i) => s + i.total);
  double get _deliveryFee => 1.99;
  double get _discount => _appliedPromo != null ? _subtotal * 0.1 : 0;
  double get _total => _subtotal + _deliveryFee - _discount;

  void _applyPromo() {
    final code = _promoCtrl.text.trim().toUpperCase();
    setState(() {
      if (code == 'SWIFT10') {
        _appliedPromo = code;
        _promoError = false;
      } else {
        _promoError = true;
        _appliedPromo = null;
      }
    });
  }

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart (${widget.cartItems.fold(0, (s, i) => s + i.quantity)} items)'),
      ),
      body: widget.cartItems.isEmpty
          ? const _EmptyCart()
          : Column(children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...widget.cartItems.map(
                      (ci) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _CartItemTile(
                          cartItem: ci,
                          onIncrement: () => setState(() {
                            ci.quantity++;
                            widget.onCartUpdated();
                          }),
                          onDecrement: () => setState(() {
                            ci.quantity--;
                            if (ci.quantity == 0) {
                              widget.cartItems.remove(ci);
                              widget.onCartUpdated();
                            }
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Promo code
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(children: [
                            Icon(Icons.local_offer_outlined,
                                color: AppTheme.primary, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Promo Code',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                          ]),
                          const SizedBox(height: 10),
                          if (_appliedPromo != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.successDim,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(children: [
                                const Icon(Icons.check_circle,
                                    color: AppTheme.success, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  '$_appliedPromo — 10% off applied!',
                                  style: const TextStyle(
                                    color: AppTheme.success,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => setState(() => _appliedPromo = null),
                                  child: const Icon(Icons.close,
                                      color: AppTheme.success, size: 16),
                                ),
                              ]),
                            )
                          else
                            Row(children: [
                              Expanded(
                                child: TextField(
                                  controller: _promoCtrl,
                                  textCapitalization: TextCapitalization.characters,
                                  decoration: InputDecoration(
                                    hintText: 'Enter promo code',
                                    errorText:
                                        _promoError ? 'Invalid. Try SWIFT10' : null,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: _applyPromo,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(0, 44),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 20),
                                ),
                                child: const Text('Apply'),
                              ),
                            ]),
                        ],
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
                        _SummaryRow(
                            label: 'Subtotal',
                            value: '\$${_subtotal.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        _SummaryRow(
                            label: 'Delivery fee',
                            value: '\$${_deliveryFee.toStringAsFixed(2)}'),
                        if (_discount > 0) ...[
                          const SizedBox(height: 8),
                          _SummaryRow(
                            label: 'Promo discount',
                            value: '-\$${_discount.toStringAsFixed(2)}',
                            valueColor: AppTheme.success,
                          ),
                        ],
                        SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        _SummaryRow(
                          label: 'Total',
                          value: '\$${_total.toStringAsFixed(2)}',
                          isBold: true,
                        ),
                      ]),
                    ),
                    const SizedBox(height: 14),

                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Add a note for the restaurant...',
                        prefixIcon: Icon(Icons.notes_outlined, size: 18),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),

              // Checkout button
              Container(
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
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CheckoutScreen(total: _total)),
                    ),
                    child: Text(
                        'Proceed to Checkout  ·  \$${_total.toStringAsFixed(2)}'),
                  ),
                ),
              ),
            ]),
    );
  }
}

class AppDivider {
  const AppDivider();
}

class _CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onIncrement, onDecrement;

  const _CartItemTile({
    required this.cartItem,
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
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(children: [
        Text(cartItem.item.emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              cartItem.item.name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '\$${cartItem.item.price.toStringAsFixed(2)} each',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
          ]),
        ),
        Row(children: [
          _QtyBtn(icon: Icons.remove, onTap: onDecrement),
          SizedBox(
            width: 32,
            child: Center(
              child: Text(
                '${cartItem.quantity}',
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
        const SizedBox(width: 12),
        Text(
          '\$${cartItem.total.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            fontSize: 14,
          ),
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
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: AppTheme.primaryDim,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: AppTheme.primary, size: 14),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        label,
        style: TextStyle(
          color: isBold ? AppTheme.textPrimary : AppTheme.textSecondary,
          fontSize: isBold ? 15 : 13,
          fontWeight: isBold ? FontWeight.w800 : FontWeight.normal,
        ),
      ),
      const Spacer(),
      Text(
        value,
        style: TextStyle(
          color: valueColor ?? (isBold ? AppTheme.textPrimary : AppTheme.textSecondary),
          fontSize: isBold ? 17 : 13,
          fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
        ),
      ),
    ]);
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('🛒', style: TextStyle(fontSize: 64)),
        SizedBox(height: 16),
        Text(
          'Your cart is empty',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Add items from a restaurant to get started',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
        ),
      ]),
    );
  }
}
