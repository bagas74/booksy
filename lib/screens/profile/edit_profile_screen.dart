import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../../models/profile.dart';
import '../../config/config.dart';

// Enum untuk membuat pilihan jenis kelamin lebih aman dan bersih
enum Gender { lakiLaki, perempuan }

class EditProfileScreen extends StatefulWidget {
  final Profile currentProfile;
  const EditProfileScreen({super.key, required this.currentProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dobController;

  // State diubah untuk menggunakan enum
  Set<Gender> _selectedGender = {Gender.lakiLaki};
  DateTime? _selectedDate;
  Uint8List? _selectedImageBytes;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.currentProfile.fullName ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.currentProfile.phoneNumber ?? '',
    );

    // Inisialisasi state dari data profil yang ada
    if (widget.currentProfile.gender == 'Perempuan') {
      _selectedGender = {Gender.perempuan};
    } else {
      _selectedGender = {Gender.lakiLaki};
    }

    _selectedDate = widget.currentProfile.dateOfBirth;
    _dobController = TextEditingController(
      text:
          _selectedDate != null
              ? DateFormat('dd MMMM yyyy').format(_selectedDate!)
              : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // --- LOGIKA TIDAK BERUBAH ---
  Future<void> _pickImage() async {
    if (!kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Upload gambar saat ini hanya didukung di web.'),
        ),
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image != null) {
      _selectedImageBytes = await image.readAsBytes();
      setState(() {});
    }
  }

  Future<void> _handleUpdateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    String? newAvatarUrl;

    try {
      if (_selectedImageBytes != null) {
        newAvatarUrl = await _authService.uploadAvatar(_selectedImageBytes!);
      }

      // Mengubah enum kembali menjadi String sebelum dikirim
      final String genderString =
          _selectedGender.first == Gender.lakiLaki ? 'Laki-laki' : 'Perempuan';

      await _authService.updateProfile(
        fullName: _nameController.text.trim(),
        avatarUrl: newAvatarUrl,
        gender: genderString,
        dateOfBirth: _selectedDate,
        phoneNumber: _phoneController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // --- UI DIDESAIN ULANG ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      bottomNavigationBar: _buildBottomSaveButton(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAvatar(),
              const SizedBox(height: 40),

              _buildTextField(
                controller: _nameController,
                label: 'Nama Lengkap',
                icon: Icons.person_outline,
                validator:
                    (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Nama tidak boleh kosong'
                            : null,
              ),
              const SizedBox(height: 24),

              _buildGenderSelectionField(),
              const SizedBox(height: 24),

              _buildDatePickerField(),
              const SizedBox(height: 24),

              _buildTextField(
                controller: _phoneController,
                label: 'Nomor Telepon',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: _getImageProvider(),
            child:
                _getImageProvider() == null
                    ? Icon(Icons.person, size: 60, color: Colors.grey.shade400)
                    : null,
          ),
          Material(
            color: AppColors.primary,
            shape: const CircleBorder(),
            elevation: 2,
            child: InkWell(
              onTap: _pickImage,
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.surface,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelectionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jenis Kelamin',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<Gender>(
          style: SegmentedButton.styleFrom(
            backgroundColor: AppColors.surface,
            selectedBackgroundColor: AppColors.primary.withOpacity(0.2),
            foregroundColor: AppColors.textSecondary,
            selectedForegroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          segments: const <ButtonSegment<Gender>>[
            ButtonSegment<Gender>(
              value: Gender.lakiLaki,
              label: Text('Laki-laki'),
              icon: Icon(Icons.male),
            ),
            ButtonSegment<Gender>(
              value: Gender.perempuan,
              label: Text('Perempuan'),
              icon: Icon(Icons.female),
            ),
          ],
          selected: _selectedGender,
          onSelectionChanged: (Set<Gender> newSelection) {
            setState(() => _selectedGender = newSelection);
          },
        ),
      ],
    );
  }

  Widget _buildDatePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tanggal Lahir',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _dobController,
          readOnly: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.calendar_today_outlined,
              color: AppColors.textSecondary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.surface,
          ),
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime(1920),
              lastDate: DateTime.now(),
            );
            if (picked != null && picked != _selectedDate) {
              setState(() {
                _selectedDate = picked;
                _dobController.text = DateFormat('dd MMMM yyyy').format(picked);
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildBottomSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleUpdateProfile,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child:
              _isLoading
                  ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                  : const Text(
                    'Simpan Perubahan',
                    style: TextStyle(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
        ),
      ),
    );
  }

  ImageProvider? _getImageProvider() {
    if (kIsWeb && _selectedImageBytes != null) {
      return MemoryImage(_selectedImageBytes!);
    }
    if (widget.currentProfile.avatarUrl != null &&
        widget.currentProfile.avatarUrl!.isNotEmpty) {
      return NetworkImage(widget.currentProfile.avatarUrl!);
    }
    return null;
  }
}
