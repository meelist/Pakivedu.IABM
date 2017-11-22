 
 /*------------------------------------------------------------------------
    File        : Customers
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Meelis
    Created     : Mon Nov 20 23:50:20 EET 2017
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS Customers: 
    DEFINE PROPERTY Name AS CHARACTER NO-UNDO GET. SET.
    DEFINE PROPERTY Telephone AS CHARACTER NO-UNDO GET. SET.
    DEFINE PROPERTY Address AS CHARACTER NO-UNDO GET. SET.
    DEFINE PROPERTY Email AS CHARACTER NO-UNDO GET. SET.
    DEFINE PROPERTY Password AS CHARACTER NO-UNDO GET. SET.
    DEFINE PROPERTY Zipcode AS CHARACTER NO-UNDO GET. SET.
    DEFINE PROPERTY Country AS CHARACTER NO-UNDO GET. SET.
    DEFINE PROPERTY FK_CompanyKey AS INTEGER NO-UNDO GET. SET.

END CLASS.