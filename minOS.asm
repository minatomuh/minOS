# minOS.asm
# A simple non-preemptive operating system capable of running multiple threads
# Written for C312 CPU, suitable for 16 bit or higher

###############################################################################################################################################
###################################################### C312 Instruction Set Architecture ######################################################
###############################################################################################################################################
## SET B A             ;mem[A] = B                              # Sets number B to memory address A                                          ##
## CPY A1 A2           ;mem[A2] = mem[A1]                       # Copy the value in memory address A1 to memory address A2                   ##
## CPYI A1 A2          ;mem[A2] = mem[mem[A1]]                  # Copy the memory address indexed by A1 to memory address A2                 ##
## CPYI2 A1 A2         ;mem[mem[A2]] = mem[mem[A1]]             # Copy the memory address indexed by A1 to memory address indexed by A2      ##
## ADD A B             ;mem[A] = mem[A] + B                     # Adds number B to memory address A                                          ##
## ADDI A1 A2          ;mem[A1] = mem[A1] + mem[A2]             # Adds the value in memory address A2 to memory address A1                   ##   
## SUBI A1 A2          ;mem[A2] = mem[A1] - mem[A2]             # Subtracts the value in memory address A2 from memory address A1            ##
## JIF A C             ;PC = if mem[A] <= 0 then C else PC+1    # Jump if the value in memory address A is less than or equal to 0           ##
## PUSH A              ;mem[SP] = mem[A]; SP = SP - 1           # Pushes the value in memory address A to the stack                          ##
## POP A               ;mem[A] = mem[SP]; SP = SP + 1           # Pops the value from the stack to memory address A                          ##
## CALL C              ;PC = C; PUSH PC                         # Calls the subroutine at address C and pushes the current PC to the stack   ##
## RET                 ;POP SP                                  # Returns from subroutine                                                    ##
## HLT                 ;Halts CPU                                                                                                            ##
## USER A              ;Switches to user mode and jumps to address A                                                                         ##                      
## SYSCALL PRN A       ;Prints mem[A]                                                                                                        ##
## SYSCALL HLT         ;Halts the thread                                                                                                     ##
## SYSCALL YIELD       ;Thread yields the CPU                                                                                                ##
###############################################################################################################################################
###############################################################################################################################################

Begin Data Section
0 0     # PC
1 999   # SP of OS
2 0     # syscall result
3 0     # number of instructions executed so far

# Registers start
4 3 # OS - Active User Thread Count: initially 3, except OS
5 0
6 0
7 0
8 0
9 0
10 0
11 0
12 0
13 0
14 0
15 0
16 0
17 0
18 0
19 0
20 0
# Registers end

## OS Data start
21 0

# Thread table
# The OS itself also does have a table entry
# Each thread takes 25 entries, starting from 100

# Thread 0 (OS) entry
100 0 # Thread ID
101 0 # Starting time of the thread
102 0 # Executions used so far
103 3 # State of the thread (0 = finished, 1 = blocked, 2 = ready, 3 = running)
104 0 # Register 0 (PC)
105 999 # Register 1 (SP)
106 0 # Register 2 (syscallResult)
107 0 # Register 3 (instrCount)
108 0 # Register 4
109 0 # Register 5
110 0 # Register 6
111 0 # Register 7
112 0 # Register 8
113 0 # Register 9
114 0 # Register 10
115 0 # Register 11
116 0 # Register 12
117 0 # Register 13
118 0 # Register 14
119 0 # Register 15
120 0 # Register 16
121 0 # Register 17
122 0 # Register 18
123 0 # Register 19
124 0 # Register 20

# Thread 1 (Bubble Sort) entry
125 1 # Thread ID
126 0 # Starting time of the thread
127 0 # Executions used so far
128 2 # State of the thread (2 = ready)
129 1000 # Register 0 (PC) - points to the start of the bubble sort code
130 1998 # Register 1 (SP) - points to the start of the thread 1 stack

# Thread 2 (Linear Search) entry
150 2 # Thread ID
151 0 # Starting time of the thread
152 0 # Executions used so far
153 2 # State of the thread (2 = ready)
154 2000 # Register 0 (PC) - points to the start of the linear search code
155 2998 # Register 1 (SP) - points to the start of the thread 2 stack

# Thread 3 (Reverse Array) entry
175 3 # Thread ID
176 0 # Starting time of the thread
177 0 # Executions used so far
178 2 # State of the thread (2 = ready)
179 3000 # Register 0 (PC) - points to the start of the reverse array code
180 3998 # Register 1 (SP) - points to the start of the thread 3 stack

