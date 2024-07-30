
with open("RAM.txt", 'w') as RAM:

  with open("program.txt",'r') as program:
    for line in program:
      command = line.split()
      if command[0] == "NOP":
        print command
        RAM.write("00000000\n")
      elif command[0] == "JMP":
        print command
        RAM.write("01"+command[1]+"0000\n") 
      elif command[0] == "JEZ":
        print command
        RAM.write("02"+command[1]+command[2]+"00\n") 
      elif command[0] == "JGZ":
        print command
        RAM.write("03"+command[1]+command[2]+"00\n") 
      elif command[0] == "JLZ":
        print command
        RAM.write("04"+command[1]+command[2]+"00\n") 
      elif command[0] == "HLT":
        print command
        RAM.write("05000000\n")
      elif command[0] == "ADD":
        print command
        RAM.write("40"+command[1]+command[2]+command[3]+"\n") 
      elif command[0] == "SUB":
        print command
        RAM.write("41"+command[1]+command[2]+command[3]+"\n")
      elif command[0] == "AND":
        print command
        RAM.write("80"+command[1]+command[2]+command[3]+"\n")
      elif command[0] == "OR":
        print command
        RAM.write("81"+command[1]+command[2]+command[3]+"\n")
      elif command[0] == "XOR":
        print command
        RAM.write("82"+command[1]+command[2]+command[3]+"\n")
      elif command[0] == "SFL":
        print command
        RAM.write("83"+command[1]+"0000\n")
      elif command[0] == "SFR":
        print command
        RAM.write("84"+command[1]+"0000\n")
      elif command[0] == "LD":
        print command
        RAM.write("C0"+command[1]+command[2]+"00\n") 
      elif command[0] == "ST":
        print command
        RAM.write("C1"+command[1]+command[2]+"00\n") 
      elif command[0] == "MOV":
        print command
        RAM.write("C2"+command[1]+command[2]+"00\n") 
      elif command[0] == "MVL":
        print command
        RAM.write("C3"+command[1]+command[2]+"\n")
      elif command[0] == "MVH":
        print command
        RAM.write("C4"+command[1]+command[2]+"\n")
      elif command[0] == "CLR":  
        print command 
        RAM.write("C5"+command[1]+"0000\n") 
      elif command[0] == "@":
        print command
        RAM.write("@"+command[1]+"\n")
      else:
        print command
        RAM.write(command[0]+"\n")

