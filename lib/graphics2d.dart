
#library('honey:graphics2d');

#import('dart:math');
#import('package:affinity/affinity.dart');
#import('package:honey/happening.dart');

class Color {
  // TODO: getters and setters to wrap validation [0:1] ranges
  num r;
  num g;
  num b;
  num a;
  Color(this.r, num this.g, num this.b,[num this.a = 1.0]);
  Color.random()
  : this.a = 1.0 {
    var rand = new Random();
    r = rand.nextDouble();
    g = rand.nextDouble();
    b = rand.nextDouble();
  }
}

abstract class Drawable2d {
  void draw(Graphics2d graphics);
}

abstract class Draw2dObservable {
  Happening<Graphics2d> get drawing;
  Happening<Graphics2d> get drawn;
}

abstract class Graphics2d {
  String font;
  num globalAlpha;
  
  void beginPath();
  void clearRect(num x, num y, num width, num height);
  void closePath();
  void drawImage(Image image, num dx, num dy);
  void drawImageRegion(Image image, num sx, num sy, num sw, num sh,
                       num dx, num dy, num dw, num dh);
  void fill();
  void fillRect(num x, num y, num width, num height);
  void fillRectangle(Rectangle r);
  void fillTriangle(num x1, num y1, num x2, num y2, num x3, num y3);
  void lineTo(num x, num y);
  void moveTo(num x, num y);
  void rect(num x, num y, num width, num height);
  void restore();
  void rotate(num angle);
  void save();
  void scale(num sx, num sy);
  void setFillColor(Color color);
  void setStrokeColor(Color color);
  void setTransform(AffineTransform t);
  void strokeRect(num x, num y, num width, num height, [num lineWidth]);
  void strokeRectangle(Rectangle r, [num lineWidth]);
  void strokeText(String text, num x, num y, [num maxWidth]);
  void translate(num tx, num ty);
  void transform(AffineTransform t);
}

abstract class Image {
  int get height;
  int get width;
}
