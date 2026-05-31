import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget BuildRecipeImage(String url) {
  if (url.isEmpty) {
    // If no URL, show a placeholder from your assets
    return Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover);
  }
  
  if (url.startsWith('http')) {
    // If it's a web link, use NetworkImage with a loading spinner
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
    );
  } else {
    // If it's a local path string
    return Image.asset(url, fit: BoxFit.cover);
  }
}
