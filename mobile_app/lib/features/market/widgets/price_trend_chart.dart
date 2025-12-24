import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PriceTrendChart extends StatelessWidget {
  const PriceTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(1, 1700),
                FlSpot(2, 1750),
                FlSpot(3, 1720),
                FlSpot(4, 1800),
                FlSpot(5, 1900),
              ],
              isCurved: true,
              color: Colors.green,
              barWidth: 4,
              dotData: FlDotData(show: false),
            )
          ],
        ),
      ),
    );
  }
}

