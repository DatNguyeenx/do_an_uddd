import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../data/places_data.dart';
import '../provider/checkin_provider.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key, this.initialPlace});

  final Place? initialPlace;

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  final _search = TextEditingController();
  String _query = '';
  String _category = 'Tất cả';
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialPlace != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showPlace(widget.initialPlace!);
      });
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _showPlace(Place place) async {
    final noteController = TextEditingController();
    final shouldCheckIn = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            8,
            20,
            MediaQuery.viewInsetsOf(sheetContext).bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    place.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: AppColors.accent,
                      child: const Center(
                        child: Icon(Icons.landscape, size: 48, color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(place.name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 6),
                Text('${place.location} · ${place.category} · ★ ${place.rating}'),
                const SizedBox(height: 12),
                Text(place.description, style: const TextStyle(height: 1.5)),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  maxLength: 500,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Ghi chú hành trình (không bắt buộc)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Check-in được ghi nhận thủ công; ứng dụng chưa xác minh GPS.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.pop(sheetContext, true),
                    icon: const Icon(Icons.add_location_alt_outlined),
                    label: const Text('Xác nhận check-in'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (shouldCheckIn == true && mounted) {
      context.read<CheckInProvider>().add(place, noteController.text.trim());
      setState(() => _tab = 1);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã check-in tại ${place.name}')),
      );
    }
    noteController.dispose();
  }

  Future<void> _removeEntry(CheckInEntry entry) async {
    final remove = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa check-in?'),
        content: Text('Xóa lịch sử tại ${entry.place.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Hủy')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Xóa')),
        ],
      ),
    );
    if (remove == true && mounted) context.read<CheckInProvider>().remove(entry);
  }

  @override
  Widget build(BuildContext context) {
    final checkIns = context.watch<CheckInProvider>();
    final categories = ['Tất cả', ...samplePlaces.map((place) => place.category).toSet()];
    final query = _query.trim().toLowerCase();
    final places = samplePlaces.where((place) {
      final matchesCategory = _category == 'Tất cả' || place.category == _category;
      final matchesQuery = '${place.name} ${place.location}'.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(_tab == 0 ? 'Check-in địa điểm' : 'Lịch sử check-in')),
      body: _tab == 0
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: TextField(
                    controller: _search,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Tìm địa danh hoặc tỉnh/thành',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    children: categories.map((category) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: _category == category,
                        onSelected: (_) => setState(() => _category = category),
                      ),
                    )).toList(),
                  ),
                ),
                Expanded(
                  child: places.isEmpty
                      ? const Center(child: Text('Không tìm thấy địa điểm phù hợp.'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: places.length,
                          itemBuilder: (context, index) {
                            final place = places[index];
                            final visited = checkIns.hasVisited(place.id);
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () => _showPlace(place),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      place.imageUrl,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        height: 150,
                                        color: AppColors.accent,
                                        child: const Center(child: Icon(Icons.landscape, size: 42, color: AppColors.primary)),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                                      subtitle: Text('${place.location} · ${place.category} · ★ ${place.rating}'),
                                      trailing: visited ? const Icon(Icons.check_circle, color: AppColors.primary) : const Icon(Icons.chevron_right),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                                      child: FilledButton.tonalIcon(
                                        onPressed: () => _showPlace(place),
                                        icon: Icon(visited ? Icons.add_location_alt_outlined : Icons.location_on_outlined),
                                        label: Text(visited ? 'Check-in thêm lần nữa' : 'Xem và check-in'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            )
          : _history(checkIns.entries),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.place_outlined), label: 'Địa điểm'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Lịch sử'),
        ],
      ),
    );
  }

  Widget _history(List<CheckInEntry> entries) {
    if (entries.isEmpty) {
      return const Center(child: Text('Chưa có check-in. Hãy chọn một địa điểm.'));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('${entries.length} lần check-in · ${entries.map((entry) => entry.place.id).toSet().length} địa điểm',
            style: Theme.of(context).textTheme.titleMedium),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text('Lịch sử chỉ lưu trong phiên hiện tại; vị trí chưa được xác minh bằng GPS.'),
        ),
        ...entries.map((entry) => Card(
          child: ListTile(
            leading: const CircleAvatar(backgroundColor: AppColors.accent, child: Icon(Icons.location_on_outlined, color: AppColors.primary)),
            title: Text(entry.place.name),
            subtitle: Text('${entry.place.location}\n${entry.createdAt.day}/${entry.createdAt.month}/${entry.createdAt.year} ${entry.createdAt.hour.toString().padLeft(2, '0')}:${entry.createdAt.minute.toString().padLeft(2, '0')}${entry.note.isEmpty ? '' : '\n${entry.note}'}'),
            isThreeLine: true,
            trailing: IconButton(tooltip: 'Xóa check-in', onPressed: () => _removeEntry(entry), icon: const Icon(Icons.delete_outline)),
          ),
        )),
      ],
    );
  }
}
