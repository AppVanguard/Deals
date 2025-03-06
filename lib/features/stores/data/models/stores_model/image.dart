class Image {
  String? url;

  Image({this.url});

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        url: json['url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'url': url,
      };
}
