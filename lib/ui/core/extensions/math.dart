extension DoubleEx on double {
  // fixed(x): round value to no more than x decimal places.
  // for example:
  //   1.234567.fixed(4) --> 1.2346
  //   1.2.fixed(4) --> 1.2
  double fixed(int fractionDigits) =>
      double.parse(toStringAsFixed(fractionDigits));

  int decimals() {
    final decimals = toString().split('.')[1];
    return decimals.length;
  }
}
