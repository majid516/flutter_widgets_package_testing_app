import 'package:flutter/material.dart';
import 'dart:math' as math;


class CreativeStepperApp extends StatelessWidget {
  const CreativeStepperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFE0E7FF),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      home: const StepperScreen(),
    );
  }
}

class StepperScreen extends StatefulWidget {
  const StepperScreen({super.key});

  @override
  State<StepperScreen> createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> with TickerProviderStateMixin {
  int _currentStep = 0;
  late AnimationController _bgController;
  late Animation<double> _bgAnimation;
  DateTime? _selectedDate;
  final List<String> _selectedActivities = [];
  late AnimationController _confettiController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();
    _bgAnimation = Tween<double>(begin: 0, end: 1).animate(_bgController);
    _confettiController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _bgController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _showCompletionDialog() {
    _confettiController.forward(from: 0);
    showDialog(
      context: context,
      builder: (context) => Stack(
        children: [
          AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white.withOpacity(0.95),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Adventure Ready!',
                  style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                AnimatedBuilder(
                  animation: _confettiController,
                  builder: (context, child) => Transform.rotate(
                    angle: _confettiController.value * 2 * math.pi,
                    child: const Icon(Icons.celebration, color: Color(0xFF3B82F6)),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Date: ${_selectedDate?.toString().split(' ')[0] ?? 'Time Traveler!'}',
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Activities: ${_selectedActivities.isEmpty ? 'Chillin\' like a villain' : _selectedActivities.join(', ')}',
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => _currentStep = 0);
                },
                child: const Text(
                  'New Quest',
                  style: TextStyle(color: Color(0xFF1E3A8A)),
                ),
              ),
            ],
          ),
        
        ],
      ),
    ).then((_) => _confettiController.reset());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background with Waves
          AnimatedBuilder(
            animation: _bgAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(_bgAnimation.value),
                child: Container(),
              );
            },
          ),
          // Floating Bubbles
          Positioned(
            top: 50,
            left: 20,
            child: AnimatedBubble(
              color: const Color(0xFF93C5FD).withOpacity(0.3),
              size: 80,
            ),
          ),
          Positioned(
            bottom: 100,
            right: 30,
            child: AnimatedBubble(
              color: const Color(0xFF60A5FA).withOpacity(0.3),
              size: 60,
            ),
          ),
          
          // Main Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Epic Journey',
                      style: TextStyle(
                        fontSize: 28, // Reduced from 32
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(width: 6), // Reduced spacing
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      transform: Matrix4.rotationZ(_currentStep * 0.2),
                      child: const Icon(Icons.explore, color: Color(0xFF3B82F6), size: 28), // Reduced from 32
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Unleash your wanderlust!',
                  style: TextStyle(
                    fontSize: 14, // Reduced from 16
                    color: Color(0xFF64748B),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Expanded(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF1E3A8A),
                        secondary: Color(0xFF3B82F6),
                      ),
                    ),
                    child: Stepper(
                      currentStep: _currentStep,
                      onStepTapped: (step) => setState(() => _currentStep = step),
                      onStepContinue: () {
                        if (_currentStep < 2) {
                          setState(() => _currentStep += 1);
                        } else {
                          _showCompletionDialog();
                        }
                      },
                      onStepCancel: () {
                        if (_currentStep > 0) {
                          setState(() => _currentStep -= 1);
                        }
                      },
                      controlsBuilder: (context, details) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16), // Reduced from 20
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (_currentStep > 0)
                                GestureDetector(
                                  onTap: details.onStepCancel,
                                  child: Container(
                                    padding: const EdgeInsets.all(10), // Reduced from 12
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFF1F5F9),
                                    ),
                                    child: const Icon(Icons.arrow_back, color: Color(0xFF1E3A8A), size: 20), // Reduced size
                                  ),
                                ),
                              GestureDetector(
                                onTap: details.onStepContinue,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Reduced padding
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E3A8A),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF1E3A8A).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _currentStep < 2 ? 'Next' : 'Launch!',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), // Reduced font size
                                      ),
                                      const SizedBox(width: 6), // Reduced spacing
                                      const Icon(Icons.arrow_forward, color: Colors.white, size: 18), // Reduced from 20
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      steps: [
                        _buildStep(
                          0,
                          'Destination',
                          'When’s the big day?',
                         
                          _buildDatePicker(),
                        ),
                        _buildStep(
                          1,
                          'Activities',
                          'Pick your fun!',
                        
                          _buildActivitySelector(),
                        ),
                        _buildStep(
                          2,
                          'Review',
                          'Ready to roll?', 
                          _buildReviewContent(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Step _buildStep(int stepIndex, String title, String subtitle, Widget content) {
    return Step(
      title: Row(
        children: [
         
          Text(
            title,
            style: TextStyle(
              fontSize: 18, // Reduced from 22
              fontWeight: FontWeight.w700,
              color: _currentStep == stepIndex ? const Color(0xFF1E3A8A) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Color(0xFF64748B), fontStyle: FontStyle.italic, fontSize: 12), // Reduced font size
      ),
      content: Container(
        padding: const EdgeInsets.all(12), // Reduced from 16
        margin: const EdgeInsets.only(top: 8), // Reduced from 12
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16), // Reduced from 20
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 8, // Reduced from 10
            ),
          ],
        ),
        child: content,
      ),
      isActive: _currentStep >= stepIndex,
      state: _currentStep > stepIndex 
          ? StepState.complete 
          : _currentStep == stepIndex 
              ? StepState.editing 
              : StepState.indexed,
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2026),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF1E3A8A),
                  onPrimary: Colors.white,
                ),
                dialogBackgroundColor: Colors.white.withOpacity(0.95),
              ),
              child: child!,
            );
          },
        );
        if (date != null) setState(() => _selectedDate = date);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(10), // Reduced from 14
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12), // Reduced from 16
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4, // Reduced from 5
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate == null 
                  ? 'Tap to Pick a Date!' 
                  : _selectedDate!.toString().split(' ')[0],
              style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500, fontSize: 14), // Reduced font size
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _selectedDate == null ? Icons.calendar_today : Icons.check_circle,
                key: ValueKey(_selectedDate),
                color: const Color(0xFF1E3A8A),
                size: 18, // Reduced size
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySelector() {
    final activities = ['Hiking', 'Sightseeing', 'Food Tour', 'Shopping', 'Relaxation'];
    return Wrap(
      spacing: 8, // Reduced from 10
      runSpacing: 8, // Reduced from 10
      children: activities.map((activity) {
        final isSelected = _selectedActivities.contains(activity);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedActivities.remove(activity);
              } else {
                _selectedActivities.add(activity);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Reduced padding
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1E3A8A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20), // Reduced from 30
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(isSelected ? 0.3 : 0.1),
                  blurRadius: 4, // Reduced from 5
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: isSelected ? 1.2 : 1.0,
                  child: Icon(
                    Icons.star,
                    size: 14, // Reduced from 16
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(width: 4), // Reduced from 6
                Text(
                  activity,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                    fontSize: 12, // Reduced font size
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReviewContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedText(
          text: 'Date: ${_selectedDate?.toString().split(' ')[0] ?? 'Time to choose!'}',
        ),
        const SizedBox(height: 8), // Reduced from 12
        AnimatedText(
          text: 'Activities: ${_selectedActivities.isEmpty ? 'Add some spice!' : _selectedActivities.join(', ')}',
        ),
      ],
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFE0E7FF).withOpacity(0.7),
          const Color(0xFFF1F5F9).withOpacity(0.7),
          const Color(0xFFE5E7EB).withOpacity(0.7),
        ],
        transform: GradientRotation(animationValue * 2 * math.pi),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    for (double x = 0; x <= size.width; x++) {
      path.lineTo(
        x,
        size.height * 0.8 +
            math.sin((x / size.width * 2 * math.pi) + (animationValue * 2 * math.pi)) * 50,
      );
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AnimatedBubble extends StatefulWidget {
  final Color color;
  final double size;

  const AnimatedBubble({super.key, required this.color, required this.size});

  @override
  State<AnimatedBubble> createState() => _AnimatedBubbleState();
}

class _AnimatedBubbleState extends State<AnimatedBubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.2),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class AnimatedText extends StatefulWidget {
  final String text;

  const AnimatedText({super.key, required this.text});

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(AnimatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _animation.value)),
          child: Opacity(
            opacity: _animation.value,
            child: Text(
              widget.text,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 14), // Reduced from 16
            ),
          ),
        );
      },
    );
  }
}