// di file search_screen.dart
import 'search_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // --- FUNGSI UNTUK MELAKUKAN PENCARIAN ---
  void _performSearch(String query) {
    if (query.isEmpty) return;

    _addSearchTerm(query);

    // Mengarahkan ke halaman hasil pencarian dengan query yang diinput
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SearchResultScreen(query: query)),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  // --- LOGIKA UNTUK RIWAYAT PENCARIAN ---

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  Future<void> _addSearchTerm(String term) async {
    if (term.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    // Hapus dulu jika sudah ada agar pindah ke atas
    _searchHistory.remove(term);
    // Tambahkan di posisi paling awal
    _searchHistory.insert(0, term);
    // Batasi jumlah riwayat, misal 10
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.sublist(0, 10);
    }
    await prefs.setStringList('searchHistory', _searchHistory);
    _loadSearchHistory(); // Muat ulang untuk update UI
  }

  Future<void> _clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('searchHistory');
    _loadSearchHistory(); // Muat ulang untuk update UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ... di dalam AppBar
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Cari judul atau penulis...',
            // Border saat tidak di-klik
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Colors.grey.shade400, // Warna border saat normal
                width: 1.0,
              ),
            ),
            // Border saat di-klik (fokus)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color:
                    Theme.of(
                      context,
                    ).primaryColor, // Warna border saat diklik (biru)
                width: 2.0,
              ),
            ),
            // Mengatur padding agar teks tidak terlalu menempel ke border
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
          ),
          onSubmitted: (value) {
            _performSearch(value);
          },
        ),
        // ...
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- BAGIAN RIWAYAT PENCARIAN ---
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
            Wrap(
              spacing: 8.0,
              children:
                  _searchHistory
                      .map(
                        (term) => ActionChip(
                          avatar: const Icon(Icons.history),
                          label: Text(term),
                          onPressed: () {
                            _searchController.text = term;
                            _performSearch(term);
                          },
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 24),
          ],

          // --- BAGIAN PENCARIAN POPULER ---
          const Text(
            'Pencarian Populer',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            children:
                _popularSearches
                    .map(
                      (term) => ActionChip(
                        label: Text(term),
                        onPressed: () {
                          _searchController.text = term;
                          _performSearch(term);
                        },
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}
