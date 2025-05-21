import 'package:get/get.dart';
import 'state.dart';

class StateController<ErrorType, DataType> {
  final _state = Rx<State>(State.initial);
  final _data = Rxn<DataType>();
  final _errorMessage = Rxn<ErrorType>();

  State get state => _state.value;
  Rx<State> get rxState => _state;
  DataType? get data => _data.value;
  ErrorType? get errorMessage => _errorMessage.value;

  void setLoading() {
    _state.value = State.loading;
    _errorMessage.value = null;
  }

  void setData(DataType value) {
    _data.value = value;
    _state.value = State.success;
  }

  void setError(ErrorType error) {
    _errorMessage.value = error;
    _state.value = State.error;
  }

  void reset() {
    _state.value = State.initial;
    _errorMessage.value = null;
    _data.value = null;
  }

  bool get isLoading => _state.value == State.loading;
  bool get isSuccess => _state.value == State.success;
  bool get isError => _state.value == State.error;
  bool get hasData => _data.value != null;
}
