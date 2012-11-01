part of darteroids;

class RenderSystem extends EntityProcessingSystem {

  CanvasRenderingContext2D context2d;

  ComponentMapper<Position> positionMapper;
  ComponentMapper<PhysicalBody> bodyMapper;

  RenderSystem(this.context2d) : super(Aspect.getAspectForAllOf(new Position.hack().runtimeType, [new PhysicalBody.hack().runtimeType]));

  void initialize() {
    positionMapper = new ComponentMapper(new Position.hack().runtimeType, world);
    bodyMapper = new ComponentMapper(new PhysicalBody.hack().runtimeType, world);
  }

  void processEntity(Entity entity) {
    Position pos = positionMapper.get(entity);
    PhysicalBody body = bodyMapper.get(entity);

    context2d.save();

    try {
      context2d.lineWidth = 0.5;
      context2d.fillStyle = body.color;
      context2d.strokeStyle = body.color;

      drawCirle(pos, body);

      if (pos.x + body.radius > MAXWIDTH) {
        drawCirle(pos, body, offsetX : -MAXWIDTH);
      } else if (pos.x - body.radius < 0) {
        drawCirle(pos, body, offsetX : MAXWIDTH);
      }
      if (pos.y + body.radius > MAXHEIGHT) {
        drawCirle(pos, body, offsetY : -MAXHEIGHT);
      } else if (pos.y - body.radius < 0) {
        drawCirle(pos, body, offsetY : MAXHEIGHT);
      }


      context2d.stroke();
    } finally {
      context2d.restore();
    }
  }

  void drawCirle(Position pos, PhysicalBody body, {int offsetX : 0, int offsetY : 0}) {
    context2d.beginPath();

    context2d.arc(pos.x + offsetX, pos.y + offsetY, body.radius, 0, PI * 2, false);

    context2d.closePath();
    context2d.fill();
  }
}

class BackgroundRenderSystem extends VoidEntitySystem {
  CanvasRenderingContext2D context2d;

  BackgroundRenderSystem(this.context2d);

  void processSystem() {
    context2d.save();
    try {
      context2d.fillStyle = "black";

      context2d.beginPath();
      context2d.rect(0, 0, MAXWIDTH, MAXHEIGHT + HUDHEIGHT);
      context2d.closePath();

      context2d.fill();
    } finally {
      context2d.restore();
    }
  }
}

class HudRenderSystem extends VoidEntitySystem {
  CanvasRenderingContext2D context2d;

  HudRenderSystem(this.context2d);

  void processSystem() {
    context2d.save();
    try {
      context2d.fillStyle = "#555";

      context2d.beginPath();
      context2d.rect(0, MAXHEIGHT, MAXWIDTH, MAXHEIGHT + HUDHEIGHT);
      context2d.closePath();

      context2d.fill();
    } finally {
      context2d.restore();
    }
  }
}