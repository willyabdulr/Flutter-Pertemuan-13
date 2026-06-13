import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latihan1/model/Product.dart';
import 'package:latihan1/service/api_service.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;

  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionsController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _imagePicker = ImagePicker();

  File? _imageFile;
  Uint8List? _imageBytes;
  String? _imageName;
  bool _isLoading = false;

  bool get _isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    if (product != null) {
      _nameController.text = product.name;
      _descriptionsController.text = product.descriptions;
      _priceController.text = product.price.toString();
      _stockController.text = product.stock.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionsController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (pickedImage == null) return;

      final bytes = await pickedImage.readAsBytes();

      setState(() {
        _imageBytes = bytes;
        _imageName = pickedImage.name;
        if (!kIsWeb) {
          _imageFile = File(pickedImage.path);
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih gambar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final name = _nameController.text.trim();
      final descriptions = _descriptionsController.text.trim();
      final price = int.parse(_priceController.text.trim());
      final stock = int.parse(_stockController.text.trim());

      if (_isEdit) {
        await ApiService.updateProduct(
          id: widget.product!.id,
          name: name,
          descriptions: descriptions,
          price: price,
          stock: stock,
          imageFile: kIsWeb ? null : _imageFile,
          imageBytes: _imageBytes,
        );
      } else {
        final product = await ApiService.createProduct(
          name: name,
          descriptions: descriptions,
          price: price,
          stock: stock,
          imageBytes: _imageBytes,
        );

        if (!kIsWeb && _imageFile != null) {
          await ApiService.uploadImage(product.id, _imageFile!);
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEdit
                ? 'Produk berhasil diperbarui'
                : 'Produk berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan produk: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }
    return null;
  }

  String? _validateNumber(String? value, String fieldName) {
    final requiredError = _validateRequired(value, fieldName);
    if (requiredError != null) return requiredError;

    final number = int.tryParse(value!.trim());
    if (number == null || number < 0) {
      return '$fieldName harus berupa angka valid';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Produk' : 'Tambah Produk'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory),
                ),
                validator: (value) => _validateRequired(value, 'Nama produk'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionsController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 4,
                validator: (value) => _validateRequired(value, 'Deskripsi'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.payments),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, 'Harga'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.store),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, 'Stok'),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveProduct,
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_isLoading
                    ? 'Menyimpan...'
                    : _isEdit
                        ? 'Update Produk'
                        : 'Simpan Produk'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gambar Produk',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _isLoading ? null : _pickImage,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: _buildImagePreview(),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _isLoading ? null : _pickImage,
          icon: const Icon(Icons.image),
          label: Text(_imageName ?? 'Pilih Gambar'),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    if (_imageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(_imageBytes!, fit: BoxFit.cover),
      );
    }

    if (!kIsWeb && _imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(_imageFile!, fit: BoxFit.cover),
      );
    }

    if (_isEdit && widget.product!.imageUrl.isNotEmpty) {
      final imageUrl =
          '${widget.product!.imageUrl}?v=${widget.product!.updatedAt.millisecondsSinceEpoch}';

      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) => _buildEmptyImage(),
        ),
      );
    }

    return _buildEmptyImage();
  }

  Widget _buildEmptyImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate, size: 56, color: Colors.grey[500]),
        const SizedBox(height: 8),
        Text(
          'Tap untuk memilih gambar',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
