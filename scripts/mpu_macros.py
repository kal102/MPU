
from enum import Enum, IntEnum

MMU_SIZE = 10
BUFFER_CNT = 4

class Command(IntEnum):
    NONE = 0x00
    LOAD = 0x01
    MULTIPLY = 0x02

class Buffer(IntEnum):
    A = 0x00
    B = 0x01

class Activation(IntEnum):
    NONE = 0x00
    RELU = 0x01

class Pooling(IntEnum):
    NONE = 0x00
    MAX = 0x01

class Frame(IntEnum):
    NONE = 0x00
    DATA = 0x01
    ERR_DIM = 0x03
    ERR_CMD = 0x02
    ERR_FRAME = 0x06

    #def __str__(self):
    #    return str(self.value)
