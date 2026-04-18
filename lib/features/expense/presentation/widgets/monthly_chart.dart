import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
class MonthlyChart extends StatelessWidget{
  final Map<String,double> data;
  const MonthlyChart({super.key,required this.data});
  @override
  Widget build(BuildContext context)
  {
    final entries=data.entries.toList();
    final total=entries.fold<double>(0,(sum,item)=>sum+item.value,);
    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 60,
          sections: List.generate(entries.length, (index) {
            final e = entries[index];
            final percentage = total == 0
                ? 0
                : (e.value / total) * 100;
            return PieChartSectionData(
              value: e.value,
              title: "${percentage.toStringAsFixed(1)}%",
              radius: 60,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }),

          ),
      ),
    );
  }

}