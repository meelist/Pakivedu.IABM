 CREATE TABLE "PUB"."CUSTOMER"
          (
          CustomerKey  INTEGER NOT NULL PRIMARY KEY,
          Name  VARCHAR (250),
          Telephone  VARCHAR (250),
          Address  VARCHAR (250),
          Email  VARCHAR (250),
          Password  VARCHAR (250),
          ZipCode  VARCHAR (250),
          Country  VARCHAR (250),
          FK_CompanyKey INTEGER REFERENCES "PUB"."COMPANY" ( CompanyKey )
          ) ;