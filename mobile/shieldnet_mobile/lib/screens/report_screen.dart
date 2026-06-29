import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../theme.dart';
import '../widgets/hero_section.dart';
import '../widgets/image_upload_field.dart';
import '../widgets/field_label.dart';
import 'success_screen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();
  final _harasserUsernameController = TextEditingController();
  final _harasserProfileUrlController = TextEditingController();
  final _contactController = TextEditingController();

  final String _country = 'Pakistan';

  String? _category;
  String? _platform;

  PickedFile? _originalImage;
  PickedFile? _fakeImage;
  PickedFile? _video;

  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _descriptionController.dispose();
    _harasserUsernameController.dispose();
    _harasserProfileUrlController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  bool get _needsImages =>
      _category != null && ShieldNetValues.imageBasedCategories.contains(_category);

  bool get _needsVideo => _category == 'Deepfake video'; // fixed: lowercase v

  Future<void> _pickOriginal() async {
    final file = await pickImageFile();
    if (file != null) setState(() => _originalImage = file);
  }

  Future<void> _pickFake() async {
    final file = await pickImageFile();
    if (file != null) setState(() => _fakeImage = file);
  }

  Future<void> _pickVideo() async {
    final file = await pickVideoFile();
    if (file != null) setState(() => _video = file);
  }

  Future<void> _saveTokenLocally(String token, int? reportId) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList('saved_tokens') ?? [];
    if (!existing.contains(token)) {
      existing.add(token);
      await prefs.setStringList('saved_tokens', existing);
    }
    await prefs.setString('last_token', token);
    if (reportId != null) {
      await prefs.setInt('last_report_id', reportId);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_category == null || _platform == null) {
      setState(() {
        _errorMessage = 'Please fill in all required fields above.';
      });
      return;
    }
    if (_needsImages && (_originalImage == null || _fakeImage == null)) {
      setState(() {
        _errorMessage =
            'This category requires both the original and edited image.';
      });
      return;
    }
    if (_needsVideo && _video == null) {
      setState(() {
        _errorMessage = 'Please upload the video for this category.';
      });
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      final result = await ApiService.submitReport(
        country: _country,
        category: _category!,
        platform: _platform!,
        description: _descriptionController.text.trim(),
        harasserUsername: _harasserUsernameController.text.trim(),
        harasserProfileUrl: _harasserProfileUrlController.text.trim(),
        contact: _contactController.text.trim(),
      );

      final token = result['token']?.toString() ?? '';
      final reportId = result['report_id'] is int
          ? result['report_id'] as int
          : int.tryParse(result['report_id']?.toString() ?? '');

      if (_needsImages &&
          reportId != null &&
          _originalImage != null &&
          _fakeImage != null) {
        try {
          await ApiService.analyzeReportImages(
            reportId: reportId,
            originalImage: _originalImage!,
            fakeImage: _fakeImage!,
          );
        } catch (_) {}
      }

      if (_needsVideo && reportId != null && _video != null) {
        try {
          await ApiService.uploadReportVideo(
            reportId: reportId,
            video: _video!,
          );
        } catch (_) {}
      }

      await _saveTokenLocally(token, reportId);

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SuccessScreen(token: token, reportId: reportId),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e is ApiException
            ? e.message
            : 'Something went wrong submitting your report. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Phone-realistic content width: even when tested wide in
    // flutter run -d chrome, the form never stretches past a
    // sensible mobile reading width.
    const maxContentWidth = 430.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Report Incident')),
      body: SingleChildScrollView(
        child: HeroSection(
          eyebrow: 'Anonymous · Encrypted · Free',
          headline: 'Report an incident',
          subtitle: 'Submit anonymously — no account needed.',
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxContentWidth),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Country ──────────────────────────────────
                    const FieldLabel(
                      icon: Icons.public_rounded,
                      text: 'Country',
                    ),
                    _ReadOnlyBox(value: _country),

                    const SizedBox(height: 20),

                    // ── Category ─────────────────────────────────
                    const FieldLabel(
                      icon: Icons.sell_rounded,
                      text: 'Category',
                      required: true,
                    ),
                    _buildDropdown(
                      value: _category,
                      items: ShieldNetValues.categories,
                      hint: 'Select a category',
                      onChanged: (v) => setState(() {
                        _category = v;
                        if (!_needsImages) {
                          _originalImage = null;
                          _fakeImage = null;
                        }
                        if (!_needsVideo) {
                          _video = null;
                        }
                      }),
                    ),

                    const SizedBox(height: 20),

                    // ── Platform ─────────────────────────────────
                    const FieldLabel(
                      icon: Icons.smartphone_rounded,
                      text: 'Platform',
                      required: true,
                    ),
                    _buildDropdown(
                      value: _platform,
                      items: ShieldNetValues.platforms,
                      hint: 'Select a platform',
                      onChanged: (v) => setState(() => _platform = v),
                      displayLabel: (p) => p[0].toUpperCase() + p.substring(1),
                    ),

                    const SizedBox(height: 20),

                    // ── Harasser username ─────────────────────────
                    const FieldLabel(
                      icon: Icons.person_rounded,
                      text: 'Harasser Username',
                      required: true,
                    ),
                    TextFormField(
                      controller: _harasserUsernameController,
                      decoration: const InputDecoration(
                        hintText: '@username of the harasser',
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'This field is required'
                          : null,
                    ),

                    const SizedBox(height: 20),

                    // ── Profile URL ───────────────────────────────
                    const FieldLabel(
                      icon: Icons.link_rounded,
                      text: 'Harasser Profile URL',
                    ),
                    TextFormField(
                      controller: _harasserProfileUrlController,
                      decoration: const InputDecoration(
                        hintText: 'https://instagram.com/username',
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Description ───────────────────────────────
                    const FieldLabel(
                      icon: Icons.description_rounded,
                      text: 'Description',
                      required: true,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Describe what happened in detail...',
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Please describe what happened'
                          : null,
                    ),

                    if (_needsImages) ...[
                      const SizedBox(height: 20),
                      const FieldLabel(
                        icon: Icons.image_rounded,
                        text: 'Evidence — required for this category',
                        required: true,
                      ),
                      const SizedBox(height: 4),
                      ImageUploadField(
                        label: 'Original image',
                        file: _originalImage,
                        onPick: _pickOriginal,
                        onRemove: () => setState(() => _originalImage = null),
                      ),
                      const SizedBox(height: 10),
                      ImageUploadField(
                        label: 'Edited / fake image',
                        file: _fakeImage,
                        onPick: _pickFake,
                        onRemove: () => setState(() => _fakeImage = null),
                      ),
                    ],

                    if (_needsVideo) ...[
                      const SizedBox(height: 20),
                      const FieldLabel(
                        icon: Icons.videocam_rounded,
                        text: 'Evidence — required for this category',
                        required: true,
                      ),
                      const SizedBox(height: 4),
                      ImageUploadField(
                        label: 'Deepfake video',
                        file: _video,
                        onPick: _pickVideo,
                        onRemove: () => setState(() => _video = null),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // ── Contact ────────────────────────────────────
                    const FieldLabel(
                      icon: Icons.mail_outline_rounded,
                      text: 'Your Contact',
                    ),
                    TextFormField(
                      controller: _contactController,
                      decoration: const InputDecoration(
                        hintText: 'Email or phone for follow-up',
                      ),
                    ),

                    const SizedBox(height: 28),

                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.error.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.error.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline_rounded,
                                color: AppTheme.error, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: GoogleFonts.inter(
                                  color: AppTheme.error,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : _submit,
                        child: _submitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : const Text('Submit Report'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'The server may take 10–15 seconds to respond if it has '
                      'been idle.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String hint,
    String Function(String)? displayLabel,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(hintText: hint),
      dropdownColor: Theme.of(context).cardColor,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(displayLabel?.call(item) ?? item),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Please make a selection' : null,
    );
  }
}

/// Read-only display box for the locked Country field — styled to match
/// the other inputs so the form feels consistent even though this one
/// isn't editable.
class _ReadOnlyBox extends StatelessWidget {
  final String value;

  const _ReadOnlyBox({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Icon(Icons.lock_outline_rounded,
              size: 16, color: AppTheme.textSecondary),
        ],
      ),
    );
  }
}