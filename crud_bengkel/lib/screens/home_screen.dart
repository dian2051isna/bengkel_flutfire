import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sparepart_providers.dart';
import 'add_edit_sparepart_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Bengkel Motor',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              shadows: [
                Shadow(
                  blurRadius: 4,
                  offset: Offset(2, 2),
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddEditSparepartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: Provider.of<SparepartProvider>(context).getSpareparts(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Tidak ada data sparepart'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var sparepart = snapshot.data!.docs[index];
              var data = sparepart.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(data['nama']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kode: ${data['kode']}'),
                      Text('Merk: ${data['merk']}'),
                      Text('Harga: Rp${data['harga'].toStringAsFixed(2)}'),
                      Text('Stok: ${data['stok']}'),
                      Text('Kategori: ${data['kategori']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddEditSparepartScreen(
                                isEditing: true,
                                sparepartId: sparepart.id,
                                initialData: data,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Hapus Sparepart'),
                              content: const Text(
                                  'Apakah Anda yakin ingin menghapus sparepart ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await Provider.of<SparepartProvider>(
                                            context,
                                            listen: false)
                                        .deleteSparepart(sparepart.id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}