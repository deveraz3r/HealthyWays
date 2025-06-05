import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:healthyways/features/measurements/domain/entites/measurement_entry.dart';

class MeasurementEntryCard extends StatelessWidget {
  final MeasurementEntry measurementEntry;
  const MeasurementEntryCard({super.key, required this.measurementEntry});

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat(
      'MMM d, y • hh:mm a',
    ).format(measurementEntry.lastUpdated);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Value
            Text(
              '${measurementEntry.value}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Optional note
            if (measurementEntry.note.isNotEmpty)
              Text(
                measurementEntry.note,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),

            const SizedBox(height: 6),

            // Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateFormatted,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
