using {SalesOrders as service} from '../service';
using from './items';

annotate service.Orders with @odata.draft.enabled;

annotate service.Orders with {
    ID            @title: '{i18n>UUID}'          @Common.FieldControl : #ReadOnly;
    orderID       @title: '{i18n>OrderID}'       @Common.FieldControl : #ReadOnly;
    email         @title: '{i18n>Email}'         @assert.format       : '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'  @assert.notNull;
    firstName     @title: '{i18n>FirstName}';
    lastName      @title: '{i18n>LastName}';
    country       @title: '{i18n>Country}';
    createdOn     @title: '{i18n>CreatedOn}';
    deliveryDate  @title: '{i18n>DeliveryDate}';
    status        @title: '{i18n>Status}';
    // totalPrice    @title: '{i18n>TotalPrice}'    @Common.FieldControl: #ReadOnly                                           @Measures.ISOCurrency: currencyCode;
    // priceWithVat  @title: '{i18n>PriceWithVAT}'  @Common.FieldControl: #ReadOnly                                           @Measures.ISOCurrency: currencyCode;
    // currencyCode  @Common.IsCurrency: true                   @Common.FieldControl: #ReadOnly;
    totalPrice    @title: '{i18n>TotalPrice}'    @Measures.ISOCurrency: currency_code                                       @Common.FieldControl: #ReadOnly;
    priceWithVat  @title: '{i18n>PriceWithVAT}'  @Measures.ISOCurrency: currency_code                                       @Common.FieldControl: #ReadOnly;
    currency      @title: '{i18n>CurrencyCode}'  @Common.IsCurrency   : true                                                @assert.target;
    imageUrl      @title: '{i18n>ImageURL}';
}

