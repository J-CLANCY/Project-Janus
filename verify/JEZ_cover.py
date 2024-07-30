regs = ["00","01","02","03","04","05","06","07","08","09","0A","0B","0C","0D","0E","0F"]

with open("../rtl/RAM.txt", 'w') as RAM:
    
    RAM.write("00000000\n")  
  
    for i in regs:
      for j in regs:
        RAM.write("02"+i+j+"00\n")

    RAM.write("05000000\n")
