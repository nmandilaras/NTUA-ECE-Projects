/* Header file : string.inc
   ------------------------
   National Technical University of Athens
   Department of Electrical and Computer Engineering
   Division of Computer Science

   Course  : Compilers
   Project : Calvin, July 1995

   Header file with string manipulation functions.

   Nikos Papaspyrou, 1995
*/


void    StrCopy (char & trg[], char src[]);
void    StrCat  (char & trg[], char src[]);
integer StrComp (char s1[], char s2[]);
integer StrLen  (char s[]);
