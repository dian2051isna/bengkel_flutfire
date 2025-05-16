import 'package:crud_bengkel/providers/sparepart_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditSparepartScreen extends StatefulWidget {
  final bool isEditing;
  final String? sparepartId;
  final Map<String, dynamic>? initialData;

  const AddEditSparepartScreen({super.key, 
    this.isEditing = false,
    this.sparepartId,
    this.initialData,
  });

  @override
  _AddEditSparepartScreenState createState() => _AddEditSparepartScreenState();
}

class _AddEditSparepartScreenState extends State<AddEditSparepartScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _kodeController;
  late TextEditingController _merkController;
  late TextEditingController _hargaController;
  late TextEditingController _stokController;
  late String _kategori;

  final List<String> _kategoriList = [
    'Mesin',
    'Elektrik',
    'Body',
    'Interior',
    'Aksesoris',
    'Lainnya'
  ];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
        text: widget.isEditing ? widget.initialData!['nama'] : '');
    _kodeController = TextEditingController(
        text: widget.isEditing ? widget.initialData!['kode'] : '');
    _merkController = TextEditingController(
        text: widget.isEditing ? widget.initialData!['merk'] : '');
    _hargaController = TextEditingController(
        text: widget.isEditing ? widget.initialData!['harga'].toString() : '');
    _stokController = TextEditingController(
        text: widget.isEditing ? widget.initialData!['stok'].toString() : '');
    _kategori = widget.isEditing ? widget.initialData!['kategori'] : 'Mesin';
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kodeController.dispose();
    _merkController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.isEditing) {
          await Provider.of<SparepartProvider>(context, listen: false)
              .updateSparepart(
            id: widget.sparepartId!,
            nama: _namaController.text,
            kode: _kodeController.text,
            merk: _merkController.text,
            harga: double.parse(_hargaController.text),
            stok: int.parse(_stokController.text),
            kategori: _kategori,
          );
        } else {
          await Provider.of<SparepartProvider>(context, listen: false)
              .addSparepart(
            nama: _namaController.text,
            kode: _kodeController.text,
            merk: _merkController.text,
            harga: double.parse(_hargaController.text),
            stok: int.parse(_stokController.text),
            kategori: _kategori,
          );
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Sparepart' : 'Tambah Sparepart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Sparepart'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama sparepart harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _kodeController,
                decoration: InputDecoration(labelText: 'Kode Sparepart'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode sparepart harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _merkController,
                decoration: InputDecoration(labelText: 'Merk'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Merk harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _hargaController,
                decoration: InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga harus diisi';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stokController,
                decoration: InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok harus diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: InputDecoration(labelText: 'Kategori'),
                items: _kategoriList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _kategori = newValue!;
                  });
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(widget.isEditing ? 'Update' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}