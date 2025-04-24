import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // TODO: Add state variables for user profile data (e.g., name, email, profile picture URL)

  @override
  void initState() {
    super.initState();
    // TODO: Fetch user profile data here (e.g., from Firebase)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              // TODO: Implement logout logic
              // Example: Navigate back to login screen
              Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[ // Ensure children are correctly placed within Center's child Column
              const CircleAvatar(
              radius: 50,
              // TODO: Display user profile picture
              // backgroundImage: NetworkImage(userProfileImageUrl),
              child: Icon(Icons.person, size: 50), // Placeholder icon
            ),
            const SizedBox(height: 20),
            // TODO: Display user name
            Text(
              'Nome do Utilizador', // Placeholder
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            // TODO: Display user email
            Text(
              'email@exemplo.com', // Placeholder
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 30),
            // TODO: Add more profile details or options (e.g., edit profile button)
            ElevatedButton(
              onPressed: () {
                // TODO: Implement edit profile navigation or functionality
              },
              child: const Text('Editar Perfil'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                // TODO: Implement account deletion logic (with confirmation)
              },
              child: const Text('Eliminar Conta', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    )
    );
  }
}