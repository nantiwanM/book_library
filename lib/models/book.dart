class Book {
  final String id;
  String title;
  String author;
  int year;
  String coverUrl;
  String genre;
  String description;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.coverUrl,
    required this.genre,
    required this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      year: json['year'] is int ? json['year'] : int.tryParse(json['year'].toString()) ?? 0,
      coverUrl: json['coverUrl'] ?? '',
      genre: json['genre'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'year': year,
      'coverUrl': coverUrl,
      'genre': genre,
      'description': description,
    };
  }
}