# Thread 4 (Placeholder) entry
200 4 # Thread ID
201 0 # Starting time of the thread
202 0 # Executions used so far
203 0 # State of the thread (not used, 0 = finished)
204 4000 # Register 0 (PC) - points to the start of the thread 4 code
205 4998 # Register 1 (SP) - points to the start of the thread 4 stack

# Thread 5 (Placeholder) entry
225 5 # Thread ID
226 0 # Starting time of the thread
227 0 # Executions used so far
228 0 # State of the thread (not used, 0 = finished)
229 5000 # Register 0 (PC) - points to the start of the thread 5 code
230 5998 # Register 1 (SP) - points to the start of the thread 5 stack

# Thread 6 (Placeholder) entry
250 6
251 0 # Starting time of the thread
252 0 # Executions used so far
253 0 # State of the thread (not used, 0 = finished)
254 6000 # Register 0 (PC) - points to the start of the thread 6 code
255 6998 # Register 1 (SP) - points to the start of the thread 6 stack

# Thread 7 (Placeholder) entry
275 7 # Thread ID
276 0 # Starting time of the thread
277 0 # Executions used so far
278 0 # State of the thread (not used, 0 = finished)
279 7000 # Register 0 (PC) - points to the start of the thread 7 code
280 7998 # Register 1 (SP) - points to the start of the thread 7 stack

# Thread 8 (Placeholder) entry
300 8 # Thread ID
301 0 # Starting time of the thread
302 0 # Executions used so far
303 0 # State of the thread (not used, 0 = finished)
304 8000 # Register 0 (PC) - points to the start of the thread 8 code
305 8998 # Register 1 (SP) - points to the start of the thread 8 stack

# Thread 9 (Placeholder) entry
325 9 # Thread ID
326 0 # Starting time of the thread
327 0 # Executions used so far
328 0 # State of the thread (not used, 0 = finished)
329 9000 # Register 0 (PC) - points to the start of the thread 9 code
330 9998 # Register 1 (SP) - points to the start of the thread 9 stack

# Thread 10 (Placeholder) entry
350 10 # Thread ID
351 0 # Starting time of the thread
352 0 # Executions used so far
353 0 # State of the thread (not used, 0 = finished)
354 10000 # Register 0 (PC) - points to the start of the thread 10 code
355 19998 # Register 1 (SP) - points to the start of the thread 10 stack




999 0 # End of OS Stack
## OS Data end

################################################ Thread 1 Data // Bubble Sort ################################################
# Initialize array data (10 elements)
1000 10     # N = 10 (number of elements to sort)
1001 64     # Element 0
1002 34     # Element 1
1003 25     # Element 2
1004 12     # Element 3
1005 22     # Element 4
1006 90     # Element 5
1007 88     # Element 6
1008 76     # Element 7
1009 50     # Element 8
1010 42     # Element 9

1998 0      # SP points here initially
1999 1000   # First stack holds the starting instruction point
##################################################### Thread 1 Data end #####################################################



################################################ Thread 2 Data // Linear Search ################################################
2000 10 # N = 10
2001 91 # Key to search
2002 10 # Array[0]
2003 15 # Array[1]
2004 42 # Array[2]
2005 88 # Array[3]
2006 99 # Array[4]
2007 54 # Array[5]
2008 91 # Array[6] - match
2009 14 # Array[7]
2010 68 # Array[8]
2011 33 # Array[9]

2998 0      # SP points here initially
2999 2000   # First stack holds the starting instruction point
##################################################### Thread 2 Data end #####################################################

################################################ Thread 3 Data // Reverse Array ################################################
3000 10     # N = 10 (number of elements)
3001 1     # Element 0
3002 2     # Element 1
3003 3     # Element 2
3004 4     # Element 3
3005 5     # Element 4
3006 6     # Element 5
3007 7     # Element 6
3008 8     # Element 7
3009 9     # Element 8
3010 10     # Element 9

3998 0      # SP points here initially
3999 3000   # First stack holds the starting instruction point
###################################################### Thread 3 Data end ######################################################


# Thread 4 Data
4000 0 

4998 0      # SP points here initially
4999 4000   # First stack holds the starting instruction point
# Thread 4 Data end

# Thread 5 Data
5000 0

