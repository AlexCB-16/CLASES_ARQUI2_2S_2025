const int ledPin = 13;

//volatile para poder cambiar la variable en interupciones isr
volatile bool flagEncenderLed = false;
volatile bool flagApagarLed = false;

void setup() {
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);

  Serial.begin(9600);

  // Interrupción en pin 2 (INT0) para flanco de subida
  attachInterrupt(digitalPinToInterrupt(2), flancoSubida, RISING);

  // Interrupción en pin 3 (INT1) para flanco de bajada
  attachInterrupt(digitalPinToInterrupt(3), flancoBajada, FALLING);
}

void loop() {
  Serial.println("posicion a");
  if (flagEncenderLed) {
    digitalWrite(ledPin, HIGH);
    Serial.println("Interrupcion por flanco de subida: LED encendido");
    flagEncenderLed = false;
  }
   Serial.println("posicion b");
  if (flagApagarLed) {
    digitalWrite(ledPin, LOW);
    Serial.println("Interrupcion por flanco de bajada: LED apagado");
    flagApagarLed = false;
  }
  Serial.println("posicion c");
  delay(1500);
}

// ISR para flanco de subida (INT0)
void flancoSubida() {
  flagEncenderLed = true;
}

// ISR para flanco de bajada (INT1)
void flancoBajada() {
  flagApagarLed = true;
}
