address = 0;
with open("RAM.mif", 'w') as RAM:

  RAM.write("DEPTH = 512;\n")
  RAM.write("WIDTH = 32;\n")
  RAM.write("ADDRESS_RADIX = HEX;\n")
  RAM.write("DATA_RADIX = HEX;\n")
  RAM.write("CONTENT\n")
  RAM.write("BEGIN\n")
  
  with open("program.txt",'r') as program:
    for line in program:
      command = line.split()
      if command[0] == "NOP":
        print command
        RAM.write(str(format(address,'02X')) + " : " + "00000000;\n")
        address += 1
      elif command[0] == "JMP":
        print command
        RAM.write(str(format(address,'02X')) + " : " + "01"+command[1]+"0000;\n") 
        address += 1
      elif command[0] == "JEZ":
        print command
        RAM.write(str(format(address,'02X')) + " : " + "02"+command[1]+command[2]+"00;\n") 
        address += 1
      elif command[0] == "JGZ":
        print command
        RAM.write(str(format(address,'02X')) + " : " + "03"+command[1]+command[2]+"00;\n") 
        address += 1
      elif command[0] == "JLZ":
        print command
        RAM.write(str(format(address,'02X')) + " : " + "04"+command[1]+command[2]+"00;\n")
        address += 1 
      elif command[0] == "HLT":
        print command
        RAM.write(str(format(address,'02X')) + " : " + "05000000;\n")
        address += 1
      elif command[0] == "ADD":
        print command
        RAM.write(str(format(address,'02X')) + " : " + "40"+command[1]+command[2]+command[3]+";\n")
        address += 1 
      elif command[0] == "SUB":
        print command
        RAM.write(str(format(address,'02X')) + " : " + "41"+command[1]+command[2]+command[3]+";\n")
        address += 1
      elif command[0] == "AND":
        print command
        RAM.write(str(format(address,'02X')) + " : " + "80"+command[1]+command[2]+command[3]+";\n")
        address += 1
      elif command[0] == "OR":
        print command
        RAM.write(str(format(address,'02X')) + " : " + "81"+command[1]+command[2]+command[3]+";\n")
        address += 1
      elif command[0] == "XOR":
        print command
        RAM.write(str(format(address,'02X')) + " : " + "82"+command[1]+command[2]+command[3]+";\n")
        address += 1
      elif command[0] == "SFL":
        print command
        RAM.write(str(format(address,'02X')) + " : " + "83"+command[1]+"0000;\n")
        address += 1
      elif command[0] == "SFR":
        print command
        RAM.write(str(format(address,'02X')) + " : " + "84"+command[1]+"0000;\n")
        address += 1
      elif command[0] == "LD":
        print command
        RAM.write(str(format(address,'02X')) + " : " + "C0"+command[1]+command[2]+"00;\n") 
        address += 1
      elif command[0] == "ST":
        print command
        RAM.write(str(format(address,'02X')) + " : " + "C1"+command[1]+command[2]+"00;\n") 
        address += 1
      elif command[0] == "MOV":
        print command
        RAM.write(str(format(address,'02X')) + " : " + "C2"+command[1]+command[2]+"00;\n") 
        address += 1
      elif command[0] == "MVL":
        print command
        RAM.write(str(format(address,'02X')) + " : " + "C3"+command[1]+command[2]+";\n")
        address += 1
      elif command[0] == "MVH":
        print command
        RAM.write(str(format(address,'02X')) + " : " + "C4"+command[1]+command[2]+";\n")
        address += 1
      elif command[0] == "CLR":  
        print command 
        RAM.write(str(format(address,'02X')) + " : " + "C5"+command[1]+"0000;\n") 
        address += 1
      else:
        print command
        RAM.write(str(format(address,'02X')) + " : " + command[0]+";\n")
        address += 1

  RAM.write("END;\n")
