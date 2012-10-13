
import 'dart:html';
import 'package:affinity/affinity.dart';
import 'package:honey/graphics2d.dart';
import 'package:honey/graphics2d_html.dart';
import 'package:honey/quadspace.dart';

part 'quadtree_drawable.dart';

main() {
  
  var canvas = document.query("#content") as CanvasElement;
  var context2d = canvas.getContext("2d");
  var graphics2d = new CanvasGraphics2d(context2d);
  
  var tree = new QuadTree(new Rectangle(0, 0, 480, 480), 40, 40);
  tree.add(new ExampleQuad(new Rectangle(40, 40, 40, 40)));  
  tree.add(new ExampleQuad(new Rectangle(20, 15, 30, 50)));
  tree.add(new ExampleQuad(new Rectangle(201, 199, 39, 41)));
  tree.add(new ExampleQuad(new Rectangle(130, 0, 100, 1)));
  tree.add(new ExampleQuad(new Rectangle(100, 1, 50, 77)));
  
  var treeDrawable = new QuadTreeDrawable(tree);
  treeDrawable.draw(graphics2d);
}

class ExampleQuad implements HasRectangle {
  Rectangle rectangle;
  ExampleQuad(this.rectangle);
}
