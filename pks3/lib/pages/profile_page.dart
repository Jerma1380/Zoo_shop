import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Профиль"),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Information
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Глеб',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '8(926)424-09-29',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'g.f.lushkov@gmail.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Menu Items
            _buildMenuItem(Icons.assignment_outlined, 'Мои заказы'),
            
            _buildMenuItem(Icons.home_outlined, 'Мои адреса'),
            _buildMenuItem(Icons.settings_outlined, 'Настройки'),

            const SizedBox(height: 20),

            // Help and Policies
            _buildMenuItem(Icons.help_outline, 'Ответы на вопросы', isGreyedOut: true),
            _buildMenuItem(Icons.policy_outlined, 'Политика конфиденциальности', isGreyedOut: true),
            _buildMenuItem(Icons.description_outlined, 'Пользовательское соглашение', isGreyedOut: true),

            const SizedBox(height: 20),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity, // Full-width button
                child: ElevatedButton(
                  onPressed: () {
                    // Logout action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background
                    side: const BorderSide(color: Colors.red), // Red border
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Выход',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  // A function to create menu items
  Widget _buildMenuItem(IconData icon, String title, {bool isGreyedOut = false}) {
    return ListTile(
      leading: Icon(icon, size: 26, color: isGreyedOut ? Colors.grey : Colors.black),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isGreyedOut ? Colors.grey : Colors.black,
        ),
      ),
      onTap: () {
        // Placeholder for menu item tap (add logic here if needed)
      },
    );
  }
}
