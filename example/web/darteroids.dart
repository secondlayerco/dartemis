library darteroids;

import 'dart:html' hide Entity;
import 'dart:math';
import 'package:dartemis/dartemis.dart';

part 'darteroids/components.dart';
part 'darteroids/gamelogic_systems.dart';
part 'darteroids/input_systems.dart';
part 'darteroids/render_systems.dart';

const String tagPlayer = "player";
const String groupAsteroids = "ASTEROIDS";
const String playerColor = "#ff0000";
const String asteroidColor = "#BBB";
const int maxWidth = 600;
const int maxHeight = 600;
const int hudHeight = 100;

final Random random = new Random();

void main() {
  CanvasElement canvas = querySelector('#gamecontainer');
  canvas.width = maxWidth;
  canvas.height = maxHeight + hudHeight;

  Darteroids darteroids = new Darteroids(canvas);
  darteroids.start();
}

class Darteroids {
  CanvasElement canvas;
  CanvasRenderingContext2D context2d;
  num lastTime = 0;
  World world;

  Darteroids(this.canvas) {
    context2d = canvas.context2D;
  }

  void start() {
    world = new World();

    Entity player = world.createEntity();
    player.addComponent(new Position(maxWidth~/2, maxHeight~/2));
    player.addComponent(new Velocity());
    player.addComponent(new CircularBody.down(20, playerColor));
    player.addComponent(new Cannon());
    player.addComponent(new Status(lifes : 3, invisiblityTimer : 5000));
    player.addToWorld();

    TagManager tagManager = new TagManager();
    tagManager.register(player, tagPlayer);
    world.addManager(tagManager);
    GroupManager groupManager = new GroupManager();
    world.addManager(groupManager);

    addAsteroids(groupManager);

    world.addSystem(new PlayerControlSystem(canvas));
    world.addSystem(new BulletSpawningSystem());
    world.addSystem(new DecaySystem());
    world.addSystem(new MovementSystem());
    world.addSystem(new AsteroidDestructionSystem());
    world.addSystem(new PlayerCollisionDetectionSystem());
    world.addSystem(new BackgroundRenderSystem(context2d));
    world.addSystem(new CircleRenderingSystem(context2d));
    world.addSystem(new HudRenderSystem(context2d));

    world.initialize();

    gameLoop(0);
  }

  void addAsteroids(GroupManager groupManager) {

    for (int i = 0; i < 10; i++) {
      Entity asteroid = world.createEntity();
      asteroid.addComponent(new Position(maxWidth * random.nextDouble(), maxHeight * random.nextDouble()));
      num vx = generateRandomVelocity();
      num vy = generateRandomVelocity();
      asteroid.addComponent(new Velocity(vx, vy));
      asteroid.addComponent(new CircularBody.down(10 + 20 * random.nextDouble(), asteroidColor));
      asteroid.addComponent(new PlayerDestroyer());
      asteroid.addToWorld();
      groupManager.add(asteroid, groupAsteroids);
    }
  }

  void gameLoop(num time) {
    world.delta = time - lastTime;
    lastTime = time;
    world.process();

    requestRedraw();
  }

  void requestRedraw() {
    window.requestAnimationFrame(gameLoop);
  }
}

num generateRandomVelocity() {
  num velocity = 0.5 + 1.5 * random.nextDouble();
  velocity = velocity * (random.nextBool() ? 1 : -1);
  return velocity;
}