5998 0      # SP points here initially
5999 5000   # First stack holds the starting instruction point
# Thread 5 Data end

# Thread 6 Data
6000 0 

6998 0      # SP points here initially
6999 6000   # First stack holds the starting instruction point
# Thread 6 Data end

# Thread 7 Data
7000 0

7998 0      # SP points here initially
7999 7000   # First stack holds the starting instruction point
# Thread 7 Data end

# Thread 8 Data
8000 0 

8998 0      # SP points here initially 
8999 8000   # First stack holds the starting instruction point
# Thread 8 Data end

# Thread 9 Data
9000 0 

9998 0      # SP points here initially
9999 9000   # First stack holds the starting instruction point
# Thread 9 Data end

# Thread 10 Data
10000 0 

19998 0         # SP points here initially
19999 10000     # First stack holds the starting instruction point
# Thread 10 Data end

End Data Section

####################################### INSTRUCTION SECTION ########################################################
Begin Instruction Section

### OS START ###

# Round Robin Scheduler Loop
# Loops through 1 to 10 (max possible thread count)
# OS should run in a loop, checking the thread table for active threads

# Register 4 has active thread count - initially 3, except OS
# Registers from 5 are free to use

0 SET 125 5 # Set thread table start address - FIXED DO NOT CHANGE
1 SET 25 6 # Set thread jump literal - FIXED DO NOT CHANGE
#'reset_loop:'
2 SET 1 7 # i = 1
3 CPY 5 8 # thread table pointer (initially points to first thread entry)
4 SET 0 9 # temp
5 SET 0 10 # temp2
6 SET 0 11 # temp3
7 SET 0 12 # temp4
8 SET 0 13 # temp5
9 SET 0 20 # current thread ID
# infinite loop
# Check here if active thread <= 0, that means no threads are running, exit loop and halt the OS
    10 JIF 4 104 #'exit_loop' # if active thread count <= 0, exit loop

    #skip if thread is finished / check *(table + 3) == 4th entry
    11 CPY 8 9 # temp = thread table pointer
    12 ADD 9 3 # temp += 3
    13 CPYI 9 10 # temp2 = *(thread pointer + 3)
    14 JIF 10 97 #'continue' # if thread state <= 0, continue to next thread

    # Store OS registers to thread table
    15 CPY 0 104
    16 CPY 1 105
    17 CPY 2 106
    18 CPY 4 108
    19 CPY 5 109
    20 CPY 6 110
    21 CPY 7 111
    22 CPY 8 112
    23 CPY 9 113
    24 CPY 10 114
    25 CPY 11 115
    26 CPY 12 116
    27 CPY 13 117
    28 CPY 14 118
    29 CPY 15 119
    30 CPY 16 120
    31 CPY 17 121
    32 CPY 18 122
    33 CPY 19 123
    34 CPY 20 124

    # Restore thread registers from thread table
    35 CPY 8 9 # temp = thread_table_pointer

    # set starting time if it is 0
    36 ADD 9 1 # temp = thread_table_pointer + 1 (start time of thread)
    37 CPYI 9 10 # temp2 = starting time of thread
    38 JIF 10 44 #'set_time'

    # set thread state to running
    39 ADD 9 2 # temp = thread_table_pointer + 2 (state of thread)
    40 SET 3 10 # temp2 = 3 (running state)
    41 SET 10 11 # temp3 = 10 (address of temp2)
    42 CPYI2 11 9 # set thread state to running
    43 SET 50 0 #'restore registers' 0 # do not set time, only restore registers

    #'set_time:'
    44 SET 3 10 # temp2 = address of reg 3
    45 CPYI2 10 9 # set starting time of thread

    # set thread state to running
    46 ADD 9 2 # temp = thread_table_pointer + 2 (state of thread)
    47 SET 3 10 # temp2 = 3 (running state)
    48 SET 10 11 # temp3 = 10 (address of temp2)
    49 CPYI2 11 9 # set thread state to running

    #'restore registers:'
    50 ADD 9 2 # temp = thread_table_pointer + 2 (SP)
    51 CPY 9 50 # use OS memory for pointer, registers will be replaced
    52 CPY 7 124 # save current thread index to OS table reg 20
    53 CPYI 50 1 # restore SP
    54 ADD 50 1 # (syscallResult)
    55 CPYI 50 2 # restore syscall result
    56 ADD 50 1 # (instruction counter)
    57 CPYI 50 51 # restore instruction counter onto 51, because cpu still increases it
    58 ADD 50 1 # (reg4)
    59 CPYI 50 4 # restore reg4
    60 ADD 50 1 # (reg5)
    61 CPYI 50 5 # restore reg5
    62 ADD 50 1 # (reg6)
    63 CPYI 50 6 # restore reg6
    64 ADD 50 1 # (reg7)
    65 CPYI 50 7 # restore reg7
    66 ADD 50 1 # (reg8)
    67 CPYI 50 8 # restore reg8
    68 ADD 50 1 # (reg9)
    69 CPYI 50 9 # restore reg9
    70 ADD 50 1 # (reg10)
    71 CPYI 50 10 # restore reg10
    72 ADD 50 1 # (reg11)
    73 CPYI 50 11 # restore reg11
    74 ADD 50 1 # (reg12)
    75 CPYI 50 12 # restore reg12
    76 ADD 50 1 # (reg13)
    77 CPYI 50 13 # restore reg13
    78 ADD 50 1 # (reg14)
    79 CPYI 50 14 # restore reg14
    80 ADD 50 1 # (reg15)
    81 CPYI 50 15 # restore reg15
    82 ADD 50 1 # (reg16)
    83 CPYI 50 16 # restore reg16
    84 ADD 50 1 # (reg17)
    85 CPYI 50 17 # restore reg17
    86 ADD 50 1 # (reg18)
    87 CPYI 50 18 # restore reg18
    88 ADD 50 1 # (reg19)
    89 CPYI 50 19 # restore reg19
    90 ADD 50 1 # (reg20)
    91 CPYI 50 20 # restore reg20

    # OS thread table last update
    92 ADDI 102 3   # increment table entry for OS(executions used so far)
    93 ADD 102 3   # increment for the next 3 instructions

    94 CPY 51 3    # restore thread instrCount

    95 USER 96 # Switch to user mode
    96 RET # jump to thread, same as POP 0 (sp is already restored from thread table)

    # OS continues here after a context switch
    # make sure that OS registers are restored
    #'os_return:'

    #'continue:'
    97 ADD 7 1 # ++i
    98 ADD 8 25 # move to next thread - &thread_table_pointer += 25
    
    # if (11 - i <= 0) reset loop (i = 1)
    99 CPY 7 9 # temp = i
    100 SET 11 10 # temp2 = 11 # which is total_threads + 1
    101 SUBI 10 9 # reg9 = (reg10 - reg9) = (11 - i)
    102 JIF 9 2 #'reset_loop'
    103 SET 10 0 # continue loop
