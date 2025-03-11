class Store {
  String? id;
  String? title;
  String? category;

  Store({this.id, this.title, this.category});

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json['_id'] as String?,
        title: json['title'] as String?,
        category: json['category'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'category': category,
      };
}
