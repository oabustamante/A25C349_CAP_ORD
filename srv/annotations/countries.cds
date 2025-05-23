using {SalesOrders as service} from '../service';

annotate service.Countries with {
    @title: 'Countries'
    ID
    @Common: {
        Text : code,
        TextArrangement : #TextOnly,
    };

    // code
    // @Common: {
    //     Text: text,
    //     TextArrangement: #TextOnly,
    // }
};
