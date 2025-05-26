import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Criar um novo item
  Future<void> createItem({
    required String title,
    required String description,
    required String imageUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    await _firestore.collection('items').add({
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'userId': user.uid,
      'username': user.displayName ?? 'Anônimo',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Obter todos os itens
  Stream<QuerySnapshot> getItems() {
    return _firestore
        .collection('items')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Obter itens de um usuário específico
  Stream<QuerySnapshot> getUserItems() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    return _firestore
        .collection('items')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Deletar um item
  Future<void> deleteItem(String itemId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    final item = await _firestore.collection('items').doc(itemId).get();
    if (item.data()?['userId'] != user.uid) {
      throw Exception('Não autorizado a deletar este item');
    }

    await _firestore.collection('items').doc(itemId).delete();
  }
}