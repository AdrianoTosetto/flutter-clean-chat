import 'package:flutter/cupertino.dart';

abstract class ViewModel<T> extends ValueNotifier<T> {
  ViewModel(T value) : super(value);
}
