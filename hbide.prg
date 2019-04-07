#include "hbclass.ch"
#include "inkey.ch"
#include "setcurs.ch"

#xcommand MENU [<oMenu>] => [ <oMenu> := ] HBDbMenu():New()
#xcommand MENUITEM [ <oMenuItem> PROMPT ] <cPrompt> ;
          [ IDENT <nIdent> ] [ ACTION <uAction,...> ] ;
          [ CHECKED <bChecked> ] => ;
   [ <oMenuItem> := ] HBDbMenu():AddItem( HBDbMenuItem():New( <cPrompt>, ;
   [{|| <uAction> }], [<bChecked>], [<nIdent>] ) )
#xcommand SEPARATOR => HBDbMenu():AddItem( HBDbMenuItem():New( "-" ) )
#xcommand ENDMENU => ATail( HBDbMenu():aMenus ):Build()

//-----------------------------------------------------------------------------------------//

function Main()

   local cBack := SaveScreen( 0, 0, MaxRow(), MaxCol() )
   local oMenu := BuildMenu()
   local oWndCode := HBDbWindow():New( 1, 0, MaxRow() - 1, MaxCol(), "noname.prg", "W/B" )
   local oEditor  := BuildEditor()
   local nOldCursor := SetCursor( SC_NORMAL )

   SET COLOR TO "W/B"
   CLEAR SCREEN
   SetPos( 2, 1 )
   
   oMenu:Display()
   oWndCode:Show( .T. )
   oEditor:Display()

   while .T.
      nKey = Inkey( 0, INKEY_ALL )
      if nKey == K_LBUTTONDOWN
         if MRow() == 0 .or. oMenu:IsOpen()
            nOldCursor = SetCursor( SC_NONE )
            oMenu:ProcessKey( nKey )
            if ! oMenu:IsOpen()
               SetCursor( nOldCursor )
            endif 
         endif
      else 
         if oMenu:IsOpen() 
            oMenu:ProcessKey( nKey )
            if ! oMenu:IsOpen()
               SetCursor( nOldCursor )
            endif
         else
            SetCursor( nOldCursor )
            oEditor:Edit( nKey )
            oEditor:Display() 
            // oEditor:DisplayLine( oEditor:Row() + 2 )
            // oEditor:DisplayLine( oEditor:Row() + 1 )
            // oEditor:DisplayLine( oEditor:Row() + 2 )
         endif
      endif
   end

   RestScreen( 0, 0, MaxRow(), MaxCol(), cBack )

return nil

//-----------------------------------------------------------------------------------------//

FUNCTION BuildMenu()

   LOCAL oMenu

   MENU oMenu
      MENUITEM " ~File "
      MENU
         MENUITEM "~New"              ACTION Alert( "new" )
         MENUITEM "~Open..."          ACTION Alert( "open" )
         MENUITEM "~Save"             ACTION Alert( "save" )
         MENUITEM "Save ~As... "      ACTION Alert( "saveas" )
         SEPARATOR
         MENUITEM "E~xit"             ACTION __Quit()
      ENDMENU

      MENUITEM " ~Edit "
      MENU
         MENUITEM "~Copy "
         MENUITEM "~Paste "
         SEPARATOR
         MENUITEM "~Find... "
         MENUITEM "~Repeat Last Find  F3 "
         MENUITEM "~Change..."
         SEPARATOR
         MENUITEM "~Goto Line..."    
      ENDMENU

      MENUITEM " ~Run "
      MENU
         MENUITEM "~Start "
         MENUITEM "S~cript "
         MENUITEM "~Debug "   
      ENDMENU

      MENUITEM " ~Options "
      MENU
         MENUITEM "~Compiler Flags... "
         MENUITEM "~Display... "           
      ENDMENU 

      MENUITEM " ~Help "
      MENU
         MENUITEM "~Index "
         MENUITEM "~Contents "
         SEPARATOR
         MENUITEM "~About... "      ACTION Alert( "HbIde 1.0" )
      ENDMENU  
   ENDMENU

return oMenu

//-----------------------------------------------------------------------------------------//