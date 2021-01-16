/* Header file : outlib.hsc
   ------------------------
   National Technical University of Athens
   Department of Electrical and Computer Engineering
   Division of Computer Science

   Course  : Compilers
   Project : Calvin, July 1995

   Header file with I/O functions.

   Nikos Papaspyrou, 1995
*/

void    PutChar    (char c);
void    PutInteger (integer i);
void    PutString  (char s []);
char    GetChar    ();
integer GetInteger ();
void    GetString  (char & s[], integer size);
