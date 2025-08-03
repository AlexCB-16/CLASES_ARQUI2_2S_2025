import processing.serial.*;
Serial myPort;
String data = "";
int val1=0;
int val2=0;
void setup() {
  size(800, 800);
  background(255); // Fondo blanco
  
  //info
  String portName = "/dev/ttyUSB0";
  //"/dev/ttyUSB0"; normal
  //"/dev/rfcomm0"; bluetooh
  myPort = new Serial(this, portName, 9600);
  myPort.clear();//limpiar buffer inicial
  myPort.bufferUntil('\n');//leer datos hasta el salto de linea
}

void draw() {
  drawRayo();
  drawCuadroTexto(425,210,250,150,"Velocidad",val2,retornarTresInts(5000-100,'b',val2));

  drawNube();
  drawCuadroTexto(425,500,250,150,"Gas",val1,retornarTresInts(1024,'b',val1));

  infoRecbida();
}

int[] retornarTresInts(int factor, char lugar, int noActual) {
  int[] valores = new int[3];//r,g,b
  double factoRS=(255.0*3.0)/factor;//cuanta veces puedo aumentar
  double res=-1;
  int factorAumento=int(factor/3);
  if(lugar=='b'){//disminuye rg(b) segunda primera etapa
    res=255;
    res=res-factoRS*noActual;
    
    if(res<0){//quiere decir que me pase factor
      return retornarTresInts(factor,'r',noActual-factorAumento);
    }
    valores[0]=0;//r
    valores[1]=255;//g
    valores[2]=(int) res;//b
    return valores;
  }else if(lugar=='r'){//aumenta (r)gb segunda etapa
    res=0;
    res=res+factoRS*noActual;
    if(res>255){
      return retornarTresInts(factor,'g',noActual-factorAumento);
    }
    valores[0]=(int) res;//r
    valores[1]=255;//g
    valores[2]=0;//b
    return valores;
  }else if(lugar=='g'){//disminuye r(g)b tercera etapa
    res=255;
    res=res-factoRS*noActual;
    valores[0]=255;//r
    valores[1]=(int) res;//g
    valores[2]=0;//b
    return valores;
    
  }
  return valores;
}

void infoRecbida(){
  if (myPort.available() > 0) { //<>//
    data = myPort.readStringUntil('\n'); // Leer hasta el salto de línea
    if (data != null) {
      data = data.trim(); // Eliminar espacios en blanco o caracteres extra
      println("Datos recibidos: " + data); // Mostrar los datos en la consola
      String[] valores=split(data,",");
      if(valores.length==2)
      {
        val1=int(valores[0]);
        val2=int(valores[1]);
      }
    }
  }
}

void drawRayo(){
  // Color del rayo (amarillo)
  stroke(255, 255, 0); // Amarillo
  strokeWeight(10); // Grosor de la línea
  
  // Coordenadas para el rayo
  float x1 = 181; // Punto inicial en x
  float y1 = 126;  // Punto inicial en y
  
  float x2 = 124; // Primer punto intermedio en x
  float y2 = 261; // Primer punto intermedio en y
  
  float x3 = 216; // Segundo punto intermedio en x
  float y3 = 229; // Segundo punto intermedio en y
  
  float x4 = 155; // Punto final en x
  float y4 = 370; // Punto final en y
  
  // Dibujar las tres líneas del rayo
  line(x1, y1, x2, y2); // Primera línea
  line(x2, y2, x3, y3); // Segunda línea
  line(x3, y3, x4, y4); // Tercera línea
}

void drawNube(){
  //cruz
  drawCicle(205,530,80);//arr
  drawCicle(205,600,80);//abj
  
  drawCicle(160,565,80);//iz
  drawCicle(250,565,80);//der
  
 //abajo
 drawCicle(250, 600, 50);//izMini
 drawCicle(160, 600, 50);//derMini
 
 //arriba
 drawCicle(250, 530, 50);//izMini
 drawCicle(160, 530, 50);//derMini
}

void drawCicle(int x,int y,int tam){//pos(x,y) tam(x,y)
 noStroke();//sin borde
 fill(0, 150, 255);//celeste
 ellipse(x, y, tam, tam);
}

void drawCuadroTexto(float rectX,float rectY,float rectWidth,float rectHeight,String opcion,int numero,int[] rgb){//pos(x,y) ancho(x,y)
  fill(rgb[0], rgb[1], rgb[2]); // Color azul
  noStroke(); // Sin borde
  rect(rectX, rectY, rectWidth, rectHeight);
  
  // Propiedades del texto
  textSize(32); // Tamaño del texto
  fill(0); // Color del texto (negro)
  
  // Calcular la posición del texto para centrarlo en el rectángulo
  float textX = rectX + rectWidth / 2; // Centro horizontal del rectángulo
  float textY = rectY + rectHeight / 2; // Centro vertical del rectángulo
  
  // Alinear el texto al centro
  textAlign(CENTER, CENTER);
  
  // Dibujar el texto
  text(opcion+": "+numero, textX, textY);
}
