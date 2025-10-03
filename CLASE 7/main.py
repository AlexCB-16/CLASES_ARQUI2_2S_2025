# python -m venv env_bi || python3 -m venv env_bi
# env_bi\Scripts\activate || source env_bi/bin/activate
# Basado en: https://github.com/JoaoAssalim/Weapons-and-Knives-Detector-with-YOLOv8
# Créditos: Joao Assalim
# Modificado por: [Axel Calderon]
# Descripción: Detección de armas y cuchillos con YOLOv8 usando cámara web.

# pip install torch==2.5.0 --force-reinstall
# pip install torchvision==0.20.0 --force-reinstall

import cv2
from ultralytics import YOLO
import time

def ultra_fast_detection():
    # Cargar modelo
    yolo_model = YOLO('./modelo/best.pt')
    
    # Configurar cámara
    cap = cv2.VideoCapture(0)
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
    cap.set(cv2.CAP_PROP_FPS, 30)
    cap.set(cv2.CAP_PROP_FOURCC, cv2.VideoWriter_fourcc(*'MJPG'))
    
    # Warm-up del modelo
    print("Calentando modelo...")
    warmup_frame = cv2.resize(cap.read()[1], (320, 240))
    _ = yolo_model(warmup_frame, verbose=False)
    print("Modelo listo!")
    
    cv2.namedWindow("Detección Ultra Rápida", cv2.WINDOW_NORMAL)
    
    # Configuración de rendimiento
    process_every_n = 1  # Procesar cada frame
    frame_counter = 0
    fps_list = []
    
    try:
        while True:
            start_time = time.time()
            
            ret, frame = cap.read()
            if not ret:
                break
            
            # Procesar frame
            if frame_counter % process_every_n == 0:
                # Redimensionar para procesamiento más rápido
                small_frame = cv2.resize(frame, (320, 240))
                results = yolo_model(small_frame, verbose=False)
                annotated_frame = results[0].plot()
            else:
                annotated_frame = frame
            
            # Calcular FPS
            processing_time = time.time() - start_time
            current_fps = 1.0 / processing_time if processing_time > 0 else 0
            fps_list.append(current_fps)
            if len(fps_list) > 10:
                fps_list.pop(0)
            
            avg_fps = sum(fps_list) / len(fps_list)
            
            # Mostrar información de rendimiento
            cv2.putText(annotated_frame, f"FPS: {avg_fps:.1f}", (10, 30), 
                       cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 255, 0), 2)
            cv2.putText(annotated_frame, f"Res: 320x240", (10, 60), 
                       cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 0), 1)
            
            cv2.imshow("Detección Ultra Rápida", annotated_frame)
            frame_counter += 1
            
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break
                
    finally:
        cap.release()
        cv2.destroyAllWindows()
        print(f"FPS promedio: {sum(fps_list)/len(fps_list):.1f}")

# Ejecutar la versión más optimizada
ultra_fast_detection()