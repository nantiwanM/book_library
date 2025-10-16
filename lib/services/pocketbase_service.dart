import 'package:pocketbase/pocketbase.dart';
import '../models/book.dart';

class PocketBaseService {
  final pb = PocketBase('http://127.0.0.1:8090');

  // ตรวจสอบว่ามีการล็อกอินหรือไม่ ถ้าไม่ล็อกอินจะล็อกอินอัตโนมัติ
  Future<void> _ensureAuthenticated() async {
    if (!pb.authStore.isValid) {
      await pb
          .collection('_superusers')
          .authWithPassword('admin@gmail.com', 'admin123456789');
    }
  }

  // อ่านข้อมูลหนังสือทั้งหมด
  Future<List<Book>> getBooks() async {
    await _ensureAuthenticated();
    final records = await pb.collection('books').getFullList(sort: '-created');
    return records.map((r) => Book.fromJson(r.toJson())).toList();
  }

  // สร้างหนังสือใหม่
  Future<void> addBook(Book book) async {
    await _ensureAuthenticated();
    await pb.collection('books').create(body: book.toJson());
  }

  // อัปเดตข้อมูลหนังสือ
  Future<void> updateBook(Book book) async {
    await _ensureAuthenticated();
    await pb.collection('books').update(book.id, body: book.toJson());
  }

  // ลบหนังสือ
  Future<void> deleteBook(String id) async {
    await _ensureAuthenticated();
    await pb.collection('books').delete(id);
  }
}
