#!/usr/bin/env python3
import RPi.GPIO as GPIO # Import Raspberry Pi GPIO library
from functools import partial
from os import path
from os import system
from time import sleep
import signal
import sys

# Constants
pin_vol_down = 7
pin_vol_up = 11
vol_min = 10
vol_max = 90
vol_default = 50
vol_increment = 10
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
    return vol_default

  f = open(volume_file_path, 'r')
  try:
    vol = int(f.read())
    vol = max(vol_min, min(vol_max, vol))
    return vol
  except ValueError:
    return vol_default
  finally:
    f.close()

def apply_volume (vol):
  print('Applying volume {vol}'.format(vol=vol))

  exit_code = system('amixer sset PCM "{vol}%" >/dev/null && amixer sget PCM | grep "{vol}%" >/dev/null'.format(vol=vol))
  if exit_code != 0:
    raise ValueError('Setting volume failed with exit_code {exit_code}'.format(exit_code=exit_code))

vol = vol_default
def main ():
  global vol

  vol_disk = get_volume()
  vol = vol_disk
  apply_volume(vol)

  GPIO.setwarnings(False) # Ignore warning for now
  GPIO.setmode(GPIO.BOARD) # Use physical pin numbering
  GPIO.setup(pin_vol_down, GPIO.IN, pull_up_down=GPIO.PUD_DOWN) # Set pin 10 to be an input pin and set initial value to be pulled low (off)
  GPIO.setup(pin_vol_up, GPIO.IN, pull_up_down=GPIO.PUD_DOWN) # Set pin 12 to be an input pin and set initial value to be pulled low (off)

  def button_callback(pin, channel):
    global vol

    new_vol = vol
    if pin == pin_vol_down:
      new_vol = max(vol_min, vol - vol_increment)
    elif pin == pin_vol_up:
      new_vol = min(vol_max, vol + vol_increment)

    if new_vol != vol:
      vol = new_vol
      apply_volume(vol)

  GPIO.add_event_detect(pin_vol_down, GPIO.RISING, callback=partial(button_callback, pin_vol_down), bouncetime=300)
  GPIO.add_event_detect(pin_vol_up, GPIO.RISING, callback=partial(button_callback, pin_vol_up), bouncetime=300)

  while True:
    sleep(10)
    if vol_disk != vol:
      vol_disk = vol
      persist_volume(vol_disk)

def on_exit ():
  GPIO.cleanup()

def sigterm_handler(_signo, _stack_frame):
  on_exit()
  sys.exit(0)

# Handle sigterm
signal.signal(signal.SIGTERM, sigterm_handler)
# Loop
try:
  while True:
    try:
      main()
    except BaseException as err:
      # Break out of the loop
      break
    except:
      print(sys.exc_info()[0])
finally:
  on_exit()
