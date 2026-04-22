 int toInt(dynamic value) {
if (value is int) return value;
return int.tryParse(value?.toString() ?? '') ?? 0;
}

 double toDouble(dynamic value) {
if (value is double) return value;
if (value is int) return value.toDouble();
return double.tryParse(value?.toString() ?? '') ?? 0.0;
}
