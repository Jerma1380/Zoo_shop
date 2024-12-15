import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pks3/pages/home_page.dart';
import 'package:pks3/pages/login_page.dart';
import 'package:pks3/pages/sign_up_page.dart';
import 'package:pks3/pages/profile_page.dart'; // Ensure ProfilePage exists

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://uokqilhmmujnypabdzhr.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVva3FpbGhtbXVqbnlwYWJkemhyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQyNjcyNTksImV4cCI6MjA0OTg0MzI1OX0.vq6MgZTI2I_S0-drQoYrN1WW1efFqkqQ14uyP6yF3cw', // Replace with your Supabase Anon Key
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
      initialRoute: _isLoggedIn ? '/home' : '/login', // Start based on login state
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/profile': (context) => const ProfilePage(), // Add the missing route
      },
    );
  }
}
