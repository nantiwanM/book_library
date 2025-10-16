import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/book.dart';
import '../services/pocketbase_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final service = PocketBaseService();
  bool loading = true;
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);
    try {
      books = await service.getBooks();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  int get totalBooks => books.length;

  Map<String, int> get genreCount {
    final map = <String, int>{};
    for (final b in books) {
      map[b.genre] = (map[b.genre] ?? 0) + 1;
    }
    return map;
  }

  Map<String, int> get authorCount {
    final map = <String, int>{};
    for (final b in books) {
      map[b.author] = (map[b.author] ?? 0) + 1;
    }
    return map;
  }

  List<PieChartSectionData> buildPieSections() {
    if (genreCount.isEmpty) return [];
    final sortedEntries = genreCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top5 = sortedEntries.take(5).toList();
    final othersCount = sortedEntries.skip(5).fold(0, (sum, e) => sum + e.value);

    final colors = [
      Color(0xFFFFC4A3),
      Color(0xFFFFE0B2),
      Color(0xFFB3E5FC),
      Color(0xFFC8E6C9),
      Color(0xFFD1C4E9),
      Colors.grey.shade300
    ];

    final sections = <PieChartSectionData>[];

    for (int i = 0; i < top5.length; i++) {
      final entry = top5[i];
      sections.add(PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${entry.key}\n${entry.value}',
        color: colors[i % colors.length],
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ));
    }

    if (othersCount > 0) {
      sections.add(PieChartSectionData(
        value: othersCount.toDouble(),
        title: 'อื่นๆ\n$othersCount',
        color: colors.last,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ));
    }

    return sections;
  }

  List<MapEntry<String, int>> buildAuthorList() {
    if (authorCount.isEmpty) return [];
    final sortedEntries = authorCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries.take(10).toList();
  }

  Widget buildStatCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.grey.shade200,
      color: Colors.white,
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  buildStatCard('จำนวนหนังสือทั้งหมด', '$totalBooks เล่ม'),
                  const SizedBox(height: 12),
                  buildStatCard('จำนวนหมวดหมู่ทั้งหมด', '${genreCount.length} หมวดหมู่'),
                  const SizedBox(height: 12),
                  buildStatCard('จำนวนผู้แต่งทั้งหมด', '${authorCount.length} คน'),
                  const SizedBox(height: 12),
                  buildStatCard(
                      'หมวดหมู่ยอดนิยม',
                      genreCount.isEmpty
                          ? '-'
                          : genreCount.entries.reduce((a, b) => a.value > b.value ? a : b).key),
                  const SizedBox(height: 12),
                  buildStatCard(
                      'ผู้แต่งที่มีผลงานมากที่สุด',
                      authorCount.isEmpty
                          ? '-'
                          : authorCount.entries.reduce((a, b) => a.value > b.value ? a : b).key),
                  const SizedBox(height: 24),

                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: Colors.grey.shade200,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Top 5 หมวดหมู่ (Pie Chart)',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                sections: buildPieSections(),
                                centerSpaceRadius: 40,
                                sectionsSpace: 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: Colors.grey.shade200,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Top 10 ผู้แต่ง',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 12),
                          buildAuthorList().isEmpty
                              ? const Text(
                                  'ไม่มีข้อมูลผู้แต่ง',
                                  style: TextStyle(color: Colors.grey),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: buildAuthorList().length,
                                  separatorBuilder: (_, __) => const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final entry = buildAuthorList()[index];
                                    return ListTile(
                                      title: Text(entry.key),
                                      trailing: Text('${entry.value} เล่ม',
                                          style: const TextStyle(fontWeight: FontWeight.bold)),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
