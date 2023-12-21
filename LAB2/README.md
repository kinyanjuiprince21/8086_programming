<a name="br1"></a> 



<a name="br2"></a> 

**TASK:**

Generate a gray code shaft encoder assembler program such that a user is given a choice of ‘Binary to

Gray or Gray to Binary’. The user is then made to key-in the input bits to the program. The program

outputs to a port of an Intel 8255 programmable Peripheral Interface (PPI) the corresponding gray or

binary value.

Student should then simulate the system using Proteus environment with peripherals; LEDs and Liquid

Crystal Display (LCD).

**DESCRIPTION:**

**Conversion of Gray to Binary;**

Let Gray Code be g3, g2, g1, g0. Then the respective Binary Code can be obtained as follows:

*Figure1; Gray to Binary Conversion*

The process uses the XOR operation. The XOR logic table is as below;

**A**

**1**

**B**

1

**Y**

0

**1**

0

1



<a name="br3"></a> 

**Conversion of Binary to Gray;**

Let Binary code be b3, b2, b1, b0. Then the respective Gray Code can be obtained is as follows

*Figure2; Binary to Gray Conversion*

In our solution, the program **accepts 8 bits** of either binary or grey code to entered using the keypad by

the user, the 8 bits are then converted and the equivalent stored and displayed on the LCD.

**Gray to Binary Assembly Module**



<a name="br4"></a> 



<a name="br5"></a> 

**Binary to Grey Assembly Module**



<a name="br6"></a> 



<a name="br7"></a> 

**CIRCUIT INTERFACE IN PROTEUS.**

The circuit diagram is as shown below

*Figure3; Circuit Interface in Proteus.*



<a name="br8"></a> 

**FLOWCHART:**

**a) Gray Code to Binary Code Module.**

Start

Counter = 0

Input

bit

No

No

No

Counter No

= 0?

Counter

= 1?

No

No

No

Counter

= 2?

Counter

= 3?

Counter

= 4?

Counter

= 5?

Counter

= 6?

Counter

= 7?

Yes

Yes

Yes

Yes

Yes

Yes

Yes

Yes

Bit0 =bit

Bit1= Bit0

XOR bit

Bit2 = Bit1

XOR bit

Bit3 = Bit2

XOR bit

Bit4 = Bit3

XOR bit

Bit5 = Bit4

XOR bit

Bit6 = Bit5

XOR bit

Bit7 = Bit6

XOR bit

Inc Counter

Counter

= 8?

No

Yes

Stop



<a name="br9"></a> 

**b) Binary Code to Grey Code Module.**

Start

Counter = 0

Input

bit

No

No

No

Counter No

= 0?

Counter

= 1?

No

No

No

Counter

= 2?

Counter

= 3?

Counter

= 4?

Counter

= 5?

Counter

= 6?

Counter

= 7?

Yes

Yes

Yes

Yes

Yes

Yes

Yes

Yes

Bit0 =bit

Bit1= Bit0

XOR sbit

Bit2 = Bit1

XOR sbit

Bit3 = Bit2

XOR sbit

Bit4 = Bit3

XOR sbit

Bit5 = Bit4

XOR sbit

Bit6 = Bit5

XOR sbit

Bit7 = Bit6

XOR sbit

Inc Counter

sbit =bit

No

Counter

= 8?

Yes

Stop



<a name="br10"></a> 

**c) Overall Program flow**

Start

Input

1\.Gray-Binary

2\. Binary-Grey

Input

= 1?

Input

= 2?

No

No

Yes

Yes

Convert

Binary to

Grey

Convert gray

to binary

Output

Result

Yes

Again?



<a name="br11"></a> 

**SAMPLE OUTPUT WINDOWS.**



<a name="br12"></a> 

3\. Emu8086 Documentation

