using { SalesOrders as service } from '../service';

annotate service.Status with {
    // code @title : 'Code'
    // @Common : { 
    //     Text : name,
    //     TextArrangement : #TextOnly,
    //  }

    code @Common : { 
        Text: name,
        TextArrangement : #TextOnly,
     }
};
