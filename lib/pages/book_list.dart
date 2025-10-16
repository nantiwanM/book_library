import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/pocketbase_service.dart';
import 'book_form.dart';
import 'book_detail.dart';
import 'dashboard.dart';

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  final PocketBaseService service = PocketBaseService();
  final TextEditingController searchCtrl = TextEditingController();

  List<Book> books = [];
  List<Book> filteredBooks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  // โหลดข้อมูลหนังสือทั้งหมดจาก PocketBase
  Future<void> loadBooks() async {
    setState(() => isLoading = true);
    try {
      books = await service.getBooks();
      filteredBooks = books;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ลบหนังสือ พร้อมยืนยันก่อนลบ
  Future<void> deleteBook(String id) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบหนังสือเล่มนี้?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('ลบ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await service.deleteBook(id);
        loadBooks();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('ลบหนังสือเรียบร้อยแล้ว')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาดในการลบหนังสือ: $e')),
        );
      }
    }
  }

  // ฟังก์ชันค้นหาหนังสือ
  void filterBooks(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredBooks = books.where((book) {
        return book.title.toLowerCase().contains(lowerQuery) ||
            book.author.toLowerCase().contains(lowerQuery) ||
            book.genre.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการหนังสือทั้งหมด'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'แดชบอร์ด',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DashboardPage()),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ช่องค้นหา
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: searchCtrl,
                    onChanged: filterBooks,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'ค้นหาชื่อ / ผู้แต่ง / หมวดหมู่',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                // รายการหนังสือ
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: loadBooks,
                    child: filteredBooks.isEmpty
                        ? const Center(
                            child: Text(
                              'ไม่พบข้อมูลหนังสือ',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: filteredBooks.length,
                            itemBuilder: (context, index) {
                              final book = filteredBooks[index];
                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BookDetail(book: book),
                                      ),
                                    );
                                    if (result == true) loadBooks();
                                  },
                                  leading: book.coverUrl.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          child: Image.network(
                                            book.coverUrl,
                                            width: 60,
                                            height: 70,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(Icons.broken_image),
                                          ),
                                        )
                                      : const Icon(Icons.menu_book, size: 40),
                                  title: Text(
                                    book.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text('ผู้แต่ง: ${book.author}'),
                                      Text('หมวดหมู่: ${book.genre}'),
                                    ],
                                  ),

                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  BookForm(book: book),
                                            ),
                                          );
                                          if (result == true) loadBooks();
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => deleteBook(book.id),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BookForm()),
          );
          if (result == true) loadBooks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
