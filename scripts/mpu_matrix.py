
import time
import struct
import numpy as np
import pandas as pd
import array

from mpu_macros import *
from socket import socket, AF_PACKET, SOCK_RAW, htons


def send_eth(src, dst, eth_type, payload, interface = "eth0"):
  """Send raw Ethernet packet on interface."""

  assert(len(src) == len(dst) == 6) # 48-bit ethernet addresses
  assert(len(eth_type) == 2) # 16-bit ethernet type
  assert(len(payload) <= MTU)

  return s.send(dst + src + eth_type + payload)


def receive_eth():
  """Receive raw Ethernet packet on interface."""

  frame = s.recv(2048)

  dst = frame[0:6]
  src = frame[6:12]
  eth_type = frame[12:14]
  payload = frame[14::]

  return (dst, src, eth_type, payload)


def receive_frame():
  """Receive frame from MPU"""

  (mac_dst, mac_src, ether_type, payload) = receive_eth()
  while (mac_dst != MAC_HOST and mac_src != MAC_MPU):
    (mac_dst, mac_src, ether_type, payload) = receive_eth()

  return (ether_type, payload)


def receive_data():
  """Receive data from MPU"""

  (length, payload) = receive_frame()
  recv_time = time.perf_counter()

  frame_type = payload[1]
  if (frame_type != Frame.DATA):
      return (frame_type, 0, 0, 0)

  raw_x = payload[2:4]
  raw_y = payload[4:6]

  temp_x = struct.unpack('2B', raw_x)
  temp_y = struct.unpack('2B', raw_y)
  dim_x = 8 * temp_x[0] + temp_x[1]
  dim_y = 8 * temp_y[0] + temp_y[1]

  data_len = 4 * dim_x * dim_y
  data = payload[6:(6+data_len)]

  return (frame_type, dim_x, dim_y, data, recv_time)


def send_matrix(matrix, buffer, buffer_idx = 0):
  """Send matrix to MPU buffer"""

  if (buffer_idx >= BUFFER_CNT):
    print("Wrong buffer index - matrix has not been sent")
    quit()

  cmd_str = struct.pack('!b', Command.LOAD)
  if (buffer == Buffer.A):
    buffer_str = struct.pack('!b', buffer) + struct.pack('!b', buffer_idx) + b'\x00'
  elif (buffer == Buffer.B):
    buffer_str = struct.pack('!b', buffer) + b'\x00' + struct.pack('!b', buffer_idx)
  else:
    print("Wrong buffer - matrix has not been sent")
    quit()

  data_str = struct.pack('!b', matrix.shape[0]) + struct.pack('!b', matrix.shape[1]) + b'\x00'
  for x in np.nditer(matrix, order = 'F'):
      data_str = data_str + struct.pack('!b', x) #(x if x >= 0 else (0xFF + x + 1))

  length = struct.pack('!H', 7 + matrix.shape[0] * matrix.shape[1])
  payload = cmd_str + buffer_str + data_str

  send_eth(MAC_HOST, MAC_MPU, length, payload)


