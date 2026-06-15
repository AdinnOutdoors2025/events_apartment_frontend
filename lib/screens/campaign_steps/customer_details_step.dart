import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/constant.dart';

import '../../providers/campaign_provider.dart';
import '../../utils/api_service.dart';

class CustomerDetailsStep extends ConsumerStatefulWidget {
  const CustomerDetailsStep({super.key});

  @override
  ConsumerState<CustomerDetailsStep> createState() =>
      _CustomerDetailsStepState();
}

class _CustomerDetailsStepState extends ConsumerState<CustomerDetailsStep> {
  final _brandCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _gstCtrl = TextEditingController();
  final _designationCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String? _selectedType; // 'Brand' or 'Agency'
  bool _isLoading = true;
  String? _phoneError;
  bool _isGstFromApi = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    // 1. Fetch user profile from API first to see if GST number exists in API
    try {
      final userId = await StorageService.getId();
      if (userId != null && userId.isNotEmpty) {
        final apiService = ApiService();
        final profile = await apiService.getUserProfile(userId);
        final data = profile.data;
        if (data != null) {
          final apiGst = data.gstNumber?.trim() ?? '';
          if (apiGst.isNotEmpty) {
            _isGstFromApi = true;
          }
          
          // If the campaign state doesn't have customerBrandName yet, prefill from profile
          final state = ref.read(campaignProvider);
          if (state.customerBrandName == null || state.customerBrandName!.trim().isEmpty) {
            _brandCtrl.text = data.companyBrandName ?? '';
            _contactCtrl.text = data.brandOwnerName ?? '';
            _emailCtrl.text = data.email ?? '';
            _gstCtrl.text = data.gstNumber ?? '';
            if (data.customerType != null) {
              _selectedType = data.customerType == 1 ? 'Brand' : (data.customerType == 2 ? 'Agency' : null);
            }
            _syncToState();
          }
        }
      }
    } catch (e) {
      debugPrint('Failed to load profile: $e');
    }

    // 2. If campaign state already has values, override the controllers with those values
    final state = ref.read(campaignProvider);
    if (state.customerBrandName != null && state.customerBrandName!.trim().isNotEmpty) {
      _brandCtrl.text = state.customerBrandName ?? '';
      _contactCtrl.text = state.customerContactName ?? '';
      _phoneCtrl.text = state.customerPhone ?? '';
      _emailCtrl.text = state.customerEmail ?? '';
      _gstCtrl.text = state.customerGst ?? '';
      _designationCtrl.text = state.customerDesignation ?? '';
      _notesCtrl.text = state.customerNotes ?? '';
      final savedType = state.customerType;
      _selectedType = savedType == '1' ? 'Brand' : (savedType == '2' ? 'Agency' : null);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _syncToState() {
    ref.read(campaignProvider.notifier).setCustomerDetails(
          brandName: _brandCtrl.text,
          contactName: _contactCtrl.text,
          phone: _phoneCtrl.text,
          email: _emailCtrl.text,
          gst: _gstCtrl.text,
          designation: _designationCtrl.text,
          type: _selectedType == 'Brand' ? '1' : (_selectedType == 'Agency' ? '2' : null),
          notes: _notesCtrl.text,
        );
  }

  @override
  void dispose() {
    _brandCtrl.dispose();
    _contactCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _gstCtrl.dispose();
    _designationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFE5212A)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STEP · CUSTOMER DETAILS',
            style: GoogleFonts.inter(
              color: const Color(0xFFE5212A),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Brand / Company Information',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This information will be included in your campaign brief.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          // ── TYPE SELECTION ──
          Text(
            'TYPE',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: ['Brand', 'Agency'].map((type) {
              final selected = _selectedType == type;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: type == 'Brand' ? 6 : 0,
                    left: type == 'Agency' ? 6 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedType = type);
                      _syncToState();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFE5212A)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFFE5212A)
                              : Colors.grey.shade200,
                          width: selected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            type == 'Brand'
                                ? Icons.business
                                : Icons.groups_rounded,
                            size: 20,
                            color:
                                selected ? Colors.white : Colors.grey[500],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            type,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                          ),
                          if (selected) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.check_circle,
                                size: 14, color: Colors.white),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // ── FORM FIELDS ──
          _buildField(
            label: 'BRAND / COMPANY NAME',
            controller: _brandCtrl,
            hint: 'Enter brand or company name',
            icon: Icons.storefront_outlined,
          ),
          const SizedBox(height: 20),
          _buildField(
            label: 'CONTACT PERSON NAME',
            controller: _contactCtrl,
            hint: 'Enter contact person name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 20),
          _buildField(
            label: 'CONTACT PHONE NUMBER',
            controller: _phoneCtrl,
            hint: 'Enter 10-digit phone number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            onChanged: (val) {
              _syncToState();
              setState(() {
                if (val.length < 10 && val.isNotEmpty) {
                  _phoneError = 'Please enter a valid 10-digit number';
                } else {
                  _phoneError = null;
                }
              });
            },
            errorText: _phoneError,
          ),
          const SizedBox(height: 20),
          _buildField(
            label: 'EMAIL',
            controller: _emailCtrl,
            hint: 'Enter email address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          _buildField(
            label: 'GST NUMBER',
            controller: _gstCtrl,
            hint: 'Enter GST number',
            icon: Icons.receipt_long_outlined,
            enabled: !_isGstFromApi,
          ),
          const SizedBox(height: 20),
          _buildField(
            label: 'DESIGNATION',
            controller: _designationCtrl,
            hint: 'e.g. Marketing Manager',
            icon: Icons.badge_outlined,
          ),

          const SizedBox(height: 28),

          // ── NOTES ──
          Text(
            'NOTES (OPTIONAL)',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            maxLines: 4,
            controller: _notesCtrl,
            onChanged: (_) => _syncToState(),
            decoration: InputDecoration(
              hintText: 'Any additional information about the client...',
              hintStyle: GoogleFonts.inter(
                color: Colors.grey[400],
                fontSize: 13,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.black),
              ),
            ),
          ),

          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    void Function(String)? onChanged,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          onChanged: onChanged ?? (_) => _syncToState(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: Icon(icon, size: 20, color: Colors.grey[500]),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade100,
            counterText: '',
            errorText: errorText,
            errorStyle: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFFE5212A),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.black),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFFE5212A)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFFE5212A)),
            ),
          ),
        ),
      ],
    );
  }
}
