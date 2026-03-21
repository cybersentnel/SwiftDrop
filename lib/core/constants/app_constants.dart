

// ignore_for_file: prefer_const_constructors

class Restaurant {
  final String id, name, category, imageEmoji, address;
  final double rating, deliveryFee, distanceKm;
  final int deliveryMins;
  final bool isOpen, isFeatured;
  final List<MenuItem> menu;

  const Restaurant({
    required this.id,
    required this.name,
    required this.category,
    required this.imageEmoji,
    required this.address,
    required this.rating,
    required this.deliveryFee,
    required this.distanceKm,
    required this.deliveryMins,
    this.isOpen = true,
    this.isFeatured = false,
    required this.menu,
  });
}

class MenuItem {
  final String id, name, description, category;
  final double price;
  final String emoji;
  final bool isPopular;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.emoji,
    this.isPopular = false,
  });
}

class CartItem {
  final MenuItem item;
  int quantity;
  CartItem({required this.item, this.quantity = 1});
  double get total => item.price * quantity;
}

class Order {
  final String id, restaurantName, status, address;
  final double total;
  final DateTime placedAt;
  final List<String> itemNames;
  final int estimatedMins;

  const Order({
    required this.id,
    required this.restaurantName,
    required this.status,
    required this.address,
    required this.total,
    required this.placedAt,
    required this.itemNames,
    required this.estimatedMins,
  });
}

class DriverOrder {
  final String id, pickupName, pickupAddress, dropoffAddress, customerName;
  final double payout, distanceKm;
  final int estimatedMins;
  final List<String> items;

  const DriverOrder({
    required this.id,
    required this.pickupName,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.customerName,
    required this.payout,
    required this.distanceKm,
    required this.estimatedMins,
    required this.items,
  });
}


class SampleData {
  static final List<Restaurant> restaurants = [
    Restaurant(
      id: 'r1',
      name: 'Flame Burger Co.',
      category: 'Burgers',
      imageEmoji: '🍔',
      address: '12 Oak Street',
      rating: 4.8,
      deliveryFee: 1.99,
      distanceKm: 0.8,
      deliveryMins: 20,
      isFeatured: true,
      menu: const [
        MenuItem(id: 'm1', name: 'Classic Smash Burger', description: 'Double smash patty, American cheese, pickles, special sauce', category: 'Burgers', price: 12.99, emoji: '🍔', isPopular: true),
        MenuItem(id: 'm2', name: 'BBQ Bacon Burger', description: 'Crispy bacon, BBQ sauce, caramelised onions, cheddar', category: 'Burgers', price: 14.99, emoji: '🥓'),
        MenuItem(id: 'm3', name: 'Crispy Chicken Burger', description: 'Fried chicken thigh, slaw, spicy mayo', category: 'Burgers', price: 13.49, emoji: '🍗', isPopular: true),
        MenuItem(id: 'm4', name: 'Loaded Fries', description: 'Crinkle fries, cheese sauce, jalapeños, chives', category: 'Sides', price: 6.99, emoji: '🍟'),
        MenuItem(id: 'm5', name: 'Onion Rings', description: 'Beer-battered, served with ranch', category: 'Sides', price: 4.99, emoji: '🧅'),
        MenuItem(id: 'm6', name: 'Vanilla Shake', description: 'Thick hand-spun milkshake', category: 'Drinks', price: 5.99, emoji: '🥛'),
        MenuItem(id: 'm7', name: 'Craft Lemonade', description: 'Fresh squeezed, mint infused', category: 'Drinks', price: 3.99, emoji: '🍋'),
      ],
    ),
    Restaurant(
      id: 'r2',
      name: 'Tokyo Sushi Bar',
      category: 'Sushi',
      imageEmoji: '🍣',
      address: '47 River Lane',
      rating: 4.9,
      deliveryFee: 2.99,
      distanceKm: 1.4,
      deliveryMins: 30,
      isFeatured: true,
      menu: const [
        MenuItem(id: 'm8', name: 'Salmon Nigiri (6pc)', description: 'Fresh Atlantic salmon, seasoned rice', category: 'Nigiri', price: 14.99, emoji: '🍣', isPopular: true),
        MenuItem(id: 'm9', name: 'Dragon Roll', description: 'Shrimp tempura, avocado, eel sauce', category: 'Rolls', price: 17.99, emoji: '🥑', isPopular: true),
        MenuItem(id: 'm10', name: 'Miso Soup', description: 'Tofu, wakame, spring onion', category: 'Sides', price: 3.99, emoji: '🥣'),
        MenuItem(id: 'm11', name: 'Edamame', description: 'Salted steamed edamame', category: 'Sides', price: 4.99, emoji: '🫘'),
        MenuItem(id: 'm12', name: 'Matcha Ice Cream', description: 'Premium Japanese matcha, 2 scoops', category: 'Dessert', price: 5.99, emoji: '🍵'),
      ],
    ),
    Restaurant(
      id: 'r3',
      name: 'Spice Garden',
      category: 'Indian',
      imageEmoji: '🍛',
      address: '88 Curry Road',
      rating: 4.7,
      deliveryFee: 0.99,
      distanceKm: 2.1,
      deliveryMins: 35,
      menu: const [
        MenuItem(id: 'm13', name: 'Butter Chicken', description: 'Tender chicken in rich tomato cream sauce', category: 'Mains', price: 15.99, emoji: '🍛', isPopular: true),
        MenuItem(id: 'm14', name: 'Lamb Biryani', description: 'Slow cooked lamb, saffron basmati, raita', category: 'Mains', price: 17.99, emoji: '🍚', isPopular: true),
        MenuItem(id: 'm15', name: 'Garlic Naan (3pc)', description: 'Tandoor-baked, garlic butter', category: 'Bread', price: 5.99, emoji: '🫓'),
        MenuItem(id: 'm16', name: 'Mango Lassi', description: 'Chilled yoghurt, Alphonso mango', category: 'Drinks', price: 4.49, emoji: '🥭'),
      ],
    ),
    Restaurant(
      id: 'r4',
      name: 'Slice & Co.',
      category: 'Pizza',
      imageEmoji: '🍕',
      address: '5 Marina Blvd',
      rating: 4.5,
      deliveryFee: 1.49,
      distanceKm: 0.5,
      deliveryMins: 25,
      menu: const [
        MenuItem(id: 'm17', name: 'Margherita', description: 'San Marzano tomato, buffalo mozzarella, basil', category: 'Pizzas', price: 13.99, emoji: '🍕', isPopular: true),
        MenuItem(id: 'm18', name: 'Pepperoni Fire', description: 'Double pepperoni, chilli flakes, honey drizzle', category: 'Pizzas', price: 15.99, emoji: '🌶️', isPopular: true),
        MenuItem(id: 'm19', name: 'Truffle Mushroom', description: 'Wild mushrooms, truffle oil, parmesan', category: 'Pizzas', price: 16.99, emoji: '🍄'),
        MenuItem(id: 'm20', name: 'Tiramisu', description: 'Classic Italian, espresso soaked ladyfingers', category: 'Desserts', price: 7.99, emoji: '🍮'),
      ],
    ),
    Restaurant(
      id: 'r5',
      name: 'The Green Bowl',
      category: 'Healthy',
      imageEmoji: '🥗',
      address: '21 Health Ave',
      rating: 4.6,
      deliveryFee: 2.49,
      distanceKm: 1.8,
      deliveryMins: 20,
      menu: const [
        MenuItem(id: 'm21', name: 'Acai Power Bowl', description: 'Acai, granola, banana, honey, coconut flakes', category: 'Bowls', price: 13.99, emoji: '🫐', isPopular: true),
        MenuItem(id: 'm22', name: 'Grilled Salmon Salad', description: 'Baby spinach, quinoa, avocado, lemon dressing', category: 'Salads', price: 16.99, emoji: '🥗', isPopular: true),
        MenuItem(id: 'm23', name: 'Green Detox Juice', description: 'Kale, cucumber, apple, ginger, lemon', category: 'Drinks', price: 6.99, emoji: '🥤'),
      ],
    ),
  ];

