import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F5),
      appBar: AppBar(
        title: const Text('Admin Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              // Manual refresh logic if needed, though StreamBuilder handles real-time
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Assuming you have a 'reports' collection in Firestore
        stream: FirebaseFirestore.instance.collection('reports').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF2962FF)));
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading analytics'));
          }

          final reports = snapshot.data?.docs ?? [];
          
          // Data Processing for Analytics
          int totalReports = reports.length;
          int resolvedReports = reports.where((doc) => doc['status'] == 'resolved').length;
          int pendingReports = totalReports - resolvedReports;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overview',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildMetricsGrid(totalReports, resolvedReports, pendingReports),
                const SizedBox(height: 32),
                const Text(
                  'Report Status Distribution',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildChartCard(resolvedReports, pendingReports),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricsGrid(int total, int resolved, int pending) {
    return Row(
      children: [
        Expanded(child: _buildMetricCard('Total\nReports', total.toString(), Colors.blueGrey)),
        const SizedBox(width: 12),
        Expanded(child: _buildMetricCard('Resolved', resolved.toString(), Colors.green)),
        const SizedBox(width: 12),
        Expanded(child: _buildMetricCard('Pending', pending.toString(), Colors.orange)),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.2),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(int resolved, int pending) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (resolved > pending ? resolved : pending).toDouble() + 5,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 14);
                  String text = value == 0 ? 'Resolved' : 'Pending';
                  return Padding(padding: const EdgeInsets.only(top: 10.0),
                  child: Text(text, style: style),);
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: resolved.toDouble(),
                  color: Colors.green,
                  width: 30,
                  borderRadius: BorderRadius.circular(4),
                )
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: pending.toDouble(),
                  color: Colors.orange,
                  width: 30,
                  borderRadius: BorderRadius.circular(4),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}