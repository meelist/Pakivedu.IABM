 /*------------------------------------------------------------------------
    File        : Test
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : margop
    Created     : Mon Jan 01 15:25:28 EET 2018
    Notes       : 
  ----------------------------------------------------------------------*/
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS Customer: 
    
    DEFINE TEMP-TABLE addCustomer LIKE Pakivedu.Customer.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID CreateCustomer( INPUT custName AS CHARACTER, INPUT custAddr AS CHARACTER, OUTPUT successMsg AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        CREATE addCustomer.
        
            ASSIGN 
                addCustomer.Name        = custName
                addCustomer.Address     = custAddr
                addCustomer.CustomerKey    = getCustID().
                
                BUFFER-COPY addCustomer TO Pakivedu.Customer.
                
                successMsg = "Customer created!".
                success = TRUE.

    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC INTEGER getCustID(  ):
        DEFINE VARIABLE custID AS INTEGER INIT 0.
        FIND LAST Pakivedu.Customer NO-LOCK NO-ERROR.
        
        IF AVAILABLE Pakivedu.Customer THEN
        DO:
            custID = Pakivedu.Customer.CustomerKey.
        END.
        
        REPEAT:
            FIND FIRST Pakivedu.Customer WHERE Customer.CustomerKey = custID + 1 NO-LOCK NO-ERROR.
            custID = custID + 1.
            IF NOT AVAILABLE Pakivedu.Customer THEN LEAVE.
            
        END.
        
        RETURN custID.

    END METHOD.    

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC CHARACTER Hello( INPUT msg AS CHARACTER, OUTPUT successMsg AS CHARACTER, OUTPUT success AS LOGICAL):
        successMsg = "Hello World!".
        success = TRUE.        
        RETURN msg.

    END METHOD.

END CLASS.