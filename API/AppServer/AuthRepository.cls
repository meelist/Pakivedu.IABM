 /*------------------------------------------------------------------------
    File        : AuthRepository
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : margop
    Created     : Tue Jan 16 23:56:04 EET 2018
    Notes       : 
  ----------------------------------------------------------------------*/
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS AuthRepository: 


    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID Login( INPUT userName AS CHARACTER, INPUT password AS CHARACTER,
                              OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        FIND Pakivedu.CUSTOMER WHERE Pakivedu.CUSTOMER.UserName = userName AND Pakivedu.CUSTOMER.Password = Password NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Pakivedu.CUSTOMER THEN
        DO:
            successMessage = "Username or password was wrong!".
            success = FALSE.
        END.
        ELSE
        DO:
            successMessage = "Authentication was successful!".
            success = TRUE.
        END.
        
    END METHOD. 

END CLASS.