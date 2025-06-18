/// Merepresentasikan data dari tabel 'profiles' di Supabase.
class Profile {
  final String id;
  final String? fullName;
  final String? avatarUrl;

  Profile({required this.id, this.fullName, this.avatarUrl});

  /// Factory constructor untuk membuat instance Profile dari JSON.
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
    );
  }
}
