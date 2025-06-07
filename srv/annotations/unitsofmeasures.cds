using {SalesOrders as service} from '../service';

annotate service.UnitsOfMeasures with {
    @title: 'Unit of Measures'
    code    @Common: {
         Text           : text,
         TextArrangement: #TextOnly,
    };
    //code  @title : 'Code'         @Common.FieldControl: #ReadOnly;
    text  @title : 'Description'  @Common.FieldControl: #ReadOnly;
};
