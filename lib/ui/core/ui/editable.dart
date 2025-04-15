import 'package:flutter/material.dart';

class TypedTextEditingController<T> extends TextEditingController {
  T _data;
  final T _init;
  Function(T)? toText;
  T Function(String)? toData;

  TypedTextEditingController(T init, {this.toText, this.toData})
      : _data = init,
        _init = init;

  T get data {
    if (toData != null) {
      return toData!(text);
    }

    return _data;
  }

  set data(T d) {
    _data = d;

    if (toText != null && _data != null) {
      super.text = toText?.call(_data);
    }
  }

  @override
  void clear() {
    _data = _init;
    super.clear();
  }

  @override
  set text(String newText) {
    // assert(toData != null);

    if (toData != null && super.text.isNotEmpty) {
      data = toData!.call(newText);
    }

    super.text = newText;
  }
}

typedef DateTimeEditingController = TypedTextEditingController<DateTime?>;

class TrimedTextEditingController extends TypedTextEditingController<String> {
  TrimedTextEditingController(super.init) {
    toData = (p0) {
      return text.trim();
    };
  }
}
