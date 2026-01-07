import 'package:flutter/material.dart';

class LinkedDashboardScreen extends StatefulWidget {
  const LinkedDashboardScreen({super.key});

  @override
  State<LinkedDashboardScreen> createState() => _LinkedDashboardScreenState();
}

class _LinkedDashboardScreenState extends State<LinkedDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('Linked Dashboard Screen', style: TextStyle(color: Colors.black),),
      ),
    );
  }
}