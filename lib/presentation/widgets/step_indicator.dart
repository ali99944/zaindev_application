import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class StepIndicator extends StatelessWidget {
  final int numberOfSteps;
  final int currentStep; // 0-based index

  const StepIndicator({
    super.key,
    required this.numberOfSteps,
    required this.currentStep,
  }) : assert(currentStep >= 0 && currentStep < numberOfSteps);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(numberOfSteps * 2 - 1, (index) {
        // Even indices are steps, odd are connectors
        if (index.isEven) {
          int stepIndex = index ~/ 2;
          return _buildStepCircle(context, stepIndex);
        } else {
          // Connector logic (before the next step)
           int stepIndexBeforeConnector = index ~/ 2;
          return _buildConnector(stepIndexBeforeConnector < currentStep);
        }
      }),
    );
  }

  Widget _buildStepCircle(BuildContext context, int stepIndex) {
    final textTheme = Theme.of(context).textTheme;
    const double circleSize = 32.0;

    if (stepIndex < currentStep) {
      // Completed Step
      return Container(
        width: circleSize,
        height: circleSize,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: AppColors.white, size: 18),
      );
    } else if (stepIndex == currentStep) {
      // Current Step
      return Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          color: AppColors.white, // Background for outline effect
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Center(
          child: Text(
            '${stepIndex + 1}',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      // Future Step (Optional: Greyed out)
      return Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.lightGrey, width: 1.5),
        ),
         child: Center(
          child: Text(
            '${stepIndex + 1}',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.lightGrey, // Grey text for future step number
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildConnector(bool isActive) {
    return Expanded( // Use Expanded to fill space between circles
      child: Container(
        height: 2, // Thickness of the line
        color: isActive ? AppColors.primary : AppColors.lightGrey,
        margin: const EdgeInsets.symmetric(horizontal: 4.0), // Small gap before/after circles
      ),
    );
    // Note: For actual dashed lines, consider CustomPaint or the dotted_border package
  }
}