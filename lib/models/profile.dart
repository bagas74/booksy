/// Merepresentasikan data dari tabel 'profiles' di Supabase.
class Profile {
  final String id;
  final String? fullName;
  final String? avatarUrl;
  // --- FIELD BARU ---
  final String? gender;
  final DateTime? dateOfBirth;
  final String? phoneNumber;

  Profile({
    required this.id,
    this.fullName,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
    this.phoneNumber,
  });

  /// Factory constructor untuk membuat instance Profile dari JSON.
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      gender: json['gender'],
      dateOfBirth:
          json['date_of_birth'] == null
              ? null
              : DateTime.parse(json['date_of_birth']),
      phoneNumber: json['phone_number'],
    );
  }
}
