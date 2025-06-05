import 'package:flutter/material.dart';
import 'package:healthyways/features/measurements/domain/entites/preset_measurement.dart';
import 'package:healthyways/features/measurements/presentation/pages/measurement_details_page.dart';

class MyMeasurementCard extends StatelessWidget {
  final PresetMeasurement measurement;
  const MyMeasurementCard({super.key, required this.measurement});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MeasurementDetailsPage.route(measurement)),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              const SizedBox(width: 12),
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(measurement.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(measurement.category, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
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
