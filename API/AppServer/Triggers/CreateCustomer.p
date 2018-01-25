
/*------------------------------------------------------------------------
    File        : CreateCustomer.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Mon Dec 11 21:41:15 EET 2017
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

TRIGGER PROCEDURE FOR CREATE OF Customer.
FIND FIRST Company OF Customer NO-ERROR.
IF AVAILABLE Company THEN 
DO:
    RETURN.
END.
ELSE DO:
    MESSAGE "COMPANY DOESNT EXIST" Customer.CompanyKey ". OF NAME" Customer.FullName
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN ERROR.
END.
