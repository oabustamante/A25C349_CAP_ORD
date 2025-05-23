using {SalesOrders as service} from '../service';

annotate service.UnitOfMeasures with {
    @title: 'Unit of Measures'
    ID    @Common: {
        Text           : code,
        TextArrangement: #TextOnly,
    };
    code  @title : 'Code'         @Common.FieldControl: #ReadOnly;
    text  @title : 'Description'  @Common.FieldControl: #ReadOnly;
};
