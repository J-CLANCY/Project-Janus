regs = ["00","01","02","03","04","05","06","07","08","09","0A","0B","0C","0D","0E","0F"]

with open("../rtl/RAM.txt", 'w') as RAM:
    
    RAM.write("00000000\n")  
  
    for i in regs:
      for j in regs:
        for k in regs:
          RAM.write("41"+i+j+k+"\n")
          RAM.write("C5"+i+"0000\n")
          RAM.write("C5"+j+"0000\n")
          RAM.write("C5"+k+"0000\n")

    RAM.write("05000000\n")
