using {SalesOrders as service} from '../service';

annotate service.Currencies with {
    @title: 'Currencies'
    ID    @Common: {
        Text           : code,
        TextArrangement: #TextOnly,
    };
    code  @title : 'Code'         @Common.FieldControl: #ReadOnly;
    text  @title : 'Description'  @Common.FieldControl: #ReadOnly;
};
