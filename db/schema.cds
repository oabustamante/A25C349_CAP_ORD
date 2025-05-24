namespace com.logali;

using {
    cuid,
    managed,
    sap.common.CodeList
} from '@sap/cds/common';

define type dec_10_2 : Decimal(10, 2); // Price
define type dec_7_3  : Decimal(7, 3); // Measure
define type dec_6_3  : Decimal(6, 3); // Quantity

define type cur_code : String(3);
define type uom_code : String(3);

entity Orders : cuid, managed {
    orderID      : Integer;
    email        : String @mandatory @assert.unique;    // @Core.Immutable
    firstName    : String;
    lastName     : String;
    country      : Association to Countries; // country, country_ID
    createdOn    : Date;
    deliveryDate : Date;
    status       : Association to Status; // status, status_code
    totalPrice   : dec_10_2;
    currencyCode : cur_code; //Association to Currencies; // currencyCode, currencyCode_ID
    imageUrl     : LargeString;
    Items        : Composition of many Items
                       on Items.parentUUID = $self;
};

entity Items : cuid {
    parentUUID       : Association to Orders;
    itemPos          : Integer;
    name             : String;
    description      : String;
    releaseDate      : Date;
    discontinuedDate : Date;
    price            : dec_10_2 default 0;
    currencyCode     : Association to Currencies;  //cur_code default 'US';
    height           : dec_7_3 default 0;
    width            : dec_7_3 default 0;
    depth            : dec_7_3 default 0;
    quantity         : dec_6_3 default 0;
    unitOfMeasure    : Association to UnitOfMeasures;   //uom_code default 'CM';
};

/**
 * Code List
 **/

entity Status : CodeList {
    key code : String(10) enum {
            neww = 'New';
            preparing = 'Preparing';
            sent = 'Sent';
            cancelled = 'Cancelled';
        }
};

/**
 * Value Helps
 **/
entity Countries : cuid {
    code : String(3);
    text : String(40);
};

entity Currencies : cuid {
    code : String(3);
    text : String(40);
};

entity UnitOfMeasures : cuid {
    code : String(3);
    text : String(40);
};
