import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SubscriptionPlanSection extends StatelessWidget {
  final String currentPlan;
  final int planLevel;
  final DateTime endDateTime;
  final VoidCallback onUpgrade;

  const SubscriptionPlanSection({
    super.key,
    required this.currentPlan,
    required this.planLevel,
    required this.onUpgrade,
    required this.endDateTime,
  });

  @override
  Widget build(BuildContext context) {

    String formatDate(DateTime date) {
      final adjusted = date.add(const Duration(hours: 7));
      return "${adjusted.year}-${adjusted.month.toString().padLeft(2, '0')}-${adjusted.day.toString().padLeft(2, '0')}, "
          "${adjusted.hour.toString().padLeft(2, '0')}:${adjusted.minute.toString().padLeft(2, '0')}";
    }


    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    currentPlan,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A2540),
                    ),
                  ),
                  if (planLevel == 2) ...[
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        children: [
                          const TextSpan(
                            text: 'End at ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: formatDate(endDateTime),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              GestureDetector(
                onTap: onUpgrade,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(220, 94, 133, 1.0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.diamond_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Jarvis Pro',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              FaIcon(FontAwesomeIcons.planeUp, color: Colors.pink[600], size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    children:
                        planLevel == 1
                            ? [
                              const TextSpan(
                                text:
                                    'Your current plan has 0 daily usage, upgrade your plan to increase the limit.',
                              ),
                            ]
                            : [
                              const TextSpan(text: 'Your current plan has '),
                              const TextSpan(
                                text: 'unlimited',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(text: ' token usage.'),
                            ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
