import numpy as np
import simpleaudio as sa
import math

SAMPLE_RATE = 44100  # samples per second
AMPLITUDE = 28000    # wave height
PI = math.pi

def sound(freq, duration_tenths, volume):
    """
    Play a sine wave of given frequency, duration (in tenths of a second), and volume.
    
    Args:
        freq (float): Frequency in Hz.
        duration_tenths (float): Duration in tenths of a second (e.g., 2.5 = 250 ms).
        volume (float): Volume from 0.0 to 1.0.
    """
    duration_s = duration_tenths / 10.0
    t = np.linspace(0, duration_s, int(SAMPLE_RATE * duration_s), False)
    wave = np.sin(2 * PI * freq * t) * AMPLITUDE * volume
    wave = wave.astype(np.int16)
    
    play_obj = sa.play_buffer(wave, 1, 2, SAMPLE_RATE)
    play_obj.wait_done()

def click():
    sound(freq=1000, duration_tenths=0.5, volume=0.5)

def beep():
    sound(freq=2000, duration_tenths=2, volume=0.7)

# ?? Demo melody
if __name__ == "__main__":
    print("Playing tones with simpleaudio...")
    sound(440, 2.5, 0.8)  # A4
    sound(494, 2.5, 0.8)  # B4
    sound(523, 5, 0.8)    # C5
    sound(659, 10, 0.8)   # E5
    sound(587, 2.5, 0.8)  # D5
    sound(523, 7.5, 0.8)  # C5
    print("Done!")
