import 'package:blog_app/core/constant/size_config.dart';

class AppFontSize {
  static double large = 32;
  static double h1 = 22;
  static double h2 = 20;
  static double h3 = 18;
  static double h4 = 16;
  static double h5 = 14;
  static double h6 = 12;

  // Padding Margin values
  static double value1 = 1;
  static double value4 = 4;
  static double value6 = 6;
  static double value8 = 8;
  static double value10 = 10;
  static double value12 = 12;
  static double value16 = 16;
  static double value18 = 18;
  static double value20 = 20;
  static double value22 = 22;
  static double value24 = 24;
  static double value26 = 26;
  static double value28 = 28;
  static double value30 = 30;

  static double toolbarHeight = 48;

  static void init() {
    large = SizeConfig.isTabletDevice ? 48 : 32;
    h1 = SizeConfig.isTabletDevice ? 33 : 22;
    h2 = SizeConfig.isTabletDevice ? 30 : 20;
    h3 = SizeConfig.isTabletDevice ? 27 : 18;
    h4 = SizeConfig.isTabletDevice ? 24 : 16;
    h5 = SizeConfig.isTabletDevice ? 21 : 14;
    h6 = SizeConfig.isTabletDevice ? 18 : 12;

    value4 = SizeConfig.isTabletDevice ? 6 : 4;
    value6 = SizeConfig.isTabletDevice ? 9 : 6;
    value8 = SizeConfig.isTabletDevice ? 12 : 8;
    value10 = SizeConfig.isTabletDevice ? 15 : 10;
    value12 = SizeConfig.isTabletDevice ? 18 : 12;
    value16 = SizeConfig.isTabletDevice ? 24 : 16;
    value18 = SizeConfig.isTabletDevice ? 27 : 18;
    value20 = SizeConfig.isTabletDevice ? 30 : 20;
    value22 = SizeConfig.isTabletDevice ? 33 : 22;
    value24 = SizeConfig.isTabletDevice ? 36 : 24;
    value26 = SizeConfig.isTabletDevice ? 39 : 26;
    value28 = SizeConfig.isTabletDevice ? 42 : 28;
    value30 = SizeConfig.isTabletDevice ? 45 : 30;

    toolbarHeight = SizeConfig.isTabletDevice ? 84 : 48;
  }
}
