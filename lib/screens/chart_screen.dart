import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RadarChartWidget extends StatefulWidget {
  final Map<String, double> personalityData;

  const RadarChartWidget({Key? key, required this.personalityData})
      : super(key: key);

  @override
  State<RadarChartWidget> createState() => _RadarChartWidgetState();
}

class _RadarChartWidgetState extends State<RadarChartWidget> {
  int selectedDataSetIndex = -1;

  // Define colors for customization
  final Color radarFillColor = Colors.greenAccent.withOpacity(0.3); // Pastel green
  final Color radarBorderColor = Colors.greenAccent; // Match pastel theme
  final Color selectedBorderColor = Colors.teal; // Slightly darker green

  @override
  Widget build(BuildContext context) {
    // Extract features (keys) and values from the personality data
    final List<String> features = widget.personalityData.keys.toList();
    final List<double> values = widget.personalityData.values.toList();

    return Scaffold(
      backgroundColor: Colors.green[50], // Pastel pink background
      body: Center(
        child: AspectRatio(
          aspectRatio: 1.2,
          child: RadarChart(
            RadarChartData(
              radarTouchData: RadarTouchData(
                touchCallback: (FlTouchEvent event, RadarTouchResponse? response) {
                  setState(() {
                    selectedDataSetIndex = response?.touchedSpot?.touchedDataSetIndex ?? -1;
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
                  dataEntries: values.map((value) => RadarEntry(value: value)).toList(),
                  borderWidth: 4, // Thicker lines
                ),
              ],
              radarBackgroundColor: Colors.transparent,
              radarBorderData: BorderSide.none,
              gridBorderData: BorderSide.none, // Remove grid
              titlePositionPercentageOffset: 0.2,
              getTitle: (index, angle) {
                return RadarChartTitle(
                  text: features[index],
                  angle: angle,
                );
              },
              tickCount: 1, // Minimum tick count
              ticksTextStyle: const TextStyle(
                fontSize: 0, // Make ticks invisible
                color: Colors.transparent,
              ),
              tickBorderData: BorderSide.none, // Remove tick borders
            ),
            duration: const Duration(milliseconds: 3000),
          ),
        ),
      ),
    );
  }
}