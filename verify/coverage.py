regs = ["00","01","02","03","04","05","06","07","08","09","0A","0B","0C","0D","0E","0F"]

with open("RAM.txt", 'w') as RAM:
    for i in regs:
      for j in regs:
        RAM.write("C0"+i+j+"00\n")
        RAM.write("C5"+i+"0000\n")

    for i in regs:
      for j in regs:
        RAM.write("C1"+i+j+"00\n")
        RAM.write("C5"+i+"0000\n")

    for i in regs:
      for j in regs:
        for k in regs:
          RAM.write("40"+i+j+k+"\n")

    for i in regs:
      for j in regs:
        for k in regs:
          RAM.write("41"+i+j+k+"\n")

    for i in regs:
      for j in regs:
        for k in regs:
          RAM.write("80"+i+j+k+"\n")

    for i in regs:
      for j in regs:
        for k in regs:
          RAM.write("81"+i+j+k+"\n")

    for i in regs:
      for j in regs:
        for k in regs:
          RAM.write("82"+i+j+k+"\n")

    for i in regs:
      RAM.write("83"+i+"0000\n")

    for i in regs:
      RAM.write("83"+i+"0000\n")

    for i in regs:
      for j in regs:
        RAM.write("C2"+i+j+"00\n")

    for i in regs:
      RAM.write("C3"+i+"BEEF\n")

    for i in regs:
      RAM.write("C4"+i+"DEAD\n")

    for i in regs:
      RAM.write("C5"+i+"0000\n")

    RAM.write("00000000\n")
    RAM.write("05000000\n")
