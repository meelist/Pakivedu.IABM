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

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID CreateCompany( INPUT companyName AS CHARACTER, OUTPUT successMessage AS CHARACTER, OUTPUT success AS LOGICAL ):
        
        CREATE addCompany.
        
        ASSIGN addCompany.Name = companyName
        addCompany.COMPANYKEY = GetNewId().
        
        BUFFER-COPY addCompany TO COMPANY.
        
        successMessage = "Record created!".
        success = TRUE.
        
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
    

END CLASS.