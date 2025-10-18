import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Johan Smith',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'California, USA',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.facebook, color: Colors.blue), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: 20, // Correção
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.star, color: Colors.white),
                      Text('5.0', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: 10, // Correção
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.work, color: Colors.white),
                      Text('10 Jobs', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: 10, // Correção
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.verified, color: Colors.white),
                      Text('Verified', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(5, (index) {
                return ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text('Habilidade ${index + 1}'),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
