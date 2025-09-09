import 'logger.dart';

class PerformanceMonitor {
  static final Map<String, Stopwatch> _timers = {};
  static final Map<String, List<Duration>> _measurements = {};

  static void startTimer(String name) {
    if (_timers.containsKey(name)) {
      AppLogger.warning('Timer $name is already running', 'PerformanceMonitor');
      return;
    }

    _timers[name] = Stopwatch()..start();
    AppLogger.performance('Started timer: $name', 'PerformanceMonitor');
  }

  static void stopTimer(String name) {
    final timer = _timers[name];
    if (timer == null) {
      AppLogger.warning('Timer $name was not started', 'PerformanceMonitor');
      return;
    }

    timer.stop();
    final duration = timer.elapsed;

    // Store measurement
    _measurements.putIfAbsent(name, () => []).add(duration);

    // Log performance
    AppLogger.performance('Timer $name completed in ${duration.inMilliseconds}ms', 'PerformanceMonitor');

    // Clean up
    _timers.remove(name);
  }

  static Duration? getLastMeasurement(String name) {
    final measurements = _measurements[name];
    if (measurements == null || measurements.isEmpty) {
      return null;
    }
    return measurements.last;
  }

  static List<Duration> getAllMeasurements(String name) {
    return _measurements[name] ?? [];
  }

  static double getAverageTime(String name) {
    final measurements = _measurements[name];
    if (measurements == null || measurements.isEmpty) {
      return 0.0;
    }

    final total = measurements.fold<Duration>(Duration.zero, (total, duration) => total + duration);

    return total.inMicroseconds / measurements.length / 1000; // Convert to milliseconds
  }

  static void clearMeasurements(String name) {
    _measurements.remove(name);
  }

  static void clearAllMeasurements() {
    _measurements.clear();
  }

  static Map<String, double> getAverageTimes() {
    final result = <String, double>{};
    for (final name in _measurements.keys) {
      result[name] = getAverageTime(name);
    }
    return result;
  }

  static void logPerformanceReport() {
    final averages = getAverageTimes();
    if (averages.isEmpty) {
      AppLogger.info('No performance data available', 'PerformanceMonitor');
      return;
    }

    AppLogger.info('Performance Report:', 'PerformanceMonitor');
    averages.forEach((name, average) {
      AppLogger.info('$name: ${average.toStringAsFixed(2)}ms average', 'PerformanceMonitor');
    });
  }
}

// Extension for easier usage
extension PerformanceMonitorExtension on String {
  void startTimer() => PerformanceMonitor.startTimer(this);
  void stopTimer() => PerformanceMonitor.stopTimer(this);
}
