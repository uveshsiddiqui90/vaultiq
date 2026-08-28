import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),

          Text(
            "Spending Overview",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 20),

          spendingDonutChart(),
        ],
      ),
    );
  }

  Widget spendingDonutChart() {
    return SizedBox(
      height: 220,
      child: PieChart(
        PieChartData(
          sectionsSpace: 3,
          centerSpaceRadius: 60,
          sections: [
            PieChartSectionData(
              value: 5000,
              title: '',
              radius: 45,
              color: Colors.green,
            ),
            PieChartSectionData(
              value: 3000,
              title: '',
              radius: 45,
              color: Colors.blue,
            ),
            PieChartSectionData(
              value: 2000,
              title: '',
              radius: 45,
              color: Colors.orange,
            ),
            PieChartSectionData(
              value: 1500,
              title: '',
              radius: 45,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
