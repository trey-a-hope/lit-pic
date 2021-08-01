import 'package:flutter/material.dart';

class PayFlowDiagramView extends StatefulWidget {
  const PayFlowDiagramView({
    required this.currentStep,
  }) : super();

  final int currentStep;

  @override
  _PayFlowDiagramViewState createState() => _PayFlowDiagramViewState();
}

class _PayFlowDiagramViewState extends State<PayFlowDiagramView> {
  @override
  Widget build(BuildContext context) {
    int _currentStep = widget.currentStep;

    return Container(
      height: 75,
      width: double.infinity,
      color: Colors.transparent,
      child: Stepper(
        type: StepperType.horizontal,
        physics: ScrollPhysics(),
        currentStep: _currentStep > 2 ? 2 : _currentStep,
        onStepTapped: (step) => () {
          _currentStep = step;
        },
        onStepContinue: () => {},
        onStepCancel: () => {},
        steps: <Step>[
          Step(
              title: const Text('Shipping'),
              content: SizedBox.shrink(),
              isActive: _currentStep == 0,
              state:
                  _currentStep == 0 ? StepState.editing : StepState.complete),
          Step(
            title: const Text('Payment'),
            content: SizedBox.shrink(),
            isActive: _currentStep == 1,
            state: _currentStep == 1
                ? StepState.editing
                : _currentStep > 1
                    ? StepState.complete
                    : StepState.indexed,
          ),
          Step(
            title: const Text('Submit'),
            content: SizedBox.shrink(),
            isActive: _currentStep == 2,
            state: _currentStep == 2
                ? StepState.editing
                : _currentStep > 2
                    ? StepState.complete
                    : StepState.indexed,
          ),
        ],
      ),
    );
  }
}