# end loop

#'exit_loop'
# here would be the end of the OS loop
# OS should halt the whole CPU here
104 HLT


# OS Subroutine to block the thread for 100 instructions
################# not implemented yet #################


# OS Subroutine to halt the thread # INSTR 200
# No need to save registers, just set current thread state to finished

    200 CPY 107 3 # Restore instrCount from OS table first

    201 SET 100 21 # Set thread table start address - FIXED DO NOT CHANGE
    202 CPY 21 22 # thread table pointer in mem[22]

    # This loop will calculate 100 + mem[124] * 25
    203 CPY 124 23 # i = thread_id
    # loop_start
        #'continue_loop'
        # loop condition: i <= 0
        204 JIF 23 208 #'loop_end' # if i <= 0, end loop

        205 ADD 22 25 # jump next thread table entry
        206 ADD 23 -1 # --i
        207 SET 204 0 #'continue_loop' 0 # continue loop
    # loop_end
    #'loop_end:' 

    # Now appropriate thread table pointer is in mem[22]
    208 ADD 22 3 # thread table pointer + 3 (state of thread)
    209 SET 0 24 # store 0 into a register
    210 SET 24 25 # set 25 to 24
    211 CPYI2 25 22 # set thread state to finished (0)

    # Restore OS registers from thread table
    212 CPY 105 1
    213 CPY 106 2
    214 CPY 108 4
    215 CPY 109 5
    216 CPY 110 6
    217 CPY 111 7
    218 CPY 112 8
    219 CPY 113 9
    220 CPY 114 10
    221 CPY 115 11
    222 CPY 116 12
    223 CPY 117 13
    224 CPY 118 14
    225 CPY 119 15
    226 CPY 120 16
    227 CPY 121 17
    228 CPY 122 18
    229 CPY 123 19
    230 CPY 124 20
    # Decrement active thread count
    231 ADD 4 -1 # active thread count -= 1
    # Return to round robin scheduler loop
    232 SET 97 0 # 'os_return' 0


