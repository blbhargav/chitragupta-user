import 'package:charts_flutter/flutter.dart' as charts;

class Utils {
  static final foodColor = charts.MaterialPalette.blue.makeShades(2)[2];
  static final entertainColor =
      charts.MaterialPalette.deepOrange.makeShades(2)[1];
  static final travelColor = charts.MaterialPalette.lime.makeShades(2)[1];
  static final snacksColor = charts.MaterialPalette.teal.makeShades(2)[1];
  static final fuelColor = charts.MaterialPalette.yellow.makeShades(2)[2];
  static final billsColor = charts.MaterialPalette.indigo.makeShades(2)[2];
  static final shoppingColor = charts.MaterialPalette.pink.makeShades(2)[1];
  static final healthColor = charts.MaterialPalette.green.makeShades(2)[2];
  static final otherColor = charts.MaterialPalette.purple.makeShades(2)[2];
  static final defaultColor = charts.MaterialPalette.gray.makeShades(2)[2];

  static List<charts.Series<LinearBudgets, String>> createBarData(data) {
    return [
      new charts.Series<LinearBudgets, String>(
          id: 'Budget',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (LinearBudgets spend, _) => spend.budget,
          measureFn: (LinearBudgets spend, _) => spend.amount,
          data: data,
          labelAccessorFn: (LinearBudgets spend, _) =>
              '${spend.amount}')
    ];
  }

  static List<charts.Series<LinearBudgets, String>> createPieData(data) {
    return [
      new charts.Series<LinearBudgets, String>(
        id: 'Budget',
        domainFn: (LinearBudgets spend, _) => spend.budget,
        measureFn: (LinearBudgets spend, _) => spend.amount,
        data: data,
        colorFn: (LinearBudgets spend, _) {
          switch (spend.budget) {
            case "Food":
              return foodColor;
            case "Entertainment":
              return entertainColor;
            case "Travel":
              return travelColor;
            case "Snacks":
              return snacksColor;
            case "Fuel":
              return fuelColor;
            case "Bills":
              return billsColor;
            case "Shopping":
              return shoppingColor;
            case "Health":
              return healthColor;
            case "Others":
              return otherColor;
            default:
              return defaultColor;
          }
        },
        labelAccessorFn: (LinearBudgets spend, _) =>
            '${spend.budget}: ${spend.amount}',
      )
    ];
  }

  static List<charts.Series<TimeBudget, DateTime>> createTimeData(data) {
    return [
      new charts.Series<TimeBudget, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeBudget spend, _) => spend.time,
        measureFn: (TimeBudget spend, _) => spend.amount,
        data: data,
      )
    ];
  }
}

class LinearBudgets {
  final String budget;
  final int amount;

  LinearBudgets(this.budget, this.amount);
}

class TimeBudget {
  final DateTime time;
  final int amount;

  TimeBudget(this.time, this.amount);
}
