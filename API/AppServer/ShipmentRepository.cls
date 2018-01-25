 
 /*------------------------------------------------------------------------
    File        : Shipment
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : margop
    Created     : Wed Jan 17 20:22:41 EET 2018
    Notes       : 
  ----------------------------------------------------------------------*/
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
USING Progress.Lang.*.
USING API.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS ShipmentRepository: 

    DEFINE TEMP-TABLE addShipment LIKE Pakivedu.Shipment.
    DEFINE TEMP-TABLE getShipment LIKE Pakivedu.Shipment.
    DEFINE TEMP-TABLE updateShipment LIKE Pakivedu.Shipment.
    
    DEFINE DATASET shipmentSet FOR updateShipment.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID AddShipment( INPUT customerId AS INT, INPUT shipmentDate AS DATE, INPUT Product AS CHARACTER, INPUT UnitCount AS INT, INPUT TotalWeight AS INT, 
        INPUT Addinfo AS CHARACTER, INPUT SenderID AS INTEGER, INPUT ReceiverID AS INTEGER, INPUT priceEUR AS INT, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        CREATE addShipment.
        
        FIND Pakivedu.CUSTOMER WHERE Pakivedu.CUSTOMER.CustomerKey = customerId NO-ERROR.
        IF NOT AVAILABLE Pakivedu.CUSTOMER THEN 
        DO:
            successMessage = "Customer with ID " + STRING(companyKey) + " was not found!".
            success = FALSE.
        END.
        ELSE
        DO:
            ASSIGN
                addShipment.CUSTOMERKEY  = customerId
                addShipment.SHIPMENTDATE = shipmentDate
                addShipment.SHIPMENTKEY  = GetNewId()
                addShipment.PRODUCT      = Product
                addShipment.UNITCOUNT    = UnitCount
                addShipment.TOTALWEIGHT  = TotalWeight
                addShipment.ADDINFO      = Addinfo
                addShipment.SENDERKEY    = SenderID
                addShipment.RECEIVERKEY  = ReceiverID
                addShipment.PRICEEUR     = priceEUR.
        
            BUFFER-COPY addShipment TO Pakivedu.CUSTOMER.
        
            successMessage = "Record created!".
            success = TRUE.
        END.
        
    END METHOD. 
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID DeleteShipment( INPUT shipmentId AS INTEGER, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        FIND FIRST Pakivedu.SHIPMENT WHERE Pakivedu.Shipment.SHIPMENTKEY EQ shipmentId EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAILABLE Pakivedu.SHIPMENT THEN
        DO:
            DELETE Pakivedu.SHIPMENT.
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
    METHOD PUBLIC VOID GetShipment( INPUT shipmentId AS INTEGER, OUTPUT table getShipment, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        EMPTY TEMP-TABLE getShipment.
        
        FIND FIRST Pakivedu.SHIPMENT WHERE Pakivedu.SHIPMENT.SHIPMENTKEY EQ shipmentId NO-LOCK NO-ERROR.
        
        IF AVAILABLE Pakivedu.SHIPMENT THEN
        DO:
            CREATE getShipment.
            BUFFER-COPY Pakivedu.SHIPMENT TO getShipment.
            
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
    METHOD PUBLIC VOID ListShipments( OUTPUT TABLE getShipment, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL  ):
        
        EMPTY TEMP-TABLE getShipment.
        
        FOR EACH Pakivedu.SHIPMENT NO-LOCK:
            CREATE getShipment.
            BUFFER-COPY Pakivedu.SHIPMENT TO getShipment.
        END.
        
        successMessage = "Records fetched successfully!".
        success = TRUE.

    END METHOD.
       
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    METHOD PUBLIC INTEGER GetNewId(  ):
        
        DEFINE VARIABLE shipmentId AS INTEGER INIT 0.
        
        FIND LAST Pakivedu.SHIPMENT NO-LOCK NO-ERROR.
        
        IF AVAILABLE Pakivedu.SHIPMENT THEN
        DO:
            shipmentId = Pakivedu.SHIPMENT.SHIPMENTKEY.
        END.
        
        REPEAT:
            FIND FIRST Pakivedu.SHIPMENT WHERE Pakivedu.SHIPMENT.SHIPMENTKEY = shipmentId + 1 NO-LOCK NO-ERROR.
            shipmentId = shipmentId + 1.
            IF NOT AVAILABLE Pakivedu.SHIPMENT THEN LEAVE.  
        END.
        
        RETURN shipmentId.
        
    END METHOD. 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID UpdateShipment( INPUT shipmentId AS INTEGER, INPUT dataset shipmentSet, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        FIND FIRST updateShipment.
        
        FIND FIRST Pakivedu.SHIPMENT WHERE Pakivedu.SHIPMENT.SHIPMENTKEY EQ shipmentId EXCLUSIVE-LOCK NO-ERROR.
        
        ASSIGN
            updateShipment.SHIPMENTKEY = shipmentId.
        
        IF AVAILABLE Pakivedu.SHIPMENT THEN
        DO:
            BUFFER-COPY updateShipment TO Pakivedu.SHIPMENT.
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