# OS Subroutine to yield the CPU # INSTR 300
    # SP is currently at thread's stack pointer, save it to thread table with other registers, determine which thread to put
    # solution: thread id from previous OS thread table (register) 
    # current thread number is on the mem[124]
    # After saving the thread registers to table,
    # restore OS values from thread table (thread table also stores OS registers)

    # Store thread registers to thread table
    # memory 21-49 are free to use 
    # thread table pointer for appropriate thread would be = (100 + mem[124] * 25)

    300 CPY 3 24 # Save current thread instrCount to mem[24] // we do not want it to be modified, will be put into table later
    301 SET 0 3 # Reset instrCount to 0 as implementation policy // total instr count is on thread table

    302 SET 100 21 # Set thread table start address - FIXED DO NOT CHANGE
    303 CPY 21 22 # thread table pointer in mem[22]

    # This loop will calculate 100 + mem[124] * 25
    304 CPY 124 23 # i = thread_id
    # loop_start
        #'continue_loop'
        # loop condition: i <= 0
        305 JIF 23 309 # 'loop_end' # if i <= 0, end loop

        306 ADD 22 25 # jump next thread table entry
        307 ADD 23 -1 # --i
        308 SET 305 0 #'continue_loop' 0 # continue loop
    # loop_end
    #'loop_end:' 

    # Now appropriate thread table pointer is in mem[22]
    # Store thread registers to thread table
    309 ADD 22 2 # thread table pointer + 2 (executions used so far)
    # 25 = *table_pointer + mem[24]
    310 CPYI 22 25 # 25 = *table_pointer
    311 ADDI 25 24 # 25 = *table_pointer + mem[24]
    # Store new total executions to thread table
    312 SET 25 26 # 26 = 25
    313 CPYI2 26 22 # *table_pointer = mem[25]
    314 ADD 22 1 # thread table pointer + 1 (state of thread)
    315 SET 2 26 # 26 = 2 (ready state)
    316 SET 27 26 # 27 = 26 for cpyi2 mem[mem[27]]
    317 CPYI2 27 22 # set thread table to ready state(2)
    318 ADD 22 2 # thread table pointer + 2 (SP)
    319 SET 1 26
    320 CPYI2 26 22 # store SP to thread table
    321 ADD 22 1 # thread table pointer + 1 (syscallResult)
    322 SET 2 26
    323 CPYI2 26 22 # store syscall result to thread table
    324 ADD 22 1 # thread table pointer + 1 (instruction counter)
    325 SET 24 26
    326 CPYI2 26 22 # store instruction counter to thread table
    327 ADD 22 1 # thread table pointer + 1 (reg4)
    328 SET 4 26
    329 CPYI2 26 22 # store reg4 to thread table
    330 ADD 22 1 # thread table pointer + 1 (reg5)
    331 SET 5 26
    332 CPYI2 26 22 # store reg5 to thread table
    333 ADD 22 1 # thread table pointer + 1 (reg6)
    334 SET 6 26
    335 CPYI2 26 22 # store reg6 to thread table
    336 ADD 22 1 # thread table pointer + 1 (reg7)
    337 SET 7 26
    338 CPYI2 26 22 # store reg7 to thread table
    339 ADD 22 1 # thread table pointer + 1 (reg8)
    340 SET 8 26
    341 CPYI2 26 22 # store reg8 to thread table
    342 ADD 22 1 # thread table pointer + 1 (reg9)
    343 SET 9 26
    344 CPYI2 26 22 # store reg9 to thread table
    345 ADD 22 1 # thread table pointer + 1 (reg10)
    346 SET 10 26
    347 CPYI2 26 22 # store reg10 to thread table
    348 ADD 22 1 # thread table pointer + 1 (reg11)
    349 SET 11 26
    350 CPYI2 26 22 # store reg11 to thread table
    351 ADD 22 1 # thread table pointer + 1 (reg12)
    352 SET 12 26
    353 CPYI2 26 22 # store reg12 to thread table
    354 ADD 22 1 # thread table pointer + 1 (reg13)
    355 SET 13 26
    356 CPYI2 26 22 # store reg13 to thread table
    357 ADD 22 1 # thread table pointer + 1 (reg14)
    358 SET 14 26
    359 CPYI2 26 22 # store reg14 to thread table
    360 ADD 22 1 # thread table pointer + 1 (reg15)
    361 SET 15 26
    362 CPYI2 26 22 # store reg15 to thread table
    363 ADD 22 1 # thread table pointer + 1 (reg16)
    364 SET 16 26
    365 CPYI2 26 22 # store reg16 to thread table
    366 ADD 22 1 # thread table pointer + 1 (reg17)
    367 SET 17 26
    368 CPYI2 26 22 # store reg17 to thread table
    369 ADD 22 1 # thread table pointer + 1 (reg18)
    370 SET 18 26
    371 CPYI2 26 22 # store reg18 to thread table
    372 ADD 22 1 # thread table pointer + 1 (reg19)
    373 SET 19 26
    374 CPYI2 26 22 # store reg19 to thread table
    375 ADD 22 1 # thread table pointer + 1 (reg20)
    376 SET 20 26
    377 CPYI2 26 22 # store reg20 to thread table

    # Restore OS registers from thread table
    378 CPY 105 1
    379 CPY 106 2
    380 CPY 108 4
    381 CPY 109 5
    382 CPY 110 6
    383 CPY 111 7
    384 CPY 112 8
    385 CPY 113 9
    386 CPY 114 10
    387 CPY 115 11
    388 CPY 116 12
    389 CPY 117 13
    390 CPY 118 14
    391 CPY 119 15
    392 CPY 120 16
    393 CPY 121 17
    394 CPY 122 18
    395 CPY 123 19
    396 CPY 124 20

    397 SET 97 0 #'os_return' 0 # Return to round robin scheduler loop


