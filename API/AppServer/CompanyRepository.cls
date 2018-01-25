@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
 
/*------------------------------------------------------------------------
   File        : Company
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : Meelis
   Created     : Fri Nov 10 15:45:23 EET 2017
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS CompanyRepository: 
    
    DEFINE TEMP-TABLE addCompany LIKE COMPANY.
    DEFINE TEMP-TABLE getCompany LIKE COMPANY.
    DEFINE TEMP-TABLE updateCompany LIKE COMPANY.
    
    DEFINE DATASET companySet FOR updateCompany.
    
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID CreateCompany( INPUT companyName AS CHARACTER, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        CREATE addCompany.
        
        ASSIGN 
            addCompany.Name = companyName.
            ///addCompany.COMPANYKEY = GetNewId().
            
        CREATE Company.
        ASSIGN Company.Name = companyName.
            
        //BUFFER-COPY Company TO addCompany.
        
        //BUFFER-COPY addCompany TO COMPANY.
        
        successMessage = "Record created!".
        success = TRUE.
        
    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID DeleteCompany( INPUT companyId AS INTEGER, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        FIND FIRST COMPANY WHERE COMPANY.COMPANYKEY EQ companyId EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAILABLE COMPANY THEN
        DO:         
            DELETE COMPANY.
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
    METHOD PUBLIC VOID GetCompanies( OUTPUT TABLE getCompany, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL  ):
        
        EMPTY TEMP-TABLE getCompany.
        
        FOR EACH COMPANY NO-LOCK:
            CREATE getCompany.
            BUFFER-COPY COMPANY TO getCompany.
        END.
        
        successMessage = "Records fetched successfully!".
        success = TRUE.

    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetCompany( INPUT companyId AS INTEGER, OUTPUT TABLE getCompany, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        EMPTY TEMP-TABLE getCompany.
        
        FIND FIRST COMPANY WHERE COMPANY.COMPANYKEY EQ companyId NO-LOCK NO-ERROR.
        
        IF AVAILABLE COMPANY THEN
        DO:
            CREATE getCompany.
            BUFFER-COPY COMPANY TO getCompany.
            
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

    METHOD PUBLIC INTEGER GetNewId(  ):
        
        DEFINE VARIABLE companyId AS INTEGER INIT 0.
        
        FIND LAST COMPANY NO-LOCK NO-ERROR.
        
        IF AVAILABLE COMPANY THEN
        DO:
            companyId = COMPANY.COMPANYKEY.
        END.
        
        REPEAT:
            FIND FIRST COMPANY WHERE COMPANY.COMPANYKEY = companyId + 1 NO-LOCK NO-ERROR.
            companyId = companyId + 1.
            IF NOT AVAILABLE COMPANY THEN LEAVE.  
        END.
        
        RETURN companyId.
        
    END METHOD.    

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID UpdateCompany( INPUT companyId AS INTEGER, INPUT DATASET companySet, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        FIND FIRST updateCompany.
        
        FIND FIRST COMPANY WHERE COMPANY.COMPANYKEY EQ companyId EXCLUSIVE-LOCK NO-ERROR.
        
        ASSIGN 
            updateCompany.COMPANYKEY = companyId.
        
        IF AVAILABLE COMPANY THEN
        DO:
            BUFFER-COPY updateCompany TO COMPANY.
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