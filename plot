import socket
import matplotlib.pyplot as plt
import time
from collections import deque

# Setup
UDP_IP = "0.0.0.0"       # Listen on all interfaces
UDP_PORT = 5005          # Must match ESP32 udpPort

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))
print(f"🔍 Listening for UDP data on {UDP_IP}:{UDP_PORT}...")

# Graph data storage
temps = deque(maxlen=100)
timestamps = deque(maxlen=100)

plt.ion()
fig, ax = plt.subplots()
line, = ax.plot([], [], label="DS18B20 Temp (°C)")
ax.set_xlabel("Time (s)")
ax.set_ylabel("Temperature")
ax.legend()
start_time = time.time()

while True:
    try:
        data, _ = sock.recvfrom(1024)
        temp_str = data.decode().strip()
        temp = float(temp_str)
        print(f"📥 Received: {temp} °C")

        # Append data
        now = time.time() - start_time
        temps.append(temp)
        timestamps.append(now)

        # Update graph
        line.set_xdata(timestamps)
        line.set_ydata(temps)
        ax.relim()
        ax.autoscale_view()
        fig.canvas.draw()
        fig.canvas.flush_events()
        time.sleep(0.01)

    except Exception as e:
        print("❌ Error:", e)
   plot code
