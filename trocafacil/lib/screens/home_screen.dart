import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart'; // seu serviço para pegar usuário logado
import '../services/imgur_service.dart'; // seu serviço para upload de imagem
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _screens = [
      const ExploreItemsScreen(),
      MyItemsScreen(authService: _authService),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openAddItemForm() {
    showDialog(
      context: context,
      builder: (context) => AddItemDialog(authService: _authService),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TrocaFácil"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implementar busca se quiser
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explorar"),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: "Meus Itens"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: _openAddItemForm,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

// --- Tela Explorar (busca itens do Firestore, todos os itens) --- //
class ExploreItemsScreen extends StatelessWidget {
  const ExploreItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('items')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar itens'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text('Nenhum item disponível.'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,          // 2 itens por linha
            crossAxisSpacing: 8.0,      // Espaço horizontal entre os itens
            mainAxisSpacing: 8.0,       // Espaço vertical entre os itens
            childAspectRatio: 3 / 4,    // Proporção largura/altura do card
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final item = docs[index].data()! as Map<String, dynamic>;

            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/item_detail', arguments: item);
              },
              child: Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.network(
                        item['imageUrl'] ?? '',
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['title'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        item['description'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// --- Tela Meus Itens (filtra itens do usuário logado pelo email) --- //
class MyItemsScreen extends StatelessWidget {
  final AuthService authService;
  const MyItemsScreen({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    final currentUser = authService.getCurrentUser();

    final email = currentUser?.email ?? 'unknown@example.com';

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('items')
          .where('ownerEmail', isEqualTo: email)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar seus itens'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text('Você não cadastrou nenhum item ainda.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final item = docs[index].data()! as Map<String, dynamic>;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Image.network(
                  item['imageUrl'] ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 50),
                ),
                title: Text(item['title'] ?? ''),
                subtitle: Text(item['description'] ?? ''),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/item_detail', arguments: item);
                },
              ),
            );
          },
        );
      },
    );
  }
}

// --- Dialog para Adicionar Item --- //
class AddItemDialog extends StatefulWidget {
  final AuthService authService;
  const AddItemDialog({super.key, required this.authService});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile == null) return;

    setState(() {
      _pickedImage = File(pickedFile.path);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, preencha tudo e escolha uma imagem.')));
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final imageUrl = await ImgurService.uploadImage(_pickedImage!);

    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao fazer upload da imagem.')));
      setState(() {
        _isUploading = false;
      });
      return;
    }

    final currentUser = widget.authService.getCurrentUser();

    await FirebaseFirestore.instance.collection('items').add({
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'imageUrl': imageUrl,
      'owner': currentUser?.displayName ?? 'Usuário',
      'ownerEmail': currentUser?.email ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });

    setState(() {
      _isUploading = false;
    });

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Item'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_pickedImage != null)
              Image.file(
                _pickedImage!,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo),
              label: const Text('Escolher imagem'),
            ),
            const SizedBox(height: 8),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Título obrigatório';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Descrição obrigatória';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (_isUploading) const CircularProgressIndicator(),
        if (!_isUploading)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        if (!_isUploading)
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Adicionar'),
          ),
      ],
    );
  }
}
