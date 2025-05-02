class ProfileImage {
  String? url;

  ProfileImage({this.url});

  factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
        url: json['url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'url': url,
      };
}
