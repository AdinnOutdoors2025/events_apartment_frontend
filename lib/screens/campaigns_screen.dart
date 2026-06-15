import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  String _selectedTab = 'All';
  String _searchQuery = '';
  List<Map<String, dynamic>> _allBookings = [];
  bool _isLoading = true;

  final List<String> _tabs = ['All', 'Confirmed', 'Upcoming', 'Completed'];

  // Mock initial bookings to pre-fill the screen beautifully if empty
  final List<Map<String, dynamic>> _mockBookings = [
    {
      'bookingId': 'BKNG-2026-0614-7821',
      'apartmentName': 'Lakeview Heights – 2BHK',
      'location': 'Koramangala, Bengaluru',
      'stayDates': '14 Jun - 20 Jun 2026',
      'totalAmount': '₹60,000',
      'status': 'Confirmed',
      'nights': '6 nights',
      'imageUrl': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=500&auto=format&fit=crop&q=60'
    },
    {
      'bookingId': 'BKNG-2026-0705-1940',
      'apartmentName': 'Skyline Residency – 3BHK',
      'location': 'Whitefield, Bengaluru',
      'stayDates': '05 Jul - 11 Jul 2026',
      'totalAmount': '₹72,000',
      'status': 'Upcoming',
      'nights': '6 nights',
      'imageUrl': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=500&auto=format&fit=crop&q=60'
    },
    {
      'bookingId': 'BKNG-2026-0528-3482',
      'apartmentName': 'Greenview Apartments – 2BHK',
      'location': 'HSR Layout, Bengaluru',
      'stayDates': '28 May - 01 Jun 2026',
      'totalAmount': '₹48,000',
      'status': 'Completed',
      'nights': '5 nights',
      'imageUrl': 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=500&auto=format&fit=crop&q=60'
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookingsJsonList = prefs.getStringList('booked_campaigns') ?? [];
      
      List<Map<String, dynamic>> savedBookings = [];
      for (final jsonStr in bookingsJsonList) {
        try {
          final map = Map<String, dynamic>.from(jsonDecode(jsonStr));
          savedBookings.add(map);
        } catch (e) {
          debugPrint('Error parsing booked campaign: $e');
        }
      }

      setState(() {
        // We prepend the saved bookings so they show up at the top, and append the mock bookings
        _allBookings = [...savedBookings, ..._mockBookings];
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading booked campaigns: $e');
      setState(() {
        _allBookings = _mockBookings;
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredBookings {
    return _allBookings.where((booking) {
      // 1. Tab filter
      if (_selectedTab != 'All') {
        final bookingStatus = booking['status']?.toString().toLowerCase() ?? '';
        final selected = _selectedTab.toLowerCase();
        if (bookingStatus != selected) return false;
      }
      
      // 2. Search query filter
      if (_searchQuery.isNotEmpty) {
        final name = booking['apartmentName']?.toString().toLowerCase() ?? '';
        final location = booking['location']?.toString().toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        if (!name.contains(query) && !location.contains(query)) return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredBookings;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        title: Text(
          'My Campaigns',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Quick refresh
              setState(() {
                _isLoading = true;
              });
              _loadBookings();
            },
            icon: const Icon(Icons.refresh, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by apartment or location',
                        hintStyle: GoogleFonts.inter(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.tune_outlined, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          // Horizontal tabs
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _tabs.length,
              itemBuilder: (context, index) {
                final tab = _tabs[index];
                final isSelected = _selectedTab == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(tab),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedTab = tab;
                        });
                      }
                    },
                    selectedColor: const Color(0xFFE5212A),
                    backgroundColor: Colors.white,
                    labelStyle: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFFE5212A) : Colors.grey.shade200,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Booking Count Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0EF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5212A).withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_note, color: Color(0xFFE5212A)),
                  const SizedBox(width: 12),
                  Text(
                    'Total Bookings',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${filtered.length} booked campaigns',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE5212A),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Bookings List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFE5212A)))
                : filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.campaign_outlined, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text(
                              'No campaigns found',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final booking = filtered[index];
                          return _buildBookingCard(booking);
                        },
                      ),
          ),
          const SizedBox(height: 80), // extra bottom spacing
        ],
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final status = booking['status']?.toString() ?? 'Confirmed';
    Color statusColor;
    Color statusBgColor;

    switch (status.toLowerCase()) {
      case 'confirmed':
        statusColor = const Color(0xFF2E7D32);
        statusBgColor = const Color(0xFFE8F5E9);
        break;
      case 'upcoming':
        statusColor = const Color(0xFFEF6C00);
        statusBgColor = const Color(0xFFFFF3E0);
        break;
      case 'completed':
        statusColor = const Color(0xFF37474F);
        statusBgColor = const Color(0xFFECEFF1);
        break;
      default:
        statusColor = const Color(0xFFE5212A);
        statusBgColor = const Color(0xFFFFF0EF);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Part with Image and Info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image or Placeholder
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey[100],
                    child: booking['imageUrl'] != null
                        ? Image.network(
                            booking['imageUrl'],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.business,
                              size: 40,
                              color: Colors.grey,
                            ),
                          )
                        : const Icon(
                            Icons.business,
                            size: 40,
                            color: Colors.grey,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        booking['apartmentName'] ?? 'Apartment Name',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              booking['location'] ?? 'Location',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Summary details row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, size: 16, color: Color(0xFFE5212A)),
                  const SizedBox(width: 6),
                  Text(
                    booking['stayDates'] ?? 'Dates',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  if (booking['nights'] != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      '•  ${booking['nights']}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Price & View Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      booking['totalAmount'] ?? '₹0',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'View Details',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE5212A),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: Color(0xFFE5212A),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
