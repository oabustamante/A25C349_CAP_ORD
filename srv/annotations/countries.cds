using {SalesOrders as service} from '../service';

annotate service.Countries with {
    ID @title: 'Countries' @Common: {
        Text : text,    //code, // Lo que quiero que se muestre
        TextArrangement : #TextOnly,
    };

    // code @Common: {
    //     Text: text,
    //     TextArrangement: #TextOnly,
    // }
};
