import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SparepartProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get spareparts => _firestore.collection('bengkel_crud');

  Future<void> addSparepart({
    required String nama,
    required String kode,
    required String merk,
    required double harga,
    required int stok,
    required String kategori,
  }) async {
    try {
      await spareparts.add({
        'nama': nama,
        'kode': kode,
        'merk': merk,
        'harga': harga,
        'stok': stok,
        'kategori': kategori,
        'createdAt': Timestamp.now(),
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateSparepart({
    required String id,
    required String nama,
    required String kode,
    required String merk,
    required double harga,
    required int stok,
    required String kategori,
  }) async {
    try {
      await spareparts.doc(id).update({
        'nama': nama,
        'kode': kode,
        'merk': merk,
        'harga': harga,
        'stok': stok,
        'kategori': kategori,
        'updatedAt': Timestamp.now(),
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteSparepart(String id) async {
    try {
      await spareparts.doc(id).delete();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> getSpareparts() {
    return spareparts.orderBy('createdAt', descending: true).snapshots();
  }
}