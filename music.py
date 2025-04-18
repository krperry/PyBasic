import os
os.environ['PYGAME_HIDE_SUPPORT_PROMPT'] = "hide"
import pygame
import numpy as np
import math
import time

# ?? Initialize pygame mixer
pygame.mixer.pre_init(frequency=44100, size=-16, channels=1)
pygame.init()

# ?? Sample rate (samples per second)
SAMPLE_RATE = 44100
AMPLITUDE = 28000
PI = math.pi


# ?? Smooth the waveform using a moving average
def smooth_wave(samples, window_size=2):
    smoothed = np.copy(samples)
    for i in range(1, len(samples) - 1):
        start = max(0, i - window_size)
        end = min(len(samples), i + window_size + 1)
        smoothed[i] = np.mean(samples[start:end])
    return smoothed


# ??? Fade in and fade out (in-place)
def apply_envelope(samples, fade_ms):
    fade_samples = int(SAMPLE_RATE * fade_ms / 1000)
    for i in range(fade_samples):
        fade = i / fade_samples
        samples[i] *= fade  # fade-in
        samples[-i - 1] *= fade  # fade-out
    return samples


# ?? Main sound function
def sound(freq, duration_ms, volume):
    total_samples = int(SAMPLE_RATE * (duration_ms / 1000.0))

    # ?? Generate a sine wave
    t = np.linspace(0, duration_ms / 1000.0, total_samples, False)
    wave = np.sin(2 * PI * freq * t) * AMPLITUDE * volume
    wave = wave.astype(np.int16)

    # ?? Apply envelope and smooth
    wave = apply_envelope(wave, fade_ms=10)
    wave = smooth_wave(wave, window_size=2)

    # ?? Convert to byte string and play
    sound_obj = pygame.mixer.Sound(buffer=wave.tobytes())

    # ?? Play and wait for it to finish
    channel = sound_obj.play()
    while channel.get_busy():
        pygame.time.wait(1)  # Wait in small steps (1 ms)


def click():
    # Short, low-frequency sound for a click
    sound(freq=1000, duration_ms=50, volume=0.5)


# Function to generate a system-like beep sound
def beep():
    # Medium-duration, higher-frequency sound for a beep
    sound(freq=2000, duration_ms=200, volume=0.7)


# ?? Demo melody using our function
if __name__ == "__main__":
    print("Playing smooth tones with pygame...")
    sound(440, 250, 0.8)  # A4
    sound(494, 250, 0.8)  # B4
    sound(523, 500, 0.8)  # C5
    sound(659, 1000, 0.8)  # E5
    sound(587, 250, 0.8)  # D5
    sound(523, 750, 0.8)  # C5
    print("Done!")
