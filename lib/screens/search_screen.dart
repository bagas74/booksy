import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'search_result_screen.dart'; // <- Pastikan import ini benar

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];

  final List<String> _popularSearches = [
    'Bumi',
    'Tere Liye',
    'Filosofi Teras',
    'Marketing',
    'Atomic Habits',
  ];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  Future<void> _addSearchTerm(String term) async {
    if (term.trim().isEmpty) return;
    final cleanTerm = term.trim();

    final prefs = await SharedPreferences.getInstance();
    _searchHistory.remove(cleanTerm);
    _searchHistory.insert(0, cleanTerm);
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.sublist(0, 10);
    }
    await prefs.setStringList('searchHistory', _searchHistory);
    _loadSearchHistory();
  }

  Future<void> _clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('searchHistory');
    _loadSearchHistory();
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    final cleanQuery = query.trim();

    _addSearchTerm(cleanQuery);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SearchResultScreen(query: cleanQuery)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Cari judul atau penulis...',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
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
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                    )
                    : null,
          ),
          onChanged: (_) => setState(() {}), // update UI untuk suffixIcon
          onSubmitted: _performSearch,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_searchHistory.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Riwayat Pencarian',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(
                  onPressed: _clearSearchHistory,
                  child: const Text('Hapus'),
                ),
              ],
            ),
            const SizedBox(height: 6), // jarak 6px
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children:
                  _searchHistory.map((term) {
                    return ActionChip(
                      avatar: const Icon(Icons.history, size: 16),
                      label: Text(term),
                      onPressed: () {
                        _searchController.text = term;
                        _performSearch(term);
                      },
                    );
                  }).toList(),
            ),
          ],
          if (_searchHistory.isNotEmpty) const SizedBox(height: 24),
          const Text(
            'Pencarian Populer',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6), // jarak 6px
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children:
                _popularSearches.map((term) {
                  return ActionChip(
                    label: Text(term),
                    onPressed: () {
                      _searchController.text = term;
                      _performSearch(term);
                    },
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
