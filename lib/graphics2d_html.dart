
#library('honey:graphics2d:html');

#import('dart:html');
#import('package:honey/geometry.dart');
#import('package:honey/graphics2d.dart');

class CanvasGraphics2d implements Graphics2d {
  
  final CanvasRenderingContext2D _context2d;
  
  String get font => _context2d.font;
         set font(String value) { _context2d.font = value; }
  
  num get globalAlpha => _context2d.globalAlpha;
      set globalAlpha(num value) { _context2d.globalAlpha = value; }
  
  CanvasGraphics2d(this._context2d);
  
  void beginPath() => _context2d.beginPath();
  
  void clearRect(num x, num y, num width, num height) 
      => _context2d.clearRect(x, y, width, height);
  
  void closePath() => _context2d.closePath();
  
  void drawImage(Image image, num dx, num dy) {
    assert(image is HtmlImage);
    _context2d.drawImage(image.element, dx, dy);
  }
  
  void drawImageRegion(Image image, num sx, num sy, num sw, num sh, 
                       num dx, num dy, num dw, num dh) {    
    assert(image is HtmlImage);
    _context2d.drawImage(image.element, sx, sy, sw, sh, 
        dx, dy, dw, dh);
  }
  
  void fill() => _context2d.fill();
  
  void fillRect(num x, num y, num width, num height) 
      => _context2d.fillRect(x, y, width, height);
  
  void fillRectangle(Rectangle r) 
      => _context2d.fillRect(r.left, r.top, r.width, r.height);
  
  void fillTriangle(num x1, num y1, num x2, num y2, num x3, num y3) {    
    _context2d.beginPath();
    _context2d.moveTo(x1, y1);
    _context2d.lineTo(x2, y2);
    _context2d.lineTo(x3, y3);
    _context2d.fill();  
  }  
  
  void lineTo(num x, num y) => _context2d.lineTo(x, y);
  
  void moveTo(num x, num y) => _context2d.moveTo(x, y);
  
  void rect(num x, num y, num width, num height) 
      => _context2d.rect(x, y, width, height);
  
  void restore() => _context2d.restore();
  
  void rotate(num angle) => _context2d.rotate(angle);
  
  void save() => _context2d.save();
  
  void scale(num sx, num sy) => _context2d.scale(sx, sy);
  
  void setFillColor(Color color) 
      => _context2d.setFillColor(color.r, color.g, color.b, color.a);
  
  void setStrokeColor(Color color) 
      => _context2d.setStrokeColor(color.r, color.g, color.b, color.a);
  
  /**
   * Context2d specifies the transformation matrix as follows
   * (http://dev.w3.org/html5/2dcontext/#transformations):
   *  
   *  [ a c e
   *    b d f
   *    0 0 1 ]
   *
   *  setTransform(a, b, c, d, e, f)
   */
  void setTransform(AffineTransform t) 
      => _context2d.setTransform(t.m00, t.m10, t.m01, t.m11, t.m02, t.m12);
  
  void strokeRect(num x, num y, num width, num height, [num lineWidth]) 
      => _context2d.strokeRect(x, y, width, height, lineWidth);
  
  void strokeRectangle(Rectangle r, [num lineWidth]) { //=> _context2d.strokeRect(r.left, r.top, r.width, r.height, lineWidth);
    // TODO: this is a workaround for http://code.google.com/p/dart/issues/detail?id=2074
    if(lineWidth == null) {      
      _context2d.strokeRect(r.left, r.top, r.width, r.height);  
    } else {
      _context2d.strokeRect(r.left, r.top, r.width, r.height, lineWidth);  
    }    
  }
  
  void strokeText(String text, num x, num y, [num maxWidth]) { //=> _context2d.strokeText(text, x, y, maxWidth);
    // TODO: this is a workaround for http://code.google.com/p/dart/issues/detail?id=2074
    if(maxWidth == null) {
      _context2d.strokeText(text, x, y);      
    } else {      
      _context2d.strokeText(text, x, y, maxWidth);
    }
  }
  
  void translate(num tx, num ty) => _context2d.translate(tx, ty);  
  
  /**
   * Context2d specifies the transformation matrix as follows
   * (http://dev.w3.org/html5/2dcontext/#transformations):
   *  
   *  [ a c e
   *    b d f
   *    0 0 1 ]
   *
   *  transform(a, b, c, d, e, f)
   */
  void transform(AffineTransform t) 
      => _context2d.transform(t.m00, t.m10, t.m01, t.m11, t.m02, t.m12);
}

class HtmlImage implements Image/*, HasElement*/ {
  
  final ImageElement _imageElement;
  
  int get height => _imageElement.height;
  int get width => _imageElement.width;
  
  Element get element =>_imageElement;
  
  HtmlImage(String url)
  : _imageElement = new Element.tag('img') {
    _imageElement.src = url;
    // TODO: we might need to listen to the load event on the ImageElement and provide an API for that?
    // I don't think the element is guaranteed to be ready upon construction...
  }  
}