## NOTE: when switching to a thread
# restore threads registers (except PC, we cannot save it but its on threads stack)
# Call USER and call RET after restoring all registers(except PC) to continue the thread where it left. 
# POP 0 is same as RET, # both restores PC from the thread's stack


### THREADS START ###

######################################################## THREAD 1: SORTING N NUMBERS ########################################################
# Thread 1: sort 10 numbers in increasing order
# Using bubble sort algorithm
# swap(int& a, int& b) {
#    if(*a <= *b) return;
#    int temp = *a;
#    *a = *b;
#    *b = temp;
#    return;
#}

#for (int j = 0; j < len - 1; j++) {
#    for (int i = 0; i < len - 1 - j; i++) {       
#        swap(arr[i], arr[i + 1]);
#    }
#}

# REGISTERS:
# 4: len
# 5: array pointer
# 6 = len - 1
# 7: i
# 8: j
# 9: temp
# 10: temp2
# 11: constant 0
# Bubble Sort

# Register initializations
1000 CPY 1000 4 # len = mem[1000]
1001 SET 1001 5 # array pointer (points to the first element)
1002 CPY 4 6
1003 ADD 6 -1 # len - 1 in reg6
1004 SET 0 11 # constant 0 in reg11

1005 SET 0 8 # j = 0
#outer loop
    #Loop condition: 0 < temp(len - 1 - j)
    1006 CPY 6 9 # temp = len - 1
    1007 CPY 8 10 # temp2 = j
    1008 SUBI 11 10 # temp2 = -j
    1009 ADDI 9 10 # temp = len - 1 - j
    1010 JIF 9 1033 # if temp <= 0, end loop
    
    1011 SET 0 7 # i = 0
    #inner loop
        #Loop condition: 0 < temp(len - 1 - j - i)
        # temp = len - 1 - j
        1012 CPY 6 9 # temp = len - 1
        1013 CPY 8 10 # temp2 = j
        1014 SUBI 11 10 # temp2 = -j
        1015 ADDI 9 10 # temp = len - 1 - j
        1016 CPY 7 10 # temp2 = i
        1017 SUBI 11 10 # temp2 = -i
        1018 ADDI 9 10 # temp = len - 1 - j - i
        1019 JIF 9 1030 # if temp <= 0, exit loop

        # put &arr + i in reg19
        # put &arr + i + 1 in reg20
        # call swap
        1020 CPY 5 9 # temp = arr
        1021 ADDI 9 7 # temp = arr + i
        1022 CPY 9 19 # &arr + i in reg19
        1023 CPY 5 9 # temp = arr
        1024 ADDI 9 7 # temp = arr + i
        1025 ADD 9 1 # temp = arr + i + 1
        1026 CPY 9 20 # &arr + i + 1 in reg20
        1027 CALL 1200 # Call swap subroutine

        1028 ADD 7 1 # ++i
        1029 SET 1012 0 # continue inner loop

    # end of inner loop

    1030 SYSCALL YIELD # yield every outer loop iteration

    1031 ADD 8 1 # ++j
    1032 SET 1006 0 # continue outer loop
