using {com.logali as entities} from '../db/schema';

service SalesOrders {
    entity Orders         as projection on entities.Orders;
    entity Items          as projection on entities.Items;
    // Code List
    entity Status         as projection on entities.Status;
    // Value Helps
    entity Countries      as projection on entities.Countries;
    entity Currencies     as projection on entities.Currencies;
    entity UnitOfMeasures as projection on entities.UnitOfMeasures;
}