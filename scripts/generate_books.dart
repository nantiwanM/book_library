import 'package:faker/faker.dart';
import 'package:pocketbase/pocketbase.dart';

void main() async {
  final pb = PocketBase('http://127.0.0.1:8090');
  final faker = Faker();

  // login
  try {
    await pb
        .collection('_superusers')
        .authWithPassword('admin@gmail.com', 'admin123456789');
    print('Logged in as superuser!');
  } catch (e) {
    print('Login failed: $e');
    return;
  }

  // สร้างข้อมูลจำลอง 100 รายการ
  for (int i = 0; i < 2; i++) {
    final book = {
      'title': faker.lorem.words(3).join(' '),
      'author': faker.person.name(),
      'year': faker.date.dateTime(minYear: 1990, maxYear: 2025).year,
      'coverUrl': 'https://placehold.co/200x300.png?text=Book+${i + 1}',
      'genre': faker.lorem.word(),
      'description': faker.lorem.sentence(),
    };

    try {
      await pb.collection('books').create(body: book);
    } catch (e) {
      print('Failed to add book #$i: $e');
    }
  }
  print('Created fake books successfully!');
}
