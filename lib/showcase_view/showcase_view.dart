import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:animations/animations.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CosmoTasks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF0F4FF),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w900,
            color: Color(0xFF2A2D5F),
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Montserrat',
            color: Color(0xFF5A6090),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: ShowCaseWidget(
        builder: (context) => const CosmicTaskHome(),
      ),
    );
  }
}

class CosmicTaskHome extends StatefulWidget {
  const CosmicTaskHome({super.key});

  @override
  State<CosmicTaskHome> createState() => _CosmicTaskHomeState();
}

class _CosmicTaskHomeState extends State<CosmicTaskHome> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final GlobalKey _avatarKey = GlobalKey();
  final GlobalKey _taskKey = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([_avatarKey, _taskKey, _fabKey]);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0F4FF), Color(0xFFD9E4FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: CosmicBackgroundPainter(_controller.value),
                    size: Size.infinite,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CosmoTasks',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(fontSize: 28),
                        ),
                        Showcase(
                          key: _avatarKey,
                          description: 'Your cosmic profile',
                          child: OpenContainer(
                            transitionDuration: const Duration(milliseconds: 500),
                            closedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            closedColor: Colors.transparent,
                            closedBuilder: (_, open) => GestureDetector(
                              onTap: open,
                              child: AnimatedScale(
                                scale: 1.0 + (_controller.value * 0.1),
                                duration: const Duration(milliseconds: 300),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: const Color(0xFFE6EBFF),
                                  foregroundColor: const Color(0xFF6C63FF),
                                  child: const Icon(Icons.person),
                                ),
                              ),
                            ),
                            openBuilder: (_, __) => const SizedBox(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCosmicStat('Tasks', '5', const Color(0xFFB2A4FF)),
                        _buildCosmicStat('Streak', '7', const Color(0xFF87CEFA)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Galactic Tasks',
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return index == 0
                              ? Showcase(
                                  key: _taskKey,
                                  description: 'mark for complete your task',
                                  child: _buildCosmicTask(index),
                                )
                              : _buildCosmicTask(index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Showcase(
        key: _fabKey,
        description: 'Add a new cosmic task',
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFFB2A4FF),
          child: AnimatedRotation(
            turns: _controller.value,
            duration: const Duration(milliseconds: 300),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildCosmicStat(String title, String value, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 175,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2A2D5F),
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF5A6090)),
          ),
        ],
      ),
    );
  }

  Widget _buildCosmicTask(int index) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        closedColor: Colors.white.withOpacity(0.8),
        closedBuilder: (_, open) => GestureDetector(
          onTap: open,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_controller.value * 0.1),
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF87CEFA), width: 2),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Task ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF2A2D5F),
                        ),
                      ),
                      const Text(
                        'Due: Nebula Time',
                        style: TextStyle(color: Color(0xFF5A6090)),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.star, color: Color(0xFFFFD700), size: 20),
              ],
            ),
          ),
        ),
        openBuilder: (_, __) => const SizedBox(),
      ),
    );
  }
}

class CosmicBackgroundPainter extends CustomPainter {
  final double animationValue;

  CosmicBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB2A4FF).withOpacity(0.2 * animationValue)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      50 * animationValue,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.7),
      30 * animationValue,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}