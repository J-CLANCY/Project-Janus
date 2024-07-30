# Project-Janus

Repository for the 32-bit RISC processor as part of my undergraduate work placement at ON Semiconductor.

This repository is for the digital ASIC design project I completed at the beginning of my undergraduate work placement at ON Semiconductor in Limerick City, Ireland. My supervisor at the time asked me what sort of project I would like to undertake to use as a case study to learn digital ASIC design. Having built [Project Thistle](https://github.com/J-CLANCY/Project-Thistle/tree/main), I decided I wanted to try a 32-bit implementation. Much to my supervisor's annoyance, I finished this project in a week, which meant he had to give me actual work to do. Following this, I was given responsibility over the register banks as part of a consumer-grade Power Management IC (PMIC) project ongoing at the time.  I consequently learned a lot about the full spectrum of ASIC design, from digital, analog, and layout design, all the way to tape-out, testing and evaluation.

My goals with this processor were:
- To learn Verilog
- To learn how to use Cadence Design tools
- Implement a 32-bit processor
- Run it on an FPGA, such that I can interact with it

To achieve this, I purchased a [DEO-Nano FPGA from Terasic](https://www.terasic.com.tw/cgi-bin/page/archive.pl?No=593) (now owned by Intel). It's a nifty little FPGA, not overly endowed with Logic Elements (LE), but it was within my budget. It is fairly evident at the time that I was particularly interested in state machines as I was determined to create the control logic in terms of micro-instructions, which entirely bloated the processor into a 38-cycle machine, see its flowchart below (forgive me). While I was aware at the time of single-cycle processors and pipelining, something compelled me to create that god-awful state machine. My current hypothesis is that the fear of the critical path deluded me into thinking that extremely short paths, with precisely controlled signalling (to avoid race conditions), were the appropriate design choice. Regardless, I have never been as locked-in as I was during that week, it was a lot of fun to make. The sheer elation of being able to run the processor on an FPGA and then interact with it is something that I chase to this day. The Cyclone IV FPGA was able to run this processor at a whopping 227MHz, I was very pleased about this.

![Janus](/docs/images/instruction_decoder_flow_chart.png)

## Project Structure

'''
```
├── ""docs"" => Contains documentation for this project.  
│    ├── ""diagrams"" => Contains ODG diagrams for each module and the processor
│    ├── ""images"" => Contains images of the modules and processor architecture.
│    ├── ""output"" => Contains spreadsheets with the synthesis results from ASIC and FPGA synthesis.
│    ├── ""specs"" => Contains the specifications for each module and the processor.
│    ├── ""FPGA_interpreter.py"" => A Python script for interpretting the .MIF file provided by the FPGA to access RAM.
│    ├── ""interpreter.py"" => A Python script for interpretting the assembly program into binary.
│    ├── ""program.txt"" => A text file contains the assembly program to be run.
│    ├── ""RAM.mif"" => The .MIF file provided by the FPGA to access RAM.
├── ""rtl"" => Contains the Verilog source code for the processor.
├── ""verify"" => Contains a series of Python scripts and associated testbenches for verifying each of the modules and the processor.
```
'''
