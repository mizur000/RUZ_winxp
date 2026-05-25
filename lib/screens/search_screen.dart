import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/schedule_service.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/result_card.dart';
import '../providers/favorites_provider.dart';
import '../providers/theme_provider.dart';
import 'schedule_screen.dart';

class SearchScreen extends StatefulWidget {
  final ScheduleService scheduleService;

  const SearchScreen({super.key, required this.scheduleService});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _onSearch(String query) async {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await widget.scheduleService.unifiedSearch(query);
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onSelectEntity(Map<String, dynamic> entity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScheduleScreen(
          entityId: entity['id'].toString(),
          entityType: entity['searchType'],
          entityName: entity['displayName'],
          scheduleService: widget.scheduleService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFECE9D8),
      appBar: AppBar(
        title: const Text(
          'Расписание ФА',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
            fontFamily: 'Tahoma',
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0058E3),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.computer, color: Colors.white, size: 20),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70), // Уменьшил высоту
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: const Color(0xFF0058E3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomSearchBar(
                  hintText: 'Поиск группы или преподавателя...',
                  onSearch: _onSearch,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Введите минимум 3 символа',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                    fontFamily: 'Tahoma',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _buildBody(favoritesProvider),
    );
  }

  Widget _buildBody(FavoritesProvider favoritesProvider) {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFF990000)),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(fontFamily: 'Tahoma', fontSize: 12, color: Color(0xFF1E2F5A))),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE1DFD4),
                border: Border.all(color: const Color(0xFFACA899), width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ElevatedButton(
                onPressed: () => _onSearch(''),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                ),
                child: const Text('Повторить', style: TextStyle(fontFamily: 'Tahoma', fontSize: 12, color: Color(0xFF1E2F5A))),
              ),
            ),
          ],
        ),
      );
    }

    if (_results.isEmpty && !_isLoading) {
      if (favoritesProvider.favorites.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: const Text(
                'Избранное',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2F5A),
                  fontFamily: 'Tahoma',
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: favoritesProvider.favorites.length,
                itemBuilder: (context, index) {
                  final fav = favoritesProvider.favorites[index];
                  return ResultCard(
                    title: fav.name,
                    subtitle: fav.type == 'group' ? 'Группа' : 'Преподаватель',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScheduleScreen(
                            entityId: fav.id,
                            entityType: fav.type,
                            entityName: fav.name,
                            scheduleService: widget.scheduleService,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, size: 48, color: Color(0xFF888888)),
            const SizedBox(height: 16),
            const Text(
              'Введите название группы или фамилию преподавателя',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF555555),
                fontFamily: 'Tahoma',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final item = _results[index];
        return ResultCard(
          title: item['displayName'],
          subtitle: item['subtitle'],
          onTap: () => _onSelectEntity(item),
        );
      },
    );
  }
}