#!/usr/bin/env python3
import RPi.GPIO as GPIO # Import Raspberry Pi GPIO library
from functools import partial
from os import path
from os import system
from time import sleep

# Constants
pin_vol_down = 7
pin_vol_up = 11
default_vol = 70
dir_path = path.dirname(path.realpath(__file__))
volume_file_path = path.join(dir_path, 'volume.txt')

# Functions to read/write to fs
def persist_volume (vol):
  print('Persisting volume {vol}'.format(vol=vol))

  f = open(volume_file_path, 'w')
  try:
    f.write('{vol}'.format(vol=vol))
  finally:
    f.close()

def get_volume ():
  print('Getting volume')

  if not path.exists(volume_file_path):
    return default_vol

  f = open(volume_file_path, 'r')
  try:
    return int(f.read())
  except ValueError:
    return default_vol
  finally:
    f.close()

def apply_volume (vol):
  print('Applying volume {vol}'.format(vol=vol))

  exit_code = system('amixer sset PCM "{vol}%" >/dev/null && amixer sget PCM | grep "{vol}%" >/dev/null'.format(vol=vol))
  if exit_code != 0:
    raise ValueError('Setting volume failed with exit_code {exit_code}'.format(exit_code=exit_code))

vol = get_volume()
apply_volume(vol)

try:
  GPIO.setwarnings(False) # Ignore warning for now
  GPIO.setmode(GPIO.BOARD) # Use physical pin numbering
  GPIO.setup(pin_vol_down, GPIO.IN, pull_up_down=GPIO.PUD_DOWN) # Set pin 10 to be an input pin and set initial value to be pulled low (off)
  GPIO.setup(pin_vol_up, GPIO.IN, pull_up_down=GPIO.PUD_DOWN) # Set pin 12 to be an input pin and set initial value to be pulled low (off)

  def button_callback(pin, channel):
    global vol

    if pin == pin_vol_down:
      vol = max(0, vol - 10)
      apply_volume(vol)
    elif pin == pin_vol_up:
      vol = max(0, vol + 10)
      apply_volume(vol)

  GPIO.add_event_detect(pin_vol_down, GPIO.BOTH, callback=partial(button_callback, pin_vol_down), bouncetime=300)
  GPIO.add_event_detect(pin_vol_up, GPIO.BOTH, callback=partial(button_callback, pin_vol_up), bouncetime=300)

  while True:
    sleep(1)

finally:
  GPIO.cleanup()
  persist_volume(vol)
