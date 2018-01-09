@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
/*------------------------------------------------------------------------
   File        : CustomerRepository
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : Meelis
   Created     : Mon Nov 13 22:21:09 EET 2017
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING API.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS CustomerRepository: 
    
    DEFINE TEMP-TABLE addCustomer LIKE Customer.
    DEFINE TEMP-TABLE getCustomer LIKE Customer.
    DEFINE TEMP-TABLE updateCustomer LIKE Customer.
    
    DEFINE DATASET customerSet FOR updateCustomer.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID CreateCustomer( INPUT customerName AS CHARACTER, INPUT telephone AS CHARACTER, INPUT address AS CHARACTER,
        INPUT email AS CHARACTER, INPUT password AS CHARACTER, INPUT zipcode AS CHARACTER, 
        INPUT country AS CHARACTER, INPUT companyKey AS INTEGER, INPUT userName AS CHARACTER, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        CREATE addCustomer.
        
        FIND Company WHERE Company.CompanyKey = companyKey NO-ERROR.
        IF NOT AVAILABLE Company THEN 
        DO:
            successMessage = "Company with Key " + STRING(companyKey) + " was not found!".
            success = FALSE.
        END.
        ELSE
        DO:
            ASSIGN
                addCustomer.FULLNAME    = customerName
                addCustomer.TELEPHONE   = telephone
                addCustomer.ADDRESS     = address
                addCustomer.EMAIL       = email
                addCustomer.PASSWORD    = password
                addCustomer.ZIPCODE     = zipcode
                addCustomer.COUNTRY     = country
                addCustomer.COMPANYKEY  = companyKey
                addCustomer.USERNAME    = userName
                addCustomer.CUSTOMERKEY = GetNewId().
        
            BUFFER-COPY addCustomer TO CUSTOMER.
        
            successMessage = "Record created!".
            success = TRUE.
        END.
        
    END METHOD. 
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID DeleteCustomer( INPUT customerId AS INTEGER, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        FIND FIRST CUSTOMER WHERE CUSTOMER.CUSTOMERKEY EQ customerId EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAILABLE CUSTOMER THEN
        DO:
            DELETE CUSTOMER.
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
    METHOD PUBLIC VOID GetCustomer( INPUT customerId AS INTEGER, OUTPUT table getCustomer, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        EMPTY TEMP-TABLE getCustomer.
        
        FIND FIRST CUSTOMER WHERE CUSTOMER.CUSTOMERKEY EQ customerId NO-LOCK NO-ERROR.
        
        IF AVAILABLE CUSTOMER THEN
        DO:
            CREATE getCustomer.
            BUFFER-COPY CUSTOMER TO getCustomer.
            
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
    METHOD PUBLIC VOID GetCustomers( OUTPUT TABLE getCustomer, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL  ):
        
        EMPTY TEMP-TABLE getCustomer.
        
        FOR EACH CUSTOMER NO-LOCK:
            CREATE getCustomer.
            BUFFER-COPY CUSTOMER TO getCustomer.
        END.
        
        successMessage = "Records fetched successfully!".
        success = TRUE.

    END METHOD.
       
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    METHOD PUBLIC INTEGER GetNewId(  ):
        
        DEFINE VARIABLE customerId AS INTEGER INIT 0.
        
        FIND LAST CUSTOMER NO-LOCK NO-ERROR.
        
        IF AVAILABLE CUSTOMER THEN
        DO:
            customerId = CUSTOMER.CUSTOMERKEY.
        END.
        
        REPEAT:
            FIND FIRST CUSTOMER WHERE CUSTOMER.CUSTOMERKEY = customerId + 1 NO-LOCK NO-ERROR.
            customerId = customerId + 1.
            IF NOT AVAILABLE CUSTOMER THEN LEAVE.  
        END.
        
        RETURN customerId.
        
    END METHOD. 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID UpdateCustomer( INPUT customerId AS INTEGER, INPUT dataset customerSet, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        FIND FIRST updateCustomer.
        
        FIND FIRST CUSTOMER WHERE CUSTOMER.CUSTOMERKEY EQ customerId EXCLUSIVE-LOCK NO-ERROR.
        
        ASSIGN
            updateCustomer.CUSTOMERKEY = customerId.
        
        IF AVAILABLE CUSTOMER THEN
        DO:
            BUFFER-COPY updateCustomer TO CUSTOMER.
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