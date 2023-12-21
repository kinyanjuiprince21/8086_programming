<a name="br1"></a> 



<a name="br2"></a> 

**TASK:**

A program is such that it uses based indexed addressing mode to locate elements in a 10 by 10 array of

characters. A user keys in the row and column values of any element location within the array. At two

seconds interval, the character in that location is intermittently displayed on the Video Display Unit (VDU)

and each time displayed with different color. Keying ‘New’ causes the program to request the user to key-

in new element location while ‘S’ halts the program and the last display is relocated to location (0, 0) of

the VDU. Use Intel 8086 emulator to generate the program.

**DESCRIPTION**

i)

The program allows users to enter the row and column of the element they want to be displayed

on the VDU.

ii)

The system then reads the entered values of row and column and stores them in memory.

To located the element in the array, the program calculated the exact position of the element in the

array using the formula;

iii)

푃표푠푖푡푖표푛 표푓 푒푙푒푚푒푛푡 =

(푟표푤 × 10 ) + 퐶표푙푢푚푛

iv)

v)

The program then obtains the address of the array in memory using the Load Effective Address

(LEA) assembly address.

The value of the position calculated as above is used as the index for the based indexed addressing

mode to address the desired element.

vi)

The retrieved element is then displayed on the screen with different colors at intervals of 2 seconds.

An interrupt on the keyboard by the user prompts the user to enter either ‘New’ or ‘S’. If ‘New is

entered then the user is again allowed to enter ne values of row and column. If S is entered then

the programs terminates.

vii)



<a name="br3"></a> 

**FLOWCHART:**

Start

Initialize

10x10 Array

B

Input row

and column

Values

Calculate Element

Position (array Index)

Retrieve

Element

value

Display

Element

Delay

(2s)

Interrup

ted?

A



<a name="br4"></a> 

A

User Input

B

Yes

False

“New”

?

“S”?

True

GoToxy(0,0)

Display

Element

Delay (2s)

Stop

*Figure 1; The Program Flowchart.*



<a name="br5"></a> 

**ASSEMBLY CODE.**



<a name="br6"></a> 



<a name="br7"></a> 



<a name="br8"></a> 

**SAMPLE RUNNING PROGRAM WINDOW**

*Figure2; The Program running on emu8086 emulator.*

**REFERENCES.**

1\. A.P Godse and D.A Godse, “Microprocessor and interfacing”, First Edition:2009

