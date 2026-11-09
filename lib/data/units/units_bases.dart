//base is meter

enum LengthUnit {
  //each fixed unit is assigned to its meter value, to convert between them just multibly the input with its unit base and devide the result with the wanted value ex: input in kilo->centi =(input*kilometer.baseValue)/centimeter.baseValue
  millimeter("Millimeters", 0.001),
  centimeter("Centimeters", 0.01),
  meter("Meters", 1.0),
  kilometer("Kilometers", 1000.0);

  final String typeName;
  final double baseValue;

  const LengthUnit(this.typeName, this.baseValue);
}
