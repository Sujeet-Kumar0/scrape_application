import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RateInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageURL;
  final VoidCallback? onTap;

  const RateInfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageURL,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.48,
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(imageURL),
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(6, 12, 0, 0),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            subtitle,
            style: TextStyle(
              // color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
