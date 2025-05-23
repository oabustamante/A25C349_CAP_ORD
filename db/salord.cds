// Descartar


namespace com.logali.Orders;

entity Orders {
    ID              : String;
    orderID         : Integer;
    email           : String;
    firstName       : String;
    lastName        : String;
    country_ID      : String;
    createdOn       : Date;
    deliveryDate    : Date;
    status_code     : String;
    totalPrice      : Decimal(10, 2);
    currencyCode_ID : String;
    imageUrl        : LargeString;
    createdAt       : Date;
    createdBy       : String;
    modifiedAt      : Date;
    modifiedBy      : String;
}
