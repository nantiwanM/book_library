import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/pocketbase_service.dart';

class BookForm extends StatefulWidget {
  final Book? book; // ถ้า null = Add mode
  const BookForm({super.key, this.book});

  @override
  State<BookForm> createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  final PocketBaseService service = PocketBaseService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController titleCtrl;
  late TextEditingController authorCtrl;
  late TextEditingController yearCtrl;
  late TextEditingController genreCtrl;
  late TextEditingController coverCtrl;
  late TextEditingController descCtrl;

  bool get isEdit => widget.book != null;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.book?.title ?? '');
    authorCtrl = TextEditingController(text: widget.book?.author ?? '');
    yearCtrl = TextEditingController(text: widget.book?.year.toString() ?? '');
    genreCtrl = TextEditingController(text: widget.book?.genre ?? '');
    coverCtrl = TextEditingController(text: widget.book?.coverUrl ?? '');
    descCtrl = TextEditingController(text: widget.book?.description ?? '');
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    authorCtrl.dispose();
    yearCtrl.dispose();
    genreCtrl.dispose();
    coverCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveOrUpdateBook() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (isEdit) {
        // แก้ไขหนังสือเดิม
        final updatedBook = widget.book!
          ..title = titleCtrl.text.trim()
          ..author = authorCtrl.text.trim()
          ..year = int.tryParse(yearCtrl.text.trim()) ?? 0
          ..genre = genreCtrl.text.trim()
          ..coverUrl = coverCtrl.text.trim()
          ..description = descCtrl.text.trim();

        await service.updateBook(updatedBook);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('แก้ไขข้อมูลสำเร็จ')),
        );
      } else {
        // เพิ่มหนังสือใหม่
        final newBook = Book(
          id: '',
          title: titleCtrl.text.trim(),
          author: authorCtrl.text.trim(),
          year: int.tryParse(yearCtrl.text.trim()) ?? 0,
          genre: genreCtrl.text.trim(),
          coverUrl: coverCtrl.text.trim(),
          description: descCtrl.text.trim(),
        );

        await service.addBook(newBook);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เพิ่มหนังสือเรียบร้อยแล้ว')),
        );
      }

      Navigator.pop(context, true); // ส่งสัญญาณกลับไปให้ refresh
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'แก้ไขหนังสือ' : 'เพิ่มหนังสือใหม่'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title
              TextFormField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'ชื่อหนังสือ',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'กรุณากรอกชื่อหนังสือ' : null,
              ),
              const SizedBox(height: 20),

              // Author
              TextFormField(
                controller: authorCtrl,
                decoration: const InputDecoration(
                  labelText: 'ผู้แต่ง',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'กรุณากรอกชื่อผู้แต่ง' : null,
              ),
              const SizedBox(height: 20),

              // Year
              TextFormField(
                controller: yearCtrl,
                decoration: const InputDecoration(
                  labelText: 'ปีที่พิมพ์',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Genre
              TextFormField(
                controller: genreCtrl,
                decoration: const InputDecoration(
                  labelText: 'หมวดหมู่',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Cover URL
              TextFormField(
                controller: coverCtrl,
                decoration: const InputDecoration(
                  labelText: 'ลิงก์ภาพหน้าปก (URL)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Description
              TextFormField(
                controller: descCtrl,
                decoration: const InputDecoration(
                  labelText: 'คำอธิบายเพิ่มเติม',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveOrUpdateBook,
                  icon: Icon(isEdit ? Icons.save : Icons.add),
                  label: Text(isEdit ? 'บันทึกการแก้ไข' : 'เพิ่มหนังสือ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
