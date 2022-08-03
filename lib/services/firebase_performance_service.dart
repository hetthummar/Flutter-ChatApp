import 'package:firebase_performance/firebase_performance.dart';

class FirebasePerformanceService{

  final FirebasePerformance _firebasePerformance = FirebasePerformance.instance;
  late HttpMetric metric;

  startHttpTracking(String url){
    metric = _firebasePerformance.newHttpMetric(url, HttpMethod.Get);
    metric.start();
  }

  stopHttpTracking(int responseCode){
      metric.httpResponseCode = responseCode;
      metric.stop();
  }

  stopHttpTrackingWithError({int responseCode = 500}){
    metric.httpResponseCode = responseCode;
    metric.stop();
  }
}