annotate service.Orders with {
    status @Common: {
        Text           : status.name,
        TextArrangement: #TextOnly,
    };
// country @Common : {
//     Text: country.text,
//     TextArrangement : #TextOnly,
//  };

// country @Common: {
//     Text           : country.text,
//     TextArrangement: #TextOnly,
//     //ValueListWithFixedValues,
//     ValueList      : {
//         $Type         : 'Common.ValueListType',
//         CollectionPath: 'Countries',
//         Parameters    : [{
//             $Type            : 'Common.ValueListParameterInOut',
//             LocalDataProperty: country_ID, //country.code, //country_ID,
//             ValueListProperty: 'ID' //'code'   // ID
//         }]
//     },
// };

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
    UI.UpdateHidden                : {$edmJson: {$If: [
        { $Or: [
            {$Eq: [ {$Path: 'status_code'}, 'delivered' ]},
            {$Eq: [ {$Path: 'status_code'}, 'cancelled' ]}
        ]},
        true,
        false
    ]}},

    UI.DeleteHidden                : {$edmJson: {$If: [
        { $Or: [
            { $Eq: [ {$Path: 'status_code'}, 'delivered' ]},
            { $Eq: [ {$Path: 'status_code'}, 'cancelled' ]}
        ]},
        true,
        false
    ]}},

    // Capabilities.Deletable: {
    //                     $edmJson: {
    //                         $If: [ {
    //                             $Or: [
    //                                 {
    //                                     $Eq: [ { $Path: 'status_code' }, 'delivered' ]
    //                                 },
    //                                 {
    //                                     $Eq: [ { $Path: 'status_code' }, 'cancelled' ]
    //                                 }
    //                             ]
    //                         },
    //                         true,
    //                         false ]
    //                     }
    //                 },

    // Capabilities.DeleteRestrictions: {Deletable: false,
    // },

    // Common.SideEffects: {
    //     $Type: 'Common.SideEffectsType',
    //     SourceProperties: ['status_code'],
    //     TargetProperties: ['status_code'],
    // },

    Capabilities.FilterRestrictions: {
        $Type                       : 'Capabilities.FilterRestrictionsType',
        FilterExpressionRestrictions: [{
            $Type             : 'Capabilities.FilterExpressionRestrictionType',
            Property          : orderID,
            AllowedExpressions: 'SearchExpression'
        }]
    },
    UI.HeaderInfo                  : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : '{i18n>SalesOrder}',
        TypeNamePlural: '{i18n>SalesOrders}',
        Title         : {
            $Type: 'UI.DataField',
            Value: orderID
        },
    ImageUrl      : imageUrl,
    // Description   : {
    //     $Type: 'UI.DataField',
    //     Value: email
    // }
    },
    UI.SelectionFields             : [
        orderID,
        email,
        createdOn,
        deliveryDate,
        status_code
    ],
    UI.LineItem                    : [
        {
            $Type: 'UI.DataField',
            Value: orderID,
            Label: '{i18n>OrderID}',
            ![@HTML5.CssDefaults]: {
                $Type: 'HTML5.CssDefaultsType',
                width: '05rem'
            }
        },
        // {
        //     $Type: 'UI.DataField',
        //     Value: imageUrl
        // },
        {
            $Type: 'UI.DataField',
            Value: email,
            Label: '{i18n>Email}',
            ![@HTML5.CssDefaults]: {
                $Type: 'HTML5.CssDefaultsType',
                width: '12rem'
            }
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
            Label      : '{i18n>Status}',
            ![@HTML5.CssDefaults]: {
                $Type: 'HTML5.CssDefaultsType',
                width: '7rem'
            }
        },
        {
            $Type: 'UI.DataField',
            Value: totalPrice,
            Label: '{i18n>TotalPrice}'
        },
        {
            $Type: 'UI.DataField',
            Value: priceWithVat,
            Label: '{i18n>PriceWithVAT}'
        },
        {
            $Type: 'UI.DataFieldForAction',
            Action: 'SalesOrders.cancelOrder',
            Label: '{i18n>CancelOrder}',
            //Inline: true
        }
    ],
    UI.FieldGroup #HeaderKey       : {
        $Type: 'UI.FieldGroupType',
        Data : [
            // {
            //     $Type: 'UI.DataField',
            //     Value: ID
            // },
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
        ]
    },
    // UI.FieldGroup #HeaderImg : {
    //     $Type: 'UI.FieldGroupType',
    //     Data: [{
    //         $Type: 'UI.DataField',
    //         Value: imageUrl,
    //         Label: ''
    //     }]
    // },
    UI.FieldGroup #HeaderA         : {
        $Type: 'UI.FieldGroupType',
        Data : [
            // {
            //     $Type: 'UI.DataField',
            //     Value: email,
            //     Label: '{i18n>Email}'
            // },
            {
                $Type: 'UI.DataField',
                Value: firstName,
                Label: '{i18n>FirstName}'
            },
            {
                $Type: 'UI.DataField',
                Value: lastName,
                Label: '{i18n>LastName}'
            },
            {
                $Type: 'UI.DataField',
                Value: country_code, //country_ID,
                Label: '{i18n>Country}'
            },
        ]
    },
    UI.FieldGroup #HeaderB         : {
        $Type: 'UI.FieldGroupType',
        Data : [
            // {
            //     $Type: 'UI.DataField',
            //     Value: country_code, //country_ID,
            //     Label: '{i18n>Country}'
            // },
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
                $Type                  : 'UI.DataField',
                Value                  : status_code,
                ![@Common.FieldControl]: { $edmJson: { $If: [
                    { $Lt: [ {$Path: 'orderID'}, 1 ], },
                    1,
                    3
                ] } }
            },
        ]
    },
    UI.FieldGroup #HeaderC         : {
        $Type: 'UI.FieldGroupType',
        Data : [
            // {
            //     $Type                  : 'UI.DataField',
            //     Value                  : status_code,
            //     ![@Common.FieldControl]: { $edmJson: { $If: [
            //         { $Lt: [ {$Path: 'orderID'}, 1 ], },
            //         1,
            //         3
            //     ]
            //     // $If: [ {
            //     //         $Or: [
            //     //             {
            //     //                 $Lt: [ { $Path: 'orderID' }, 1 ]
            //     //             },
            //     //             // {
            //     //             //     $In: [ { $Path: 'status_code' }, 'delivered', 'cancelled' ]
            //     //             // }
            //     //              {
            //     //                  $Eq: [ { $Path: 'status_code' }, 'delivered' ]
            //     //              },
            //     //              {
            //     //                  $Eq: [ { $Path: 'status_code' }, 'cancelled' ]
            //     //              }
            //     //         ]
            //     //     },
            //     //     1,
            //     //     3
            //     // ]
            //     }}
            // },
            {
                $Type: 'UI.DataField',
                Value: totalPrice,
                Label: '{i18n>TotalPrice}'
            },
            {
                $Type: 'UI.DataField',
                Value: priceWithVat,
                Label: '{i18n>PriceWithVAT}'
            },
            {
                $Type: 'UI.DataField',
                Value: imageUrl,
                Label: '{i18n>ImageURL}'
            }
        ]
    },
    // UI.FieldGroup #HeaderD         : {
    //     $Type: 'UI.FieldGroupType',
    //     Data : [{
    //         $Type: 'UI.DataField',
    //         Value: priceWithVat,
    //         Label: '{i18n>PriceWithVAT}'
    //     }]
    // },
    UI.HeaderFacets                : [
        // {
        //     $Type : 'UI.ReferenceFacet',
        //     Target: '@UI.FieldGroup#HeaderImg',
        //     ID    : 'HeaderImg'
        // },
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
        // },
    ],
    UI.Facets                      : [{
        $Type : 'UI.ReferenceFacet',
        Target: 'Items/@UI.LineItem',
        Label : '{i18n>OrderItems}',
        ID    : 'Items'
    }],
    // UI.Identification: [{
    //     $Type: 'UI.DataFieldForAction',
    //     Action: 'cancelOrder',
    //     Label: 'Cancel Order',
    //     Criticality: #Negative
    // }]

);

