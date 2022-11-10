class Recipe {
  final String title;
  final String imageUrl;

  Recipe(this.title, this.imageUrl);

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      json['title'],
      json['image'],
    );
  }
}
