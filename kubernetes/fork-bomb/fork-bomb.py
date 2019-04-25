import os
import sys
import time

if __name__ == '__main__':
    num = int(sys.argv[1])
    for i in range(num):
        print(i)
        if os.fork() == 0:
            time.sleep(1000)
