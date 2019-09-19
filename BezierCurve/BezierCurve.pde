ArrayList<Point> points = new ArrayList();
float radius = 5.0;

//tamanho dos pontos de controle
float bezierRadius = 2.0;

//tamanho dos pontos da curva bezier
float step = 0.001;

int selection = -1;

boolean controlLine = true;

void setup() {
  
  size(500, 500);
  
}

void keyPressed(){
  
  if( key == 'c'){
    
    points.clear();
    selection = -1;
  }
  
  if( key == 'h'){
    
    controlLine = !controlLine;
  }
}


void mousePressed(){
  
  for(int i = 0; i < points.size(); i++){
    
    Point point = points.get(i);
    
    if(point.overlaps(mouseX, mouseY)){
      
      selection = i;
      break;
    }
  }
  
  if(mouseButton == LEFT && selection == -1){
    
    points.add(new Point(mouseX, mouseY, radius));
    selection = points.size() - 1;
  }
  
  if(mouseButton == RIGHT && selection != -1){
    points.remove(selection);
    selection = -1;
  }
  
}


void mouseReleased(){
  selection = -1;
}

void mouseDragged(){
  
  if(selection != -1){
    
    Point point = points.get(selection);
    point.x = clamp(mouseX, 0, width);
    point.y = clamp(mouseY, 0, height);
  }
}


void draw() {
  
  background(255, 255, 255); // cor resetada pra branco
  
  drawControlPoits();
  
  if(controlLine){
    drawControlLine();
  }
  
  drawBezierCurve();
}

float clamp(float x, float a, float b){
  
  return Math.min(Math.max(x, a), b);
}

PVector lerp(PVector a, PVector b, float t){
  
  return PVector.mult(a, 1.0 - t).add(PVector.mult(b, t));
}

PVector casteljau(int degree, float t, int index){
  
  if(degree == 0){
    Point point = points.get(index);
    return new PVector(point.x, point.y);
  }
  
  PVector p0 = casteljau(degree - 1, t, index);
  PVector p1 = casteljau(degree - 1, t, index + 1);
  
  return lerp(p0, p1, t);
}


void drawControlPoits(){
  
  for(Point point : points){
    point.draw();
  }  
}

void drawControlLine(){
  for(int i = 0; i < points.size() - 1; i++){
    Point p0 = points.get(i);
    Point p1 = points.get(i + 1);
    
    pushStyle();
    strokeWeight(2.0);
    line(p0.x, p0.y, p1.x, p1.y);
    popStyle();
  }
}

void drawBezierCurve(){
  
  if(points.size() > 0){
    for(float t = 0; t <= 1.0; t += step){
      
       PVector point = casteljau(points.size() - 1, t, 0);
       
       Point p = new Point(point.x, point.y, bezierRadius);
       p.draw();
    }
  
  }
}