def multiply_matrices(buffer_a_idx, buffer_b_idx, bias, activation, pooling):
  """Multiple matrices from MPU buffer and get result"""

  if (buffer_a_idx >= BUFFER_CNT):
    print("Wrong buffer_a index - matrix has not been sent")
    quit()

  if (buffer_b_idx >= BUFFER_CNT):
    print("Wrong buffer_b index - matrix has not been sent")
    quit()

  cmd_str = struct.pack('!b', Command.MULTIPLY)
  buffer_a_str = struct.pack('!b', buffer_a_idx)
  buffer_b_str = struct.pack('!b', buffer_b_idx)
  bias_str = struct.pack('!i', bias)
  activation_str = struct.pack('!b', activation)
  pooling_str = struct.pack('!b', pooling)

  length = struct.pack('!H', 10)
  payload = cmd_str + b'\x00' + buffer_a_str + buffer_b_str + bias_str + activation_str + pooling_str

  start_time = time.perf_counter()
  send_eth(MAC_HOST, MAC_MPU, length, payload)
  (frame_type, dim_x, dim_y, data, end_time) = receive_data()
  exec_time = end_time - start_time

  if (frame_type == Frame.NONE):
      print("Unknown frame received")
      return 0
  elif (frame_type == Frame.ERR_DIM):
      print("Matrices have wrong dimensions - cannot be multiplied")
      return 0
  elif (frame_type == Frame.ERR_CMD):
      print("Wrong command has been sent to MPU")
      return 0
  elif (frame_type == Frame.ERR_FRAME):
      print("Frame sent to MPU has wrong format")
      return 0

  matrix = np.arange(dim_x*dim_y).reshape(dim_x,dim_y)
  for y in range(dim_y):
    for x in range(dim_x):
      data_packed = data[(4 * (dim_x * y + x)):(4 * (dim_x * y + x + 1))]
      data_unpacked = struct.unpack('!i', data_packed)
      matrix[x][y] = data_unpacked[0]

  return (matrix, exec_time)


if __name__ == "__main__":

  ITER = 100
  ETH_P_ALL = 3
  MTU = 1500
  MAC_HOST = b'\x1C\x39\x47\xC7\x34\xBE';
  MAC_MPU = b'\x50\x44\x33\x22\x11\xEE';
  print()

  s = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL))

  # From the docs: "For raw packet
  # sockets the address is a tuple (ifname, proto [,pkttype [,hatype]])"
  s.bind(('enp1s0', 0))

  passed = 0
  cpu_faster = 0
  mpu_faster = 0

  for i in range(0, ITER):

    print ("Iteration: ", i+1)
    print ()

    Ax = np.random.randint(1, MMU_SIZE)
    Ay = np.random.randint(1, MMU_SIZE)
    Bx = Ay
    By = np.random.randint(1, MMU_SIZE)

    print ("Input matrix A:")
    print ()
    A = np.random.randint(-128, 127, size=(Ax,Ay), dtype=np.int8)
    Adf = pd.DataFrame(A)
    print(Adf)
    print()

    print ("Input matrix B:")
    print ()
    B = np.random.randint(-128, 127, size=(Bx,By), dtype=np.int8)
    Bdf = pd.DataFrame(B)
    print(Bdf)
    print()

    try:
      start_time = time.perf_counter()
      C_cpu = A.astype(int) @ B.astype(int)
      end_time = time.perf_counter()
      cpu_exec_time = end_time - start_time

      print("CPU result matrix:")
      print()
      Cdf = pd.DataFrame(C_cpu)
      print(Cdf)
      print()

    except(ValueError):
      cpu_exec_time = 0
      print('Matrices dimensions are not aligned for multiplication')
      print()

    send_matrix(A, Buffer.A, 0)
    send_matrix(B, Buffer.B, 0)

    (C_mpu, mpu_exec_time) = multiply_matrices(0, 0, 0, Activation.NONE, Pooling.NONE)

    print("MPU result matrix:")
    print()
    Cdf = pd.DataFrame(C_mpu)
    print(Cdf)
    print()

    if (C_cpu==C_mpu).all():
      passed = passed + 1
      print("Matrices are equal!")
      print()
    else:
      print("Matrices are different...")
      print()

    if cpu_exec_time < mpu_exec_time:
      cpu_faster = cpu_faster + 1
    else:
      mpu_faster = mpu_faster + 1

    print('CPU execution time: ' + str(cpu_exec_time) + ' s')
    print('MPU execution time: ' + str(mpu_exec_time) + ' s')
    print()
    print("------------------------------------------------------------------------")
    print()

  print('Passed:', passed, '/', ITER, '(', (100*passed)/ITER, '%)')
  print('CPU was faster', cpu_faster, '/', ITER, 'times (', (100*cpu_faster)/ITER, '%)')
  print('MPU was faster', mpu_faster, '/', ITER, 'times (', (100*mpu_faster)/ITER, '%)')
  print()
