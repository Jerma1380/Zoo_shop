import 'package:flutter/material.dart';
import 'package:pks3/pages/chat_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pks3/pages/home_page.dart';
import 'package:pks3/pages/login_page.dart';
import 'package:pks3/pages/sign_up_page.dart';
import 'package:pks3/pages/orders_page.dart';
import 'package:pks3/pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://uokqilhmmujnypabdzhr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVva3FpbGhtbXVqbnlwYWJkemhyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQyNjcyNTksImV4cCI6MjA0OTg0MzI1OX0.vq6MgZTI2I_S0-drQoYrN1WW1efFqkqQ14uyP6yF3cw',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final user = Supabase.instance.client.auth.currentUser;
    setState(() {
      _isLoggedIn = user != null;
    });
    if (_isLoggedIn) {
      print('Пользователь авторизован: ${user?.id}');
    } else {
      print('Пользователь не авторизован');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZooShop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: _isLoggedIn ? '/home' : '/login',
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/orders': (context) => OrdersPage(),
        '/profile': (context) => const ProfilePage(),
        '/chat': (context) =>
            const ChatPage(receiverId: 'bb3ce76c-a548-44a1-a99a-00c7264c582d',),
      },
    );
  }
}

// ChatPage с диагностикой
