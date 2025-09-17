

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';


void main() {
  runApp(const FlappyBirdApp());
}


class FlappyBirdApp extends StatelessWidget {
  const FlappyBirdApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Bird',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FlappyBirdGame(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class FlappyBirdGame extends StatefulWidget {
  const FlappyBirdGame({Key? key}) : super(key: key);


  @override
  State<FlappyBirdGame> createState() => _FlappyBirdGameState();
}


class _FlappyBirdGameState extends State<FlappyBirdGame>
    with TickerProviderStateMixin {
  // Posición y física del pájaro
  double birdY = 0;
  double time = 0;
  double height = 0;
  double initialHeight = 0;


  // Estado del juego
  bool gameHasStarted = false;
  bool gameOver = false;
  int score = 0;
  int bestScore = 0;


  // Propiedades de las tuberías
  double barrierXone = 1.5;
  double barrierXtwo = 3.0;
  double barrierWidth = 0.5;
  List<double> barrierOneHeight = [0.6, 0.4];
  List<double> barrierTwoHeight = [0.5, 0.5];


  // Controlador del timer
  Timer? gameTimer;


  // Controladores de animación
  late AnimationController birdController;
  late Animation<double> birdAnimation;


  @override
  void initState() {
    super.initState();


    // Configurar animación del pájaro
    birdController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );


    birdAnimation = Tween<double>(begin: 0, end: 1).animate(birdController);


    // Inicializar posición del pájaro
    birdY = 0;
  }


  void jump() {
    if (!gameOver && gameHasStarted) {
      setState(() {
        time = 0;
        initialHeight = birdY;
      });


      // Animación de aleteo
      birdController.forward().then((_) => birdController.reverse());
    }
  }


  void startGame() {
    if (gameHasStarted) return;
    setState(() {
      gameHasStarted = true;
      gameOver = false;
      score = 0;
      birdY = 0;
      time = 0;
      initialHeight = 0;
      barrierXone = 1.5;
      barrierXtwo = 3.0;
      barrierOneHeight = [0.4, 0.5];
      barrierTwoHeight = [0.5, 0.4];
    });


    gameTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      time += 0.04;
      height = -4.9 * time * time + 2.8 * time;


      setState(() {
        birdY = initialHeight - height;


        barrierXone -= 0.04;
        barrierXtwo -= 0.04;


        // Reiniciar tuberías cuando salen de pantalla
        if (barrierXone < -1.5) {
          barrierXone = 3.0;
          barrierOneHeight = [
            0.3 + Random().nextDouble() * 0.6,
            0.3 + Random().nextDouble() * 0.6,
          ];
          score++;
        }


        if (barrierXtwo < -1.5) {
          barrierXtwo = 3.0;
          barrierTwoHeight = [
            0.3 + Random().nextDouble() * 0.6,
            0.3 + Random().nextDouble() * 0.6,
          ];
          score++;
        }


        if (birdDead()) {
          timer.cancel();
          gameOver = true;
          if (score > bestScore) bestScore = score;
          _showGameOverDialog();
        }
      });
    });
  }


  void resetGame() {
    if (gameTimer != null) {
      gameTimer!.cancel();
    }


    Navigator.of(context).pop();
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      gameOver = false;
      time = 0;
      score = 0;
      barrierXone = 1.5;
      barrierXtwo = 3.0;
      barrierOneHeight = [0.6, 0.4];
      barrierTwoHeight = [0.5, 0.5];
      initialHeight = 0;
    });
  }


  bool birdDead() {
    // Colisión con el suelo o techo
    if (birdY < -1 || birdY > 1) {
      return true;
    }


    // Colisión con primera tubería
    if (barrierXone <= 0.3 && barrierXone >= -0.3) {
      if (birdY <= -1.2 + barrierOneHeight[0] || birdY >= 1.2 - barrierOneHeight[1]) {
        return true;
      }
    }


    // Colisión con segunda tubería
    if (barrierXtwo <= 0.3 && barrierXtwo >= -0.3) {
      if (birdY <= -1.2 + barrierTwoHeight[0] || birdY >= 1.2 - barrierTwoHeight[1]) {
        return true;
      }
    }


    return false;
  }


  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          title: const Center(
            child: Text(
              "¡GAME OVER!",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Puntuación: $score",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                "Mejor puntuación: $bestScore",
                style: const TextStyle(color: Colors.yellow, fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: resetGame,
              child: const Text(
                "JUGAR OTRA VEZ",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  // Fondo del cielo
                  Container(
                    color:
                        gameOver ? const Color.fromARGB(255, 255, 0, 0) : Colors.blue.shade300,
                    width: double.infinity,
                    height: double.infinity,
                  ),


                  // Pájaro
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    alignment: Alignment(0, birdY),
                    child: AnimatedBuilder(
                      animation: birdAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: birdAnimation.value * 0.3,
                          child: const MyBird(),
                        );
                      },
                    ),
                  ),


                  // Tubería 1 - Inferior
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    alignment: Alignment(barrierXone, 1.1),
                    child: MyBarrier(
                      size: 200.0,
                      barrierHeight: barrierOneHeight[0],
                    ),
                  ),


                  // Tubería 1 - Superior
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    alignment: Alignment(barrierXone, -1.1),
                    child: MyBarrier(
                      size: 200.0,
                      barrierHeight: barrierOneHeight[1],
                    ),
                  ),


                  // Tubería 2 - Inferior
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    alignment: Alignment(barrierXtwo, 1.1),
                    child: MyBarrier(
                      size: 200.0,
                      barrierHeight: barrierTwoHeight[0],
                    ),
                  ),


                  // Tubería 2 - Superior
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    alignment: Alignment(barrierXtwo, -1.1),
                    child: MyBarrier(
                      size: 200.0,
                      barrierHeight: barrierTwoHeight[1],
                    ),
                  ),


                  // Instrucciones iniciales
                  if (!gameHasStarted)
                    Container(
                      alignment: const Alignment(0, -0.3),
                      child: const Text(
                        "TOCA PARA JUGAR",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),


                  // Puntuación durante el juego
                  if (gameHasStarted)
                    Container(
                      alignment: const Alignment(0, -0.8),
                      child: Text(
                        score.toString(),
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),


            // Suelo del juego
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.green,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "PUNTUACIÓN",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          score.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "MEJOR",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          bestScore.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    birdController.dispose();
    gameTimer?.cancel();
    super.dispose();
  }
}


class MyBird extends StatelessWidget {
  const MyBird({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.yellow,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.orange, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Icon(Icons.flutter_dash, color: Colors.orange, size: 30),
    );
  }
}


class MyBarrier extends StatelessWidget {
  final double size;
  final double barrierHeight;


  const MyBarrier({Key? key, required this.size, required this.barrierHeight})
    : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: size * barrierHeight,
      decoration: BoxDecoration(
        color: Colors.green.shade800,
        border: Border.all(width: 3, color: Colors.green.shade900),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(2, 2),
          ),
        ],
      ),
    );
  }
}