# end of outer loop

# Sorting ended, start printing
1033 SET 0 7 # i = 0
# printing loop
    #loop condition: (i < len) == (0 < len - i)
    1034 CPY 4 9 # temp = len
    1035 CPY 7 10 # temp2 = i
    1036 SUBI 11 10 # temp2 = -i
    1037 ADDI 9 10 # temp = len - i
    1038 JIF 9 1045 # if temp <= 0, exit loop

    1039 CPY 5 9 # temp = arr
    1040 ADDI 9 7 # temp = arr + i
    1041 CPYI 9 10 # temp2 = mem[arr + i]
    1042 SYSCALL PRN 10 # Print temp2 = arr + i

    1043 ADD 7 1 # ++i
    1044 SET 1034 0 # continue loop

1045 SYSCALL HLT # program end


# swap subroutine / starts from 1200.
# before calling this subroutine, make sure that:
# A's address is in register 19
# B's address is in register 20

# What it does is:
# if(mem[A] <= mem[B]) swap(A, B)

# approach: temp = mem[a] - mem[b]
# JIF temp swap
# RET
1200 CPYI 20 18 # valB(18) = mem[B]
1201 CPYI 19 17 # valA(17) = mem[A]
1202 SUBI 17 18 # valB = valA - valB
# now valB contains the difference
1203 JIF 18 1208 # if diff <= 0, no swap needed, jump to return

# temp = A
# A = B
# B = temp
1204 CPYI 19 16     # temp = *A     - *A is at reg 16
1205 CPYI2 20 19    # *A = *B       - *A is now *B
1206 SET 16 15      # Put address of temp which is 16 into register 15
1207 CPYI2 15 20    # *B = temp     - mem[mem[20]] = (mem[mem[15]] === mem[16])
1208 RET # Return to caller

######################################################## THREAD 1 END ########################################################




######################################################## THREAD 2: LINEAR SEARCH ########################################################

# REGISTERS:
# 4: len
# 5: array pointer
# 6: i
# 7: key
# 8: result
# 9: temp
# 10: temp2
# 11: temp3
# 12: temp4
# 13: constant 0

# for(i = 0; i < len; ++i)
#    if(arr[i] - key <= 0) {
#        if(key - arr[i] <= 0) {
#            // found
#            print i;
#            halt;
#        }
#    }
# }
# print -1; halt;

2000 CPY 2000 4 # len = mem[2000] (N)
2001 SET 2002 5 # arr = 2002 (array start address)
2002 CPY 2001 7 # key = mem[2001] (key to search)
2003 SET -1 8 # result = -1

2004 SET 0 6 # i = 0
# printing loop
    #loop condition: (i < len) == (0 < len - i)
    2005 CPY 4 9 # temp = len
    2006 CPY 6 10 # temp2 = i
    2007 SUBI 13 10 # temp2 = -i
    2008 ADDI 9 10 # temp = len - i
    2009 JIF 9 2022 # if temp <= 0, exit loop

        2010 CPY 5 9 # temp = arr
        2011 ADDI 9 6 # temp = arr + i
        2012 CPYI 9 10 # temp2 = mem[arr + i]
        2013 CPY 10 11 # temp3 = mem[arr + i]

        # check if key - arr[i] <= 0
        2014 SUBI 7 10 # temp2 = key - mem[arr + i]
        2015 JIF 10 2017 # go check reverse
        2016 SET 2020 0 # break if statement, not found

        # check if arr[i] - key <= 0
        2017 CPY 7 12 # temp4 = key
        2018 SUBI 11 12 # temp4 = arr[i] - key
        2019 JIF 12 2025 # if arr[i] - key <= 0, found

    2020 ADD 6 1 # ++i
    2021 SET 2005 0 # continue loop

#loop_end
2022 SYSCALL YIELD # yield before print
2023 SYSCALL PRN 8 # print -1, not found
2024 SYSCALL HLT # program end

#found
2025 SYSCALL YIELD # yield before print
2026 SYSCALL PRN 6 # Print found index
2027 SYSCALL HLT

############################################################# THREAD 2 END #############################################################


