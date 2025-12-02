import 'package:flutter/material.dart';

/// Information card widget for displaying key-value pairs
class InfoCard extends StatelessWidget {
  final String title;
  final String? value;
  final Widget? valueWidget;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.title,
    this.value,
    this.valueWidget,
    this.icon,
    this.color,
    this.onTap,
  }) : assert(
         value != null || valueWidget != null,
         'Either value or valueWidget must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (color ?? Theme.of(context).primaryColor)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color ?? Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    valueWidget ??
                        Text(
                          value ?? '',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


