class HobbySwipe {
  int id;
  String summary;
  String imageBase64;
  String? details;

  HobbySwipe(this.id, this.summary, this.imageBase64, [this.details]);

  factory HobbySwipe.fromJson(Map<String, dynamic> json) {
    return HobbySwipe(
      json['id'],
      json['summary'],
      json['imageBase64'],
      json['details'],
    );
  }
}
