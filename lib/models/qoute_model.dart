class Quote {
  final String text;
  final String author;

  const Quote({required this.text, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['body'] as String? ?? 'No quote available',
      author: json['author'] as String? ?? 'Unknown',
    );
  }
}
