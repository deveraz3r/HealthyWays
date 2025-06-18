enum RepetitionType { daily, weekdays, customDates, none }

extension RepetitionTypeExtension on RepetitionType {
  String get name {
    switch (this) {
      case RepetitionType.daily:
        return 'Daily';
      case RepetitionType.weekdays:
        return 'Weekdays';
      case RepetitionType.customDates:
        return 'Custom Dates';
      case RepetitionType.none:
        return 'None';
    }
  }

  static RepetitionType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'daily':
        return RepetitionType.daily;
      case 'weekdays':
        return RepetitionType.weekdays;
      case 'custom dates':
        return RepetitionType.customDates;
      case 'none':
        return RepetitionType.none;
      default:
        return RepetitionType.daily;
    }
  }
}
