@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false"). 
/*------------------------------------------------------------------------
   File        : CustomerRepository
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : margop
   Created     : Wed Jan 17 00:25:23 EET 2018
   Notes       : 
 ----------------------------------------------------------------------*/
USING Progress.Lang.*.
USING API.*.

// guarantees that all unhandled errors in affected blocks will be propagated up to the caller
BLOCK-LEVEL ON ERROR UNDO, THROW.


CLASS CustomerRepository: 
    
    DEFINE TEMP-TABLE addCustomer LIKE Pakivedu.Customer.
    DEFINE TEMP-TABLE getCustomer LIKE Pakivedu.Customer.
    DEFINE TEMP-TABLE updateCustomer LIKE Pakivedu.Customer.
    
    DEFINE DATASET customerSet FOR updateCustomer.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID CreateCustomer(  INPUT customerName AS CHARACTER, INPUT telephone AS CHARACTER, INPUT address AS CHARACTER,
        INPUT email AS CHARACTER, INPUT password AS CHARACTER, INPUT zipcode AS CHARACTER, 
        INPUT country AS CHARACTER, INPUT companyKey AS INTEGER, INPUT userName AS CHARACTER, 
        OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        CREATE addCustomer.
        // kliendi nime, e-mail, kasutajanime ja parrooli, et 
        IF customerName = ? OR email = ? OR userName = ? OR password = ? THEN
        DO:
            successMessage = "Palun sisesta oma nimi, kasutajanimi, email ja parool".
            success = FALSE.
            DELETE addCustomer.
            RETURN.
        END.
        
        // find customer username aga ära lase andmebaasi lukku
        FIND Pakivedu.Customer WHERE Pakivedu.Customer.USERNAME EQ userName NO-LOCK NO-ERROR.
        IF AVAILABLE Pakivedu.Customer THEN 
        DO:
            successMessage = "Username " + STRING(userName) + " exists in database found! Please enter new one!".
            success = FALSE.
            DELETE addCustomer.
            RETURN.
        END.
        ELSE 
        DO:
            // find company from the system
            FIND Pakivedu.Company WHERE Pakivedu.Company.CompanyKey EQ companyKey NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Pakivedu.Company THEN 
            DO:
                successMessage = "Company with Key " + STRING(companyKey) + " was not found!".
                success = FALSE.
                DELETE addCustomer.
                RETURN.
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
                    addCustomer.CUSTOMERKEY = NEXT-VALUE (CustomerNum).
            
                BUFFER-COPY addCustomer TO Pakivedu.CUSTOMER.
            
                successMessage = "Record created!".
                success = TRUE.
            END.
        END.
        
    END METHOD. 
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID DeleteCustomer( INPUT customerId AS INTEGER, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        FIND FIRST Pakivedu.CUSTOMER WHERE Pakivedu.CUSTOMER.CUSTOMERKEY EQ customerId EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAILABLE Pakivedu.CUSTOMER THEN
        DO:
            DELETE Pakivedu.CUSTOMER.
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
        
        FIND FIRST Pakivedu.CUSTOMER WHERE Pakivedu.CUSTOMER.CUSTOMERKEY EQ customerId NO-LOCK NO-ERROR.
        
        IF AVAILABLE Pakivedu.CUSTOMER THEN
        DO:
            CREATE getCustomer.
            BUFFER-COPY Pakivedu.CUSTOMER TO getCustomer.
            
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
        
        FOR EACH Pakivedu.CUSTOMER NO-LOCK:
            CREATE getCustomer.
            BUFFER-COPY Pakivedu.CUSTOMER TO getCustomer.
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
        
        FIND LAST Pakivedu.CUSTOMER NO-LOCK NO-ERROR.
        
        IF AVAILABLE Pakivedu.CUSTOMER THEN
        DO:
            customerId = Pakivedu.CUSTOMER.CUSTOMERKEY.
        END.
        
        REPEAT:
            FIND FIRST Pakivedu.CUSTOMER WHERE Pakivedu.CUSTOMER.CUSTOMERKEY = customerId + 1 NO-LOCK NO-ERROR.
            customerId = customerId + 1.
            IF NOT AVAILABLE Pakivedu.CUSTOMER THEN LEAVE.  
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
        
        FIND FIRST Pakivedu.CUSTOMER WHERE Pakivedu.CUSTOMER.CUSTOMERKEY EQ customerId EXCLUSIVE-LOCK NO-ERROR.
        
        ASSIGN
            updateCustomer.CUSTOMERKEY = customerId.
        
        IF AVAILABLE Pakivedu.CUSTOMER THEN
        DO:
            BUFFER-COPY updateCustomer TO Pakivedu.CUSTOMER.
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