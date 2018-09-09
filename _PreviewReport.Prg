#include "hmg.ch"
Function Main 
DEFINE WINDOW Win_1 ROW 0 COL 0 WIDTH 400 HEIGHT 400 TITLE "Report Preview" MAIN  ON INIT TEST()
END WINDOW
Win_1.Minimize
Win_1.Activate
Return
Function Test
Use ( MemoRead("_TempTable.Txt") ) Shared
LOAD REPORT _TempReport
bSaveHandler := errorblock( { |x| break(x) } )
BEGIN SEQUENCE
     EXECUTE REPORT _TempReport PREVIEW 
     DELETE FILE RePreviewSemaforo.Txt
     Exit Program
     QUIT
RECOVER USING oError
     MSGSTOP( oError:Description + " " + oError:Operation  , "Report Error:" )
     DELETE FILE RePreviewSemaforo.Txt
     Exit Program
     QUIT
END
  errorblock( bSaveHandler )
