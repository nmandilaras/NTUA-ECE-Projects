#ifndef ERROR_HANDLER
#define ERROR_HANDLER

class ErrorHandlerClass
{
  public :
   void Error(char *)    { }
   void Internal(char *) { }
   void Fatal(char *)    { }
   void Message(char *)  { }
   void Warning(char *)  { }
};

#endif
