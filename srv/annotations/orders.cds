using {SalesOrders as service} from '../service';
using from './items';

annotate service.Orders with @odata.draft.enabled;

annotate service.Orders with {
    ID            @title            : '{i18n>UUID}'        @Common.FieldControl: #ReadOnly;
    orderID       @title            : '{i18n>OrderID}'     @Common.FieldControl: #ReadOnly;
    email         @title            : '{i18n>Email}'       @assert.format      : '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'  @assert.notNull;
    firstName     @title: '{i18n>FirstName}';
    lastName      @title: '{i18n>LastName}';
    country       @title: '{i18n>Country}';
    createdOn     @title: '{i18n>CreatedOn}';
    deliveryDate  @title: '{i18n>DeliveryDate}';
    status        @title: '{i18n>Status}';
    totalPrice    @title            : '{i18n>TotalPrice}'  @Common.FieldControl: #ReadOnly                                           @Measures.ISOCurrency: currencyCode;
    currencyCode  @Common.IsCurrency: true                 @Common.FieldControl: #ReadOnly;
    imageUrl      @title: '{i18n>ImageURL}';
}

annotate service.Orders with {
    status  @Common: {
        Text           : status.name,
        TextArrangement: #TextOnly,
    };
    // country @Common : {
    //     Text: country.text,
    //     TextArrangement : #TextOnly,
    //  };

    country @Common: {
        Text           : country.text,
        TextArrangement: #TextOnly,
        //ValueListWithFixedValues,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Countries',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: country_ID, //country.code, //country_ID,
                ValueListProperty: 'ID' //'code'   // ID
            }]
        },
    };

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

annotate service.Orders with @(
    UI.HeaderInfo           : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : '{i18n>SalesOrder}',
        TypeNamePlural: '{i18n>SalesOrders}',
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
            Value: orderID,
            Label: '{i18n>OrderID}'
        },
        {
            $Type: 'UI.DataField',
            Value: email,
            Label: '{i18n>Email}'
        },
        {
            $Type: 'UI.DataField',
            Value: createdOn,
            Label: '{i18n>CreatedOn}'
        },
        {
            $Type: 'UI.DataField',
            Value: deliveryDate,
            Label: '{i18n>DeliveryDate}'
        },
        {
            $Type      : 'UI.DataField',
            Value      : status_code,
            Criticality: status.criticality,
            Label      : '{i18n>Status}'
        },
        {
            $Type: 'UI.DataField',
            Value: totalPrice,
            Label: '{i18n>TotalPrice}'
        },
    // {
    //     $Type: 'UI.DataField',
    //     //Value: currencyCode_ID,
    //     Value: currencyCode,
    // },
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
                Value: email,
                Label: '{i18n>Email}'
            },
            {
                $Type: 'UI.DataField',
                Value: firstName,
                Label: '{i18n>FirstName}'
            },
            {
                $Type: 'UI.DataField',
                Value: lastName,
                Label: '{i18n>LastName}'
            }
        ]
    },
    UI.FieldGroup #HeaderB  : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: country_ID,
                Label: '{i18n>Country}'
            },
            {
                $Type: 'UI.DataField',
                Value: createdOn,
                Label: '{i18n>CreatedOn}'
            },
            {
                $Type: 'UI.DataField',
                Value: deliveryDate,
                Label: '{i18n>DeliveryDate}'
            }
        ]
    },
    UI.FieldGroup #HeaderC  : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type                  : 'UI.DataField',
                Value                  : status_code,
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
                Value: totalPrice,
                Label: '{i18n>TotalPrice}'
            },
            {
                $Type: 'UI.DataField',
                Value: imageUrl,
                Label: '{i18n>ImageURL}'
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
