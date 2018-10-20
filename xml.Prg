#include <hmg.ch>
#include "common.ch"
#include "hbmxml.ch"
#include "simpleio.ch"

STATIC s_aTypes := { ;
   "MXML_ELEMENT",   ;
   "MXML_INTEGER",   ;
   "MXML_OPAQUE",    ;
   "MXML_REAL",      ;
   "MXML_TEXT"       ;
}


FUNCTION type_cb( hNode )                 /* O - Data type */
                                          /* I - Element node */
   LOCAL cType                            /* Type string */

   /*
    * You can lookup attributes and/or use the element name, hierarchy, etc...
    */

   IF Empty( cType := mxmlElementGetAttr( hNode, "type" ) )
      cType := mxmlGetElement( hNode )
   ENDIF

   SWITCH Lower( cType )
      CASE "integer" ;  RETURN MXML_INTEGER
      CASE "opaque"  ;  RETURN MXML_OPAQUE
      CASE "real"    ;  RETURN MXML_REAL
   ENDSWITCH

   RETURN MXML_TEXT

/*
 * 'whitespace_cb()' - Let the mxmlSaveFile() function know when to insert
 *                     newlines and tabs...
 */

FUNCTION whitespace_cb( hNode, nWhere )   /* O - Whitespace string or nil */
                                          /* I - Element node */
                                          /* I - Open or close tag? */

   LOCAL hParent                          /* Parent node */
   LOCAL nLevel                           /* Indentation level */
   LOCAL cName                            /* Name of element */

   /*
    * We can conditionally break to a new line before or after any element.
    * These are just common HTML elements...
    */

   cName := Lower( mxmlGetElement( hNode ) )

   IF cName == "html" .OR. cName == "head" .OR. cName == "body" .OR.                                  ;
      cName == "pre" .OR. cName == "p" .OR.                                                           ;
      cName == "h1" .OR. cName == "h2" .OR. cName == "h3" .OR.                                        ;
      cName == "h4" .OR. cName == "h5" .OR. cName == "h6"

         /*
          * Newlines before open and after close...
          */

         IF nWhere == MXML_WS_BEFORE_OPEN .OR. nWhere == MXML_WS_AFTER_CLOSE
            RETURN hb_eol()
         ENDIF
   ELSEIF cName == "dl" .OR. cName == "ol" .OR. cName == "ul"

      /*
       * Put a newline before and after list elements...
       */

      RETURN hb_eol()
   ELSEIF cName == "dd" .OR. cName == "dd" .OR. cName == "li"

      /*
       * Put a tab before <li>s, <dd>s and <dt>s and a newline after them...
       */

      IF nWhere == MXML_WS_BEFORE_OPEN
         RETURN Space( 8 )
      ELSEIF nWhere == MXML_WS_AFTER_CLOSE
         RETURN hb_eol()
      ENDIF
   ELSEIF Left( cName, 4 ) == "?xml"
      IF nWhere == MXML_WS_AFTER_OPEN
         RETURN hb_eol()
      ELSE
         RETURN nil
      ENDIF
   ELSEIF nWhere == MXML_WS_BEFORE_OPEN .OR.                                                          ;
          ( ( cName == "choice" .OR. cName == "option" ) .AND. nWhere == MXML_WS_BEFORE_CLOSE )
      nLevel := -1
      hParent := mxmlGetParent( hNode )
      DO WHILE ! Empty( hParent )
         nLevel++
         hParent := mxmlGetParent( hParent )
      ENDDO

      IF nLevel > 8
         nLevel := 8
      ELSEIF nLevel < 0
         nLevel := 0
      ENDIF

      RETURN Replicate( Chr( 9 ), nLevel )
   ELSEIF nWhere == MXML_WS_AFTER_CLOSE .OR.                                                          ;
          ( ( cName == "group" .OR. cName == "option" .OR. cName == "choice" ) .AND.                  ;
              nWhere == MXML_WS_AFTER_OPEN )

      RETURN hb_eol()
   ELSEIF nWhere == MXML_WS_AFTER_OPEN .AND. Empty( mxmlGetFirstChild( hNode ) )
      RETURN hb_eol()
   ENDIF

   /*
    * Return NULL for no added whitespace...
    */

   RETURN nil

function striptag( cStr, cTag )
   local nEnd := 0 
   local nStart := 0 
   local nSpace := 2
   local cOut := ''
   cStr := strtran( cStr, chr( 13 ) + chr( 10 ), ' ' )
   nEnd := rat( '</' + cTag + '>', cStr )
   nStart := rat( '">', cStr )
   if nStart == 0
      nStart := at( '>', cStr )
      if nStart > 0
         nSpace := 1
      endif
   endif   
   if nStart > 0 .and. nEnd > 0
      cOut := substr( cStr, nStart + nSpace, nEnd - ( nStart + nSpace ) )
      return cOut
   else
      return cStr
   endif
   return nil     