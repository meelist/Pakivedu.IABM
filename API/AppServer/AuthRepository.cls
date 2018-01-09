@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS AuthRepository: 
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID Login( INPUT userName AS CHARACTER, INPUT password AS CHARACTER,
     OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        FIND CUSTOMER WHERE CUSTOMER.UserName = userName NO-ERROR.
        IF NOT AVAILABLE CUSTOMER THEN
        DO:
            successMessage = "User with username " + userName + " was not found!".
            success = FALSE.
        END.
        ELSE
        DO:
            successMessage = "User with username " + userName + " was found!".
            success = TRUE.
        END.
        
    END METHOD. 

END CLASS.