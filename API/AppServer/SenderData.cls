 @openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false"). 
  
 /*------------------------------------------------------------------------
    File        : SenderData
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : margop
    Created     : Thu Jan 18 18:32:32 EET 2018
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS SenderData: 
    
    DEFINE TEMP-TABLE addSender LIKE Pakivedu.SenderData.
    DEFINE TEMP-TABLE getSender LIKE Pakivedu.SenderData.
    DEFINE TEMP-TABLE updateSender LIKE Pakivedu.SenderData.
    
    DEFINE DATASET SenderSet FOR updateSender.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID CreateSender(  INPUT Company AS CHARACTER, INPUT ContactPerson AS CHARACTER, INPUT Telephone AS CHARACTER,
                                        INPUT Address AS CHARACTER, INPUT ZipCode AS INTEGER, INPUT Country AS CHARACTER, 
                                        INPUT CustomerKey AS INTEGER, 
                                        OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        CREATE addSender.
        
        IF ContactPerson = ? OR CustomerKey = ? THEN
        DO:
            successMessage = "Palun sisesta enda nimi ja seotud kasutaja ID".
            success = FALSE.
            RETURN.
        END.
        
        // find Sender username
        FIND Pakivedu.SenderData WHERE Pakivedu.SenderData.CustomerKey = CustomerKey NO-ERROR.
        IF NOT AVAILABLE Pakivedu.SenderData THEN 
            DO:
                successMessage = "Klienti ID'ga " + STRING(CustomerKey) + " ei eksisteeri! Palun sisesta teine kasutaja!".
                success = FALSE.
            END.
        ELSE
        DO:
            ASSIGN
                addSender.COMPANY    = Company
                addSender.CONTACTPERSON    = ContactPerson
                addSender.TELEPHONE   = Telephone
                addSender.ADDRESS     = Address
                addSender.ZIPCODE     = ZipCode
                addSender.COUNTRY     = Country
                addSender.CUSTOMERKEY  = CustomerKey
                addSender.SenderKEY = GetNewId().
        
            BUFFER-COPY addSender TO Pakivedu.SenderData.
        
            successMessage = "Record created!".
            success = TRUE.
        END.
        
    END METHOD. 
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID DeleteSender( INPUT SenderId AS INTEGER, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        FIND FIRST Pakivedu.SenderData WHERE Pakivedu.SenderData.SenderKEY EQ SenderId EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAILABLE Pakivedu.SenderData THEN
        DO:
            DELETE Pakivedu.SenderData.
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
    METHOD PUBLIC VOID GetSender( INPUT SenderId AS INTEGER, OUTPUT table getSender, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        EMPTY TEMP-TABLE getSender.
        
        FIND FIRST Pakivedu.SenderData WHERE Pakivedu.SenderData.SenderKEY EQ SenderId NO-LOCK NO-ERROR.
        
        IF AVAILABLE Pakivedu.SenderData THEN
        DO:
            CREATE getSender.
            BUFFER-COPY Pakivedu.SenderData TO getSender.
            
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
    METHOD PUBLIC VOID GetSenders( OUTPUT TABLE getSender, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL  ):
        
        EMPTY TEMP-TABLE getSender.
        
        FOR EACH Pakivedu.SenderData NO-LOCK:
            CREATE getSender.
            BUFFER-COPY Pakivedu.SenderData TO getSender.
        END.
        
        successMessage = "Records fetched successfully!".
        success = TRUE.

    END METHOD.
       
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    METHOD PUBLIC INTEGER GetNewId(  ):
        
        DEFINE VARIABLE SenderId AS INTEGER INIT 0.
        
        FIND LAST Pakivedu.SenderData NO-LOCK NO-ERROR.
        
        IF AVAILABLE Pakivedu.SenderData THEN
        DO:
            SenderId = Pakivedu.SenderData.SenderKEY.
        END.
        
        REPEAT:
            FIND FIRST Pakivedu.SenderData WHERE Pakivedu.SenderData.SenderKEY = SenderId + 1 NO-LOCK NO-ERROR.
            SenderId = SenderId + 1.
            IF NOT AVAILABLE Pakivedu.SenderData THEN LEAVE.  
        END.
        
        RETURN SenderId.
        
    END METHOD. 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID UpdateSender( INPUT SenderId AS INTEGER, INPUT dataset SenderSet, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        FIND FIRST updateSender.
        
        FIND FIRST Pakivedu.SenderData WHERE Pakivedu.SenderData.SenderKEY EQ SenderId EXCLUSIVE-LOCK NO-ERROR.
        
        ASSIGN
            updateSender.SenderKEY = SenderId.
        
        IF AVAILABLE Pakivedu.SenderData THEN
        DO:
            BUFFER-COPY updateSender TO Pakivedu.SenderData.
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