  static final List<Order> orders = [
    Order(
      id: 'ORD-1042',
      restaurantName: 'Flame Burger Co.',
      status: 'On the Way',
      address: '34 Maple Drive, Apt 4B',
      total: 29.96,
      placedAt: DateTime.now().subtract(const Duration(minutes: 18)),
      itemNames: const ['Classic Smash Burger', 'Loaded Fries', 'Craft Lemonade'],
      estimatedMins: 7,
    ),
    Order(
      id: 'ORD-1039',
      restaurantName: 'Tokyo Sushi Bar',
      status: 'Delivered',
      address: '34 Maple Drive, Apt 4B',
      total: 41.97,
      placedAt: DateTime.now().subtract(const Duration(days: 1)),
      itemNames: const ['Salmon Nigiri (6pc)', 'Dragon Roll', 'Miso Soup'],
      estimatedMins: 0,
    ),
    Order(
      id: 'ORD-1031',
      restaurantName: 'Spice Garden',
      status: 'Delivered',
      address: '34 Maple Drive, Apt 4B',
      total: 34.47,
      placedAt: DateTime.now().subtract(const Duration(days: 3)),
      itemNames: const ['Butter Chicken', 'Garlic Naan (3pc)', 'Mango Lassi'],
      estimatedMins: 0,
    ),
    Order(
      id: 'ORD-1028',
      restaurantName: 'Slice & Co.',
      status: 'Cancelled',
      address: '34 Maple Drive, Apt 4B',
      total: 29.98,
      placedAt: DateTime.now().subtract(const Duration(days: 5)),
      itemNames: const ['Pepperoni Fire', 'Tiramisu'],
      estimatedMins: 0,
    ),
  ];

  static final List<DriverOrder> availableOrders = [
    const DriverOrder(
      id: 'D-441',
      pickupName: 'Flame Burger Co.',
      pickupAddress: '12 Oak Street',
      dropoffAddress: '34 Maple Drive, Apt 4B',
      customerName: 'Jamie L.',
      payout: 6.40,
      distanceKm: 2.3,
      estimatedMins: 18,
      items: ['Classic Smash Burger x1', 'Loaded Fries x1', 'Craft Lemonade x1'],
    ),
    const DriverOrder(
      id: 'D-442',
      pickupName: 'Tokyo Sushi Bar',
      pickupAddress: '47 River Lane',
      dropoffAddress: '8 Birch Court, Floor 3',
      customerName: 'Priya R.',
      payout: 8.20,
      distanceKm: 3.1,
      estimatedMins: 25,
      items: ['Dragon Roll x2', 'Miso Soup x1'],
    ),
    const DriverOrder(
      id: 'D-443',
      pickupName: 'The Green Bowl',
      pickupAddress: '21 Health Ave',
      dropoffAddress: '102 Station Road',
      customerName: 'Marcus T.',
      payout: 5.80,
      distanceKm: 1.9,
      estimatedMins: 15,
      items: ['Acai Power Bowl x1', 'Green Detox Juice x2'],
    ),
  ];
}