######################################################## THREAD 3: REVERSE ARRAY ########################################################
# REGISTERS:
# 4: len
# 5: array pointer
# 6 = len - 1
# 7: i
# 8: j
# 9: temp
# 10: temp2
# 11: constant 0

# Reverse Array
3000 CPY 3000 4 # len = mem[1000]

3001 SET 3001 5 # array pointer (points to the first element)
3002 CPY 4 6
3003 ADD 6 -1 # len - 1 in reg6
3004 SET 0 11 # constant 0 in reg11
3005 SET 0 8 # j = 0
#outer loop
    #Loop condition: 0 < temp(len - 1 - j)
    3006 CPY 6 9 # temp = len - 1
    3007 CPY 8 10 # temp2 = j
    3008 SUBI 11 10 # temp2 = -j
    3009 ADDI 9 10 # temp = len - 1 - j
    3010 JIF 9 3033 # if temp <= 0, end loop
    
    3011 SET 0 7 # i = 0
    #inner loop
        #Loop condition: 0 < temp(len - 1 - j - i)
        # temp = len - 1 - j
        3012 CPY 6 9 # temp = len - 1
        3013 CPY 8 10 # temp2 = j
        3014 SUBI 11 10 # temp2 = -j
        3015 ADDI 9 10 # temp = len - 1 - j
        3016 CPY 7 10 # temp2 = i
        3017 SUBI 11 10 # temp2 = -i
        3018 ADDI 9 10 # temp = len - 1 - j - i
        3019 JIF 9 3030 # if temp <= 0, exit loop

        # put &arr + i in reg19
        # put &arr + i + 1 in reg20
        # call swap(i, i+1)
        3020 CPY 5 9 # temp = arr
        3021 ADDI 9 7 # temp = arr + i
        3022 CPY 9 19 # &arr + i in reg19
        3023 CPY 5 9 # temp = arr
        3024 ADDI 9 7 # temp = arr + i
        3025 ADD 9 1 # temp = arr + i + 1
        3026 CPY 9 20 # &arr + i + 1 in reg20
        3027 CALL 3200 # Call swap subroutine

        3028 ADD 7 1 # ++i
        3029 SET 3012 0 # continue inner loop

    # end of inner loop

    3030 SYSCALL YIELD # yield every outer loop iteration

    3031 ADD 8 1 # ++j
    3032 SET 3006 0 # continue outer loop
# end of outer loop


# Reverse ended, start printing
# Print the reversed array

3033 SET 0 7 # i = 0
# printing loop
    #loop condition: (i < len) == (0 < len - i)
    3034 CPY 4 9 # temp = len
    3035 CPY 7 10 # temp2 = i
    3036 SUBI 11 10 # temp2 = -i
    3037 ADDI 9 10 # temp = len - i
    3038 JIF 9 3045 # if temp <= 0, exit loop

    3039 CPY 5 9 # temp = arr
    3040 ADDI 9 7 # temp = arr + i
    3041 CPYI 9 10 # temp2 = mem[arr + i]
    3042 SYSCALL PRN 10 # Print temp2 = arr + i

    3043 ADD 7 1 # ++i
    3044 SET 3034 0 # continue loop

3045 SYSCALL HLT # program end

# swap subroutine / starts from 1200.
# before calling this subroutine, make sure that:
# A's address is in register 19
# B's address is in register 20

# What it does is:
# swap(A, B)

# temp = A
# A = B
# B = temp
3200 CPYI 19 16     # temp = *A     - *A is at reg 16
3201 CPYI2 20 19    # *A = *B       - *A is now *B
3202 SET 16 15      # Put address of temp which is 16 into register 15
3203 CPYI2 15 20    # *B = temp     - mem[mem[20]] = (mem[mem[15]] === mem[16])
3204 RET # Return to caller

#######################################

4000 SYSCALL HLT
# Thread 4 code
4999 SYSCALL HLT

#######################################

5000 SYSCALL HLT
# Thread 5 code
5999 SYSCALL HLT

#######################################

6000 SYSCALL HLT
# Thread 6 code
6999 SYSCALL HLT

#######################################

7000 SYSCALL HLT
# Thread 7 code
7999 SYSCALL HLT

#######################################

8000 SYSCALL HLT
# Thread 8 code
8999 SYSCALL HLT

#######################################

9000 SYSCALL HLT
# Thread 9 code
9999 SYSCALL HLT

#######################################

10000 SYSCALL HLT
# Thread 10 code
19999 SYSCALL HLT

End Instruction Section
