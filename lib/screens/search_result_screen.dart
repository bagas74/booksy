import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/search_service.dart';
import '../widgets/product_card.dart';
import '../config/config.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;
  const SearchResultScreen({super.key, required this.query});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final SearchService _searchService = SearchService();
  final TextEditingController _searchController = TextEditingController();

  Future<List<Product>>? _searchResultsFuture;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.query;
    _searchController.text = _currentQuery;
    _searchResultsFuture = _searchService.searchProducts(_currentQuery);
  }

  /// Memulai pencarian dan memperbarui UI
  void _performSearch(String query) {
    FocusScope.of(context).unfocus(); // sembunyikan keyboard
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty || cleanQuery == _currentQuery) return;

    setState(() {
      _currentQuery = cleanQuery;
      _searchResultsFuture = _searchService.searchProducts(cleanQuery);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _currentQuery = '';
      // Tidak perlu set _searchResultsFuture = null agar hasil tetap tampil
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Cari judul atau penulis...',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: _clearSearch,
                    )
                    : null,
          ),
          onChanged: (value) => setState(() {}), // agar tombol clear muncul
          onSubmitted: _performSearch,
        ),
      ),
      backgroundColor: AppColors.background,
      body:
          _searchResultsFuture == null
              ? const Center(child: Text('Mulai pencarian...'))
              : FutureBuilder<List<Product>>(
                future: _searchResultsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Terjadi error: ${snapshot.error}'),
                    );
                  }

                  final products = snapshot.data ?? [];
                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Buku Tidak Ditemukan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Tidak ada hasil untuk "$_currentQuery".',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.55,
                        ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                  );
                },
              ),
    );
  }
}
