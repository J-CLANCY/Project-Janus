regs = ["00","01","02","03","04","05","06","07","08","09","0A","0B","0C","0D","0E","0F"]
vals = ["11","12","13","14","15","16","17","18","19","1A","1B","1C","1D","1E","1F","20"]

with open("../rtl/RAM.txt", 'w') as RAM:

    for i in range(0,16):
      RAM.write("C3"+regs[i]+vals[i]+"00\n")

    for i in regs:
      RAM.write("01"+i+"0000\n")

    RAM.write("05000000\n")
