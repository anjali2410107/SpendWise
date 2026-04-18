import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
class MonthlyChart extends StatelessWidget{
  final Map<String,double> data;
  const MonthlyChart({super.key,required this.data});
  @override
  Widget build(BuildContext context)
  {
    final entries=data.entries.toList();
    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
              bottomTitles:AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value,meta)
                      {
                        if(value.toInt() >=entries.length)
                          return const SizedBox();
                        return Text(entries[value.toInt()].key);
                      },
                  ),
                ),
              ),
              barGroups:List.generate(entries.length, (index)
                {
                  final amount=entries[index].value;
                  return BarChartGroupData(
                  x:index,
                  barRods:[
                    BarChartRodData(
                    toY:amount,
                    width:16,
                borderRadius:BorderRadius.circular(4),
                    ),
                ],
                  );
                }),
          ),
      ),
    );
  }

}