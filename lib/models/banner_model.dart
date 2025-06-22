// lib/models/banner_model.dart

class BannerModel {
  final String imageUrl;
  final String? targetUrl; // Bisa null jika banner tidak bisa diklik

  BannerModel({required this.imageUrl, this.targetUrl});

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      imageUrl: map['image_url'] as String,
      targetUrl: map['target_url'] as String?,
    );
  }
}
