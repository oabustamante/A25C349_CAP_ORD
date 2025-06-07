using {com.logali as entities} from '../db/schema';

service SalesOrders {
    entity Orders         as projection on entities.Orders  actions {
        //@(Common.SideEffects.TargetProperties: ['/status_code'])
        //@Common.SideEffects: {TargetEntities:['/SalesOrders.Orders']}
        @Common.SideEffects: {
            $Type: 'Common.SideEffectsType',
            TargetProperties: [
                'in/status_code'
            ],
            TargetEntities: [
                'in/status'
            ]
        }
        action cancelOrder (in : $self)
    };
    entity Items          as projection on entities.Items;
    // Code List
    entity Status         as projection on entities.Status;
    // Value Helps
    //entity Countries      as projection on entities.Countries;
    //entity Currencies     as projection on entities.Currencies;
    entity UnitsOfMeasures as projection on entities.UnitsOfMeasures;

    //action cancelOrder ();
}