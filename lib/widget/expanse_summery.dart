import 'package:expanse/provider/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class StylishExpenseChart extends StatelessWidget {
  // Define a list of gradient colors for bars
  final List<List<Color>> gradientColors = [
    [Color(0xff23b6e6), Color(0xff02d39a)],
    [Color(0xfff7971e), Color(0xffffd200)],
    [Color(0xff8E2DE2), Color(0xff4A00E0)],
    [Color(0xffee0979), Color(0xffff6a00)],
    [Color(0xff00c6ff), Color(0xff0072ff)],
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        final expenses = provider.expenses;
        final Map<String, double> categoryTotals = {};

        // Calculate totals for each category
        for (var expense in expenses) {
          categoryTotals[expense.category] =
              (categoryTotals[expense.category] ?? 0) + expense.amount;
        }

        return Container(
          height: 260,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(bottom: 10, left: 7, right: 7),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 109, 147, 178),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: categoryTotals.values.isEmpty
                  ? 100
                  : categoryTotals.values.reduce((a, b) => a > b ? a : b) * 1.2,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  // tooltipBgColor: Colors.blueGrey.withOpacity(0.9),
                  tooltipPadding: EdgeInsets.all(8),
                  tooltipMargin: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${categoryTotals.keys.elementAt(groupIndex)}\n',
                      TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: '\$${rod.toY.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      final categories = categoryTotals.keys.toList();
                      if (value >= 0 && value < categories.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            categories[value.toInt()],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              fontFamily: 'Lexend-Bold',
                            ),
                          ),
                        );
                      }
                      return Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '\$${value.toInt()}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'Lexend-Bold'),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 50,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey[300],
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                  left: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              barGroups: List.generate(
                categoryTotals.length,
                (index) => BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: categoryTotals.values.elementAt(index),
                      gradient: LinearGradient(
                        colors: gradientColors[index % gradientColors.length],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      width: 20,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: categoryTotals.values
                                .reduce((a, b) => a > b ? a : b) *
                            1.2,
                        color: Colors.grey[200],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            swapAnimationDuration: Duration(milliseconds: 750),
            swapAnimationCurve: Curves.easeInOutCubic,
          ),
        );
      },
    );
  }
}
