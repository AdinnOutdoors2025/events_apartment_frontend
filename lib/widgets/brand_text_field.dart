import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: GoogleFonts.inter(
        color: Colors.grey[600],
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
    ),
  );
}

Widget buildTextField(String hint, {ValueChanged<String>? onChanged, suffixIcon}) {
  return TextField(

    decoration: InputDecoration(suffixIcon: suffixIcon,
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: Colors.grey[600], fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.black),
      ),
    ),
    onChanged: onChanged,
  );
}