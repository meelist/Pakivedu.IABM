 @openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false"). 
 /*------------------------------------------------------------------------
    File        : ReceiverData
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : margop
    Created     : Thu Jan 18 14:39:47 EET 2018
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS ReceiverData: 
    
    DEFINE TEMP-TABLE addReceiver LIKE Pakivedu.ReceiverData.
    DEFINE TEMP-TABLE getReceiver LIKE Pakivedu.ReceiverData.
    DEFINE TEMP-TABLE updateReceiver LIKE Pakivedu.ReceiverData.
    
    DEFINE DATASET ReceiverSet FOR updateReceiver.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID CreateReceiver(  INPUT Company AS CHARACTER, INPUT ContactPerson AS CHARACTER, INPUT Telephone AS CHARACTER,
                                        INPUT Address AS CHARACTER, INPUT ZipCode AS INTEGER, INPUT Country AS CHARACTER, 
                                        INPUT CustomerKey AS INTEGER, 
                                        OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        CREATE addReceiver.
        
        IF ContactPerson = ? OR CustomerKey = ? THEN
        DO:
            successMessage = "Palun sisesta enda nimi ja seotud kasutaja ID".
            success = FALSE.
            RETURN.
        END.
        
        // find Receiver username
        FIND Pakivedu.ReceiverData WHERE Pakivedu.ReceiverData.CustomerKey = CustomerKey NO-ERROR.
        IF NOT AVAILABLE Pakivedu.ReceiverData THEN 
            DO:
                successMessage = "Klienti ID'ga " + STRING(CustomerKey) + " ei eksisteeri! Palun sisesta teine kasutaja!".
                success = FALSE.
            END.
        ELSE
        DO:
            ASSIGN
                addReceiver.COMPANY    = Company
                addReceiver.ContactPerson    = ContactPerson
                addReceiver.TELEPHONE   = Telephone
                addReceiver.ADDRESS     = Address
                addReceiver.ZIPCODE     = ZipCode
                addReceiver.COUNTRY     = Country
                addReceiver.CUSTOMERKEY  = CustomerKey
                addReceiver.ReceiverKEY = GetNewId().
        
            BUFFER-COPY addReceiver TO Pakivedu.ReceiverData.
        
            successMessage = "Record created!".
            success = TRUE.
        END.
        
    END METHOD. 
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID DeleteReceiver( INPUT ReceiverId AS INTEGER, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        FIND FIRST Pakivedu.ReceiverData WHERE Pakivedu.ReceiverData.ReceiverKEY EQ ReceiverId EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAILABLE Pakivedu.ReceiverData THEN
        DO:
            DELETE Pakivedu.ReceiverData.
            successMessage = "Record deleted!".
            success = TRUE.            
        END.
        ELSE
        DO:           
            successMessage = "Record not found!".
            success = FALSE.
        END.

    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetReceiver( INPUT ReceiverId AS INTEGER, OUTPUT table getReceiver, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        EMPTY TEMP-TABLE getReceiver.
        
        FIND FIRST Pakivedu.ReceiverData WHERE Pakivedu.ReceiverData.ReceiverKEY EQ ReceiverId NO-LOCK NO-ERROR.
        
        IF AVAILABLE Pakivedu.ReceiverData THEN
        DO:
            CREATE getReceiver.
            BUFFER-COPY Pakivedu.ReceiverData TO getReceiver.
            
            successMessage = "Record found!".
            success = TRUE.
        END.
        ELSE
        DO:
            successMessage = "Record not found!".
            success = FALSE.
        END.

    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetReceivers( OUTPUT TABLE getReceiver, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL  ):
        
        EMPTY TEMP-TABLE getReceiver.
        
        FOR EACH Pakivedu.ReceiverData NO-LOCK:
            CREATE getReceiver.
            BUFFER-COPY Pakivedu.ReceiverData TO getReceiver.
        END.
        
        successMessage = "Records fetched successfully!".
        success = TRUE.

    END METHOD.
       
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    METHOD PUBLIC INTEGER GetNewId(  ):
        
        DEFINE VARIABLE ReceiverId AS INTEGER INIT 0.
        
        FIND LAST Pakivedu.ReceiverData NO-LOCK NO-ERROR.
        
        IF AVAILABLE Pakivedu.ReceiverData THEN
        DO:
            ReceiverId = Pakivedu.ReceiverData.ReceiverKEY.
        END.
        
        REPEAT:
            FIND FIRST Pakivedu.ReceiverData WHERE Pakivedu.ReceiverData.ReceiverKEY = ReceiverId + 1 NO-LOCK NO-ERROR.
            ReceiverId = ReceiverId + 1.
            IF NOT AVAILABLE Pakivedu.ReceiverData THEN LEAVE.  
        END.
        
        RETURN ReceiverId.
        
    END METHOD. 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID UpdateReceiver( INPUT ReceiverId AS INTEGER, INPUT dataset ReceiverSet, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        FIND FIRST updateReceiver.
        
        FIND FIRST Pakivedu.ReceiverData WHERE Pakivedu.ReceiverData.ReceiverKEY EQ ReceiverId EXCLUSIVE-LOCK NO-ERROR.
        
        ASSIGN
            updateReceiver.ReceiverKEY = ReceiverId.
        
        IF AVAILABLE Pakivedu.ReceiverData THEN
        DO:
            BUFFER-COPY updateReceiver TO Pakivedu.ReceiverData.
            successMessage = "Record updated!".
            success = TRUE.
        END.
        ELSE
        DO:
            successMessage = "Record not found!".
            success = FALSE.
        END.

    END METHOD.

END CLASS.