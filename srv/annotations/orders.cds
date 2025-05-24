using {SalesOrders as service} from '../service';
using from './items';

annotate service.Orders with @odata.draft.enabled;

annotate service.Orders with {
    ID            @title            : 'UUID'      @Common.FieldControl: #ReadOnly;
    orderID       @title            : 'Order ID'  @Common.FieldControl: #ReadOnly;
    email         @title            : 'Email'     @assert.format      : '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    firstName     @title: 'First Name';
    lastName      @title: 'Last Name';
    country       @title: 'Country';
    createdOn     @title: 'Created On';
    deliveryDate  @title: 'Delivery Date';
    status        @title: 'Status';
    totalPrice    @title            : 'Total'     @Common.FieldControl: #ReadOnly  @Measures.ISOCurrency: currencyCode;
    currencyCode  @Common.IsCurrency: true        @Common.FieldControl: #ReadOnly;
    imageUrl      @title: 'Imágen';
}

annotate service.Orders with {
    status  @Common: {
        Text           : status.name,
        TextArrangement: #TextOnly,
    };
    country @Common: {
        Text           : country.text,
        TextArrangement: #TextOnly,
        //ValueListWithFixedValues,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Countries',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: country_ID,
                ValueListProperty: 'ID'
            }]
        },
    // ValueList      : {
    //     $Type         : 'Common.ValueListType',
    //     CollectionPath: 'Countries',
    //     Parameters    : [{
    //         $Type            : 'Common.ValueListParameterInOut',
    //         LocalDataProperty: country.code,
    //         ValueListProperty: 'code'
    //     }]
    // },
    };
};

annotate service.Orders with @(
    UI.HeaderInfo           : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Sales Order',
        TypeNamePlural: 'Sales Orders',
        Title         : {
            $Type: 'UI.DataField',
            Value: orderID
        },
    // Description   : {
    //     $Type: 'UI.DataField',
    //     Value: email
    // }
    },
    UI.SelectionFields      : [
        orderID,
        email,
        createdOn,
        deliveryDate,
        status_code
    ],
    UI.LineItem             : [
        {
            $Type: 'UI.DataField',
            Value: ID,
        },
        {
            $Type: 'UI.DataField',
            Value: orderID,
        },
        {
            $Type: 'UI.DataField',
            Value: email,
        },
        {
            $Type: 'UI.DataField',
            Value: createdOn,
        },
        {
            $Type: 'UI.DataField',
            Value: deliveryDate,
        },
        {
            $Type: 'UI.DataField',
            Value: status_code,
        },
        {
            $Type: 'UI.DataField',
            Value: totalPrice,
        },
        {
            $Type: 'UI.DataField',
            Value: totalPrice,
        },
        {
            $Type: 'UI.DataField',
            //Value: currencyCode_ID,
            Value: currencyCode,
        },
    ],
    UI.FieldGroup #HeaderKey: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: ID
            },
            {
                $Type: 'UI.DataField',
                Value: orderID
            }
        ]
    },
    UI.FieldGroup #HeaderA  : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: email
            },
            {
                $Type: 'UI.DataField',
                Value: firstName
            },
            {
                $Type: 'UI.DataField',
                Value: lastName
            }
        ]
    },
    UI.FieldGroup #HeaderB  : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: country_ID
            },
            {
                $Type: 'UI.DataField',
                Value: createdOn
            },
            {
                $Type: 'UI.DataField',
                Value: deliveryDate
            }
        ]
    },
    UI.FieldGroup #HeaderC  : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type                  : 'UI.DataField',
                Value                  : status_code,
                //Criticality : status
                ![@Common.FieldControl]: {$edmJson: {$If: [
                    {$Eq: [
                        {$Path: 'IsActiveEntity'},
                        false
                    ]},
                    3,
                    1
                ]}}
            },
            {
                $Type: 'UI.DataField',
                Value: totalPrice
            },
            {
                $Type: 'UI.DataField',
                Value: imageUrl
            }
        ]
    },
    // UI.FieldGroup #HeaderD: {
    //     $Type: 'UI.FieldGroupType',
    //     Data : [{
    //         $Type: 'UI.DataField',
    //         Value: imageUrl
    //     }]
    // },
    UI.HeaderFacets         : [
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#HeaderKey',
            ID    : 'HeaderKey'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#HeaderA',
            ID    : 'HeaderA'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#HeaderB',
            ID    : 'HeaderB'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#HeaderC',
            ID    : 'HeaderC'
        },
    // {
    //     $Type : 'UI.ReferenceFacet',
    //     Target: '@UI.FieldGroup#HeaderD',
    //     ID    : 'HeaderD'
    // }
    ],
    UI.Facets               : [{
        $Type : 'UI.ReferenceFacet',
        Target: 'Items/@UI.LineItem',
        Label : 'Order Items',
        ID    : 'Items'
    }]
);
