#!/usr/bin/env python
from gpiozero import Button
from functools import partial
from os import path
from os import system
from time import sleep
import signal
import sys

class AmixerError(ValueError):
  pass

# Constants
pin_vol_down = 17
pin_vol_up = 27
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
    raise AmixerError('Setting volume failed with exit_code {exit_code}'.format(exit_code=exit_code))

def init ():
  global vol

  vol_disk = get_volume()
  vol = vol_disk
  apply_volume(vol)

  return vol

vol = vol_default
def main ():
  global vol

  vol = init()

  volup_button = Button(pin_vol_up)
  voldown_button = Button(pin_vol_down)

  while True:
    new_vol = vol
    if volup_button.is_pressed:
      new_vol = min(vol_max, vol + vol_increment)
    if voldown_button.is_pressed:
      new_vol = max(vol_min, vol - vol_increment)

    if new_vol != vol:
      vol = new_vol
      apply_volume(vol)
      persist_volume(vol)

      time.sleep(0.3)

def on_exit ():
  pass

def sigterm_handler(_signo, _stack_frame):
  on_exit()
  sys.exit(0)

# Handle sigterm
signal.signal(signal.SIGTERM, sigterm_handler)
# Loop
try:
  if 'init' in sys.argv:
    init()
  else:
    while True:
      try:
        main()
      except (SystemExit, KeyboardInterrupt) as err:
        print(err)
        # Break out of the loop
        break
      except:
        print(sys.exc_info()[0])
except AmixerError:
  print("amixer was not ready yet")
  on_exit()
  exit(1)
finally:
  on_exit()
