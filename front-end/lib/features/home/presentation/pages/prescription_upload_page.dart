import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../prescription/presentation/bloc/prescription_bloc.dart';
import '../../../prescription/presentation/bloc/prescription_event.dart';
import '../../../prescription/presentation/bloc/prescription_state.dart';

class PrescriptionUploadPage extends StatefulWidget {
  const PrescriptionUploadPage({super.key});

  @override
  State<PrescriptionUploadPage> createState() => _PrescriptionUploadPageState();
}

class _PrescriptionUploadPageState extends State<PrescriptionUploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Ahmed Mohamed');
  final _notesController = TextEditingController();
  final _addressController = TextEditingController(text: '10 Road 9, Maadi, Cairo');

  String? _uploadedFilePath;
  String? _displayFileName;
  final ImagePicker _picker = ImagePicker();
  bool _isScanning = false;
  bool _isSubmitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickFile(String type) async {
    try {
      String? filePath;
      String? fileName;

      if (type == 'camera') {
        final XFile? photo = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );
        if (photo != null) {
          filePath = photo.path;
          fileName = photo.name;
        }
      } else if (type == 'gallery') {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );
        if (image != null) {
          filePath = image.path;
          fileName = image.name;
        }
      } else if (type == 'pdf') {
        final FilePickerResult? result = await FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );
        if (result != null && result.files.single.path != null) {
          filePath = result.files.single.path;
          fileName = result.files.single.name;
        }
      }

      if (!mounted) return;

      if (filePath != null && fileName != null) {
        setState(() {
          _uploadedFilePath = filePath;
          _displayFileName = fileName;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Prescription loaded: $fileName'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _submitPrescription() {
    if (!_formKey.currentState!.validate()) return;
    if (_uploadedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload a prescription image or document first.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<PrescriptionBloc>().add(UploadPrescriptionEvent(
      patientName: _nameController.text,
      address: _addressController.text,
      filePath: _uploadedFilePath!,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary(dark);
    final bg = AppColors.background(dark);
    final card = AppColors.card(dark);
    final fg = AppColors.fg(dark);
    final muted = AppColors.muted(dark);
    final border = AppColors.border(dark);

    if (_isSubmitted) {
      return _buildSuccessScreen(bg, card, fg, muted, primary);
    }

    return BlocListener<PrescriptionBloc, PrescriptionState>(
      listener: (context, state) {
        if (state is PrescriptionLoading) {
          setState(() {
            _isScanning = true;
          });
        } else if (state is PrescriptionUploadSuccess) {
          setState(() {
            _isScanning = false;
            _isSubmitted = true;
          });
        } else if (state is PrescriptionError) {
          setState(() {
            _isScanning = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Upload failed: ${state.message}'),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          title: Text('Upload Prescription', style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner message
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: primary.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline_rounded, color: primary, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Prescription Safety Guidelines',
                                  style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Please ensure the photo contains patient name, doctor signature, medicines, and issue date clearly. We accept PNG, JPG, or PDF.',
                                  style: TextStyle(color: muted, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Upload Options ────────────────────────────────
                    Text('Choose prescription source', style: TextStyle(color: fg, fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildUploadCard('Camera', Icons.camera_alt_rounded, 'camera', card, border, primary, muted, fg),
                        const SizedBox(width: 12),
                        _buildUploadCard('Gallery', Icons.photo_library_rounded, 'gallery', card, border, primary, muted, fg),
                        const SizedBox(width: 12),
                        _buildUploadCard('Upload PDF', Icons.picture_as_pdf_rounded, 'pdf', card, border, primary, muted, fg),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── File preview status ──────────────────────────
                    if (_uploadedFilePath != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green.shade400, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _displayFileName ?? _uploadedFilePath!.split('/').last,
                                style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18),
                              onPressed: () {
                                setState(() {
                                  _uploadedFilePath = null;
                                  _displayFileName = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),

                    // ── Form fields ──────────────────────────────────
                    Text('Patient & Shipping Details', style: TextStyle(color: fg, fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 14),

                    Text('Patient Name', style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: fg),
                      decoration: const InputDecoration(hintText: 'Enter patient full name'),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter patient name' : null,
                    ),
                    const SizedBox(height: 16),

                    Text('Shipping Address', style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _addressController,
                      style: TextStyle(color: fg),
                      maxLines: 2,
                      decoration: const InputDecoration(hintText: 'Enter destination address'),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter shipping address' : null,
                    ),
                    const SizedBox(height: 16),

                    Text('Special Instructions (Optional)', style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _notesController,
                      style: TextStyle(color: fg),
                      maxLines: 3,
                      decoration: const InputDecoration(hintText: 'e.g., Substitute with generics if brand is unavailable, etc.'),
                    ),
                    const SizedBox(height: 30),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitPrescription,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusSm)),
                        ),
                        child: const Text(
                          'Submit Prescription',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            if (_isScanning)
              Container(
                color: Colors.black.withValues(alpha: 0.6),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    margin: const EdgeInsets.all(32),
                    decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 20),
                        Text(
                          'Scanning prescription…',
                          style: TextStyle(color: fg, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Digitizing items for pharmacist review',
                          style: TextStyle(color: muted, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildUploadCard(
    String title,
    IconData icon,
    String type,
    Color card,
    Color border,
    Color primary,
    Color muted,
    Color fg,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _pickFile(type),
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: primary, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessScreen(Color bg, Color card, Color fg, Color muted, Color primary) {
    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle_rounded, color: Colors.green.shade400, size: 54),
              ),
              const SizedBox(height: 28),
              Text(
                'Prescription Received!',
                style: TextStyle(color: fg, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Our pharmacists are reviewing your prescription. Once verified, we will add the medicines to your cart and send you a notification to confirm checkout.',
                style: TextStyle(color: muted, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border(Theme.of(context).brightness == Brightness.dark)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Patient Name', style: TextStyle(color: muted, fontSize: 12)),
                        Text(_nameController.text, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estimate Review Time', style: TextStyle(color: muted, fontSize: 12)),
                        Text('5 - 10 minutes', style: TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusSm)),
                  ),
                  child: const Text('Back to Home', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
