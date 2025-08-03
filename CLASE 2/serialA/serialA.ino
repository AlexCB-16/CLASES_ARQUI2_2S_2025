int gasVal;
int velocidad = 100;
const int maxima = 5000;
const int minima = 100;
const int aumenta = 50;
int serial=0;

void setup() {
  Serial.begin(9600);//processing
}

void loop() {
  gasVal=analogRead(A0);
  Serial.print(gasVal);
  Serial.print(",");
  Serial.println(velocidad);
  
  delay(velocidad);
}