import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RadarChartWidget extends StatefulWidget {
  final Map<String, int> personalityData;

  const RadarChartWidget({Key? key, required this.personalityData})
      : super(key: key);

  @override
  State<RadarChartWidget> createState() => _RadarChartWidgetState();
}

class _RadarChartWidgetState extends State<RadarChartWidget> {
  int selectedDataSetIndex = -1;

  final Color radarFillColor = Colors.greenAccent.withOpacity(0.3);
  final Color radarBorderColor = Colors.greenAccent;
  final Color selectedBorderColor = Colors.teal;

  @override
  Widget build(BuildContext context) {
    List<String> features = widget.personalityData.keys.toList();
    List<double> values = widget.personalityData.values
        .map((e) => (e as num).toDouble())
        .toList();
    features = features.take(6).toList();
    values = values.take(6).toList();
    return Scaffold(
      appBar:  AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.psychology,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Personality Radar Chart',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 4,
        toolbarHeight: 70,
      ),
      backgroundColor: Colors.green[50],
      body: Center(
        child: AspectRatio(
          aspectRatio: 1.2,
          child: RadarChart(
            RadarChartData(
              radarTouchData: RadarTouchData(
                touchCallback: (FlTouchEvent event, RadarTouchResponse? response) {
                  setState(() {
                    selectedDataSetIndex =
                        response?.touchedSpot?.touchedDataSetIndex ?? -1;
                  });
                },
              ),
              dataSets: [
                RadarDataSet(
                  fillColor: radarFillColor,
                  borderColor: selectedDataSetIndex == 0
                      ? selectedBorderColor
                      : radarBorderColor,
                  entryRadius: 4,
                  dataEntries: values
                      .map((value) => RadarEntry(value: value))
                      .toList(),
                  borderWidth: 4,
                ),
              ],
              radarBackgroundColor: Colors.transparent,
              radarBorderData: BorderSide.none,
              gridBorderData: BorderSide.none,
              titlePositionPercentageOffset: 0.2,
              getTitle: (index, angle) {
                return RadarChartTitle(
                  text: features[index],
                  angle: angle,
                );
              },
              tickCount: 1,
              ticksTextStyle: const TextStyle(
                fontSize: 0,
                color: Colors.transparent,
              ),
              tickBorderData: BorderSide.none,
            ),
            duration: const Duration(milliseconds: 3000),
          ),
        ),
      ),
    );
  }
}
