******************************************************;
* CAS-Action! Create Columns in CAS Tables - Part 1  *;
******************************************************;



****************************************;
* Create the products CAS table        *;
****************************************;

* Connect to the CAS server and name the connection CONN *;
cas conn;

* Create a libref to the CASUSER caslib *;
libname casuser cas caslib="casuser";

* Create the fake data by specifying the the path and file to create the fake data *;
%let fake_data_path =/*fakeProductsData.sas*/;
%include "&fake_data_path";


*****;
* 1 *;
*****;
* Preview the Table *;
proc cas;
    productsTbl = {name = 'products', caslib = 'casuser'};

    table.fetch / table = productsTbl;
quit;



*****;
* 2 *;
*****;
* Create a Calculated Column *;
proc cas;
    productsTbl = {name = 'products', 
                   caslib = 'casuser',
                   computedVarsProgram = 'Total_Price = Price * Quantity;'};

    table.fetch / table = productsTbl;
quit;




*****;
* 3 *;
*****;
* Create Multiple Calculated Columns *;
proc cas;
    productsTbl = {name = 'products', 
                   caslib = 'casuser',
                   computedVarsProgram = 'Total_Price = Price * Quantity;
                                          Product_fix = upcase(Product);'};

    table.fetch / table = productsTbl;
quit;




*****;
* 4 *;
*****;
* Use Conditional Logic *;
proc cas;
    productsTbl = {name = 'products', 
                   caslib = 'casuser',
                   computedVarsProgram = 'Total_Price = Price * Quantity;
                                          Product_fix = upcase(Product);
                                          if Return = "" then Return_fix = "No"; 
                                              else Return_fix = "Yes";'
    }; 

    table.fetch / table = productsTbl;
quit;



*****;
* 5 *;
*****;
* Storing the Calculated Columns in a Variable *;
proc cas;
    source createColumns;
        Total_Price = Price * Quantity;
        Product_fix = upcase(Product);
        if Return = "" then Return_fix = "No"; 
           else Return_fix = "Yes";
    endsource;

    productsTbl = {name = 'products', 
                   caslib = 'casuser',
                   computedVarsProgram = createColumns
    }; 

    table.fetch / table = productsTbl;
quit;