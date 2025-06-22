// lib/models/onboarding_item.dart

class OnboardingItem {
  final String imageUrl;
  final String title;
  final String description;

  OnboardingItem({
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  // Tambahkan factory constructor ini
  factory OnboardingItem.fromMap(Map<String, dynamic> map) {
    return OnboardingItem(
      imageUrl: map['image_url'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }
}
