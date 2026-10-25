// ============================================================
// PART 1 - Lifecycle answers:
// a) When a page opens for the first time:
//    initState -> didChangeDependencies -> build
// b) After pressing the heart button, ONLY build runs again
//    (setState marks the widget dirty and schedules a rebuild).
// c) When you leave a page (Navigator push a new page on top):
//    deactivate runs, then build (because it may be kept alive),
//    and when the page is fully removed (pop): deactivate -> dispose.
//    When you go back to a previous page: build runs again.
// d) On browser resize, didChangeDependencies runs again,
//    because MediaQuery (an InheritedWidget the page depends on)
//    changed (width/height), so Flutter re-evaluates the
//    dependencies, then build runs again with the new size.
//
// PART 4 - go_router answers:
// 1) context.go replaces the current location in the navigation
//    stack (it clears the back history up to the new route),
//    while context.push adds a NEW route on top of the stack.
//    Examples:
//    - context.goNamed('products', ...) used on the Login page
//      (user should NOT go back to the login screen).
//    - context.push('/details/$name/$price') used on the
//      Products page (user SHOULD be able to go back).
// 2) We used go for Login -> Products because the user must not
//    return to the login page with the back button (the login
//    screen is removed from the stack). We used push for
//    Products -> Details because details is a normal page the
//    user can pop back from.
// 3) Path parameters are part of the route path itself and are
//    required to identify the resource:
//    /details/Laptop/1200  (name=Laptop, price=1200)
//    Query parameters are optional key=value pairs after "?"
//    used to pass extra data:
//    /products?user=Guest  (user=Guest)
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'product_widgets.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: 'products',
      path: '/products',
      builder: (context, state) {
        final user = state.uri.queryParameters['user'] ?? 'Guest';
        return ProductsPage(username: user);
      },
    ),
    GoRoute(
      name: 'details',
      path: '/details/:name/:price',
      builder: (context, state) {
        final name = state.pathParameters['name']!;
        final price = state.pathParameters['price']!;
        return DetailsPage(name: name, price: price);
      },
    ),
  ],
);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    print("LoginPage: initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.sizeOf(context);
    print("LoginPage: didChangeDependencies -> width: ${size.width}, height: ${size.height}");
  }

  @override
  Widget build(BuildContext context) {
    print("LoginPage: build");
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // ================= Navigator version =================
            // Navigator.pushNamed(context, '/products', arguments: 'Guest');
            // =====================================================
            context.goNamed('products', queryParameters: {'user': 'Guest'});
          },
          child: const Text('Login'),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    print("LoginPage: deactivate");
  }

  @override
  void dispose() {
    print("LoginPage: dispose");
    super.dispose();
  }
}

class ProductsPage extends StatefulWidget {
  final String username;

  const ProductsPage({super.key, required this.username});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  int favorites = 0;
  String cartMessage = '';

  final List<Map<String, dynamic>> products = const [
    {"name": "Laptop", "price": 1200},
    {"name": "Phone", "price": 800},
    {"name": "Headphones", "price": 150},
    {"name": "Keyboard", "price": 90},
    {"name": "Mouse", "price": 40},
    {"name": "Monitor", "price": 300},
  ];

  @override
  void initState() {
    super.initState();
    print("ProductsPage: initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.sizeOf(context);
    print("ProductsPage: didChangeDependencies -> width: ${size.width}, height: ${size.height}");
  }

  @override
  Widget build(BuildContext context) {
    print("ProductsPage: build");
    final size = MediaQuery.sizeOf(context);
    final double width = size.width;
    final bool isWide = width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Products - Favorites: $favorites'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Welcome, ${widget.username}'),
          ),
          Text('Screen width: ${width.toStringAsFixed(0)}'),
          if (cartMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                cartMessage,
                style: const TextStyle(color: Colors.green),
              ),
            ),
          Expanded(
            child: isWide
                ? ProductsGridView(
                    products: products,
                    onFavoritePressed: () {
                      setState(() {
                        favorites++;
                      });
                    },
                    onProductTap: (index) => _openDetails(index),
                  )
                : ProductsListView(
                    products: products,
                    onFavoritePressed: () {
                      setState(() {
                        favorites++;
                      });
                    },
                    onProductTap: (index) => _openDetails(index),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _openDetails(int index) async {
    final name = products[index]["name"].toString();
    final price = products[index]["price"].toString();

    // ================= Navigator version =================
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => DetailsPage(name: name, price: price),
    //   ),
    // );
    // =====================================================

    final result = await context.push('/details/$name/$price');

    if (result != null) {
      setState(() {
        cartMessage = result.toString();
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    print("ProductsPage: deactivate");
  }

  @override
  void dispose() {
    print("ProductsPage: dispose");
    super.dispose();
  }
}

class DetailsPage extends StatefulWidget {
  final String name;
  final String price;

  const DetailsPage({super.key, required this.name, required this.price});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    print("DetailsPage: initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.sizeOf(context);
    print("DetailsPage: didChangeDependencies -> width: ${size.width}, height: ${size.height}");
  }

  @override
  Widget build(BuildContext context) {
    print("DetailsPage: build");
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.name, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text('\$${widget.price}', style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // ================= Navigator version =================
                // Navigator.pop(context, "${widget.name} added to cart");
                // =====================================================
                context.pop("${widget.name} added to cart");
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    print("DetailsPage: deactivate");
  }

  @override
  void dispose() {
    print("DetailsPage: dispose");
    super.dispose();
  }
}

// ================= Navigator version (Part 2) =================
// This version used MaterialApp with a routes table instead of
// go_router. Kept here as a backup, do not delete.
//
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const NavigatorApp());
// }
//
// class NavigatorApp extends StatelessWidget {
//   const NavigatorApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Mini Product Catalog',
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const LoginPage(),
//         '/products': (context) => const ProductsPage(username: 'Guest'),
//       },
//     );
//   }
// }
//
// The Login button used:
//   Navigator.pushNamed(context, '/products', arguments: 'Guest');
// =========================================================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mini Product Catalog',
      routerConfig: router,
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
    );
  }
}
