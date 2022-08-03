import 'custom_base_view_model.dart';

class CustomIndexTrackingViewModel extends CustomBaseViewModel {

  int _currentIndex = 0;
  bool _reverse = false;

  int get currentIndex => _currentIndex;
  bool get reverse => _reverse;

  void setIndex(int value) {
    if (value < _currentIndex) {
      _reverse = true;
    } else {
      _reverse = false;
    }
    _currentIndex = value;
    notifyListeners();
  }

  bool isIndexSelected(int index) => _currentIndex == index;
}
