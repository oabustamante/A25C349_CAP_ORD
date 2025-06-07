using {SalesOrders as service} from '../service';

annotate service.Items with {
    itemPos          @title: '{i18n>ItemPosition}'   @Common.FieldControl : #ReadOnly;
    name             @title: '{i18n>Name}'           @assert.notNull;
    description      @title: '{i18n>Description}';
    releaseDate      @title: '{i18n>ReleaseDate}';
    discontinuedDate @title: '{i18n>DiscontinuedDate}';
    price            @title: '{i18n>Price}'          @Measures.ISOCurrency: currency_code  @assert.range: [
        (0),
        _
    ];
    currency         @title: '{i18n>CurrencyCode}'   @Common.IsCurrency   : true           @assert.notNull  @assert.target;
    height           @title: '{i18n>Height}'         @assert.range        : [
        0,
        _
    ]; //  @Measures.Unit: unitOfMeasure;
    width            @title: '{i18n>Width}'          @assert.range        : [
        0,
        _
    ]; // @Measures.Unit: unitOfMeasure;
    depth            @title: '{i18n>Depth}'          @assert.range        : [
        0,
        _
    ]; // @Measures.Unit: unitOfMeasure;
    quantity         @title: '{i18n>Quantity}'       @assert.range        : [
        (0),
        _
    ];
    unitOfMeasure    @title: '{i18n>UnitOfMeasure}'  @Common.IsUnit; //@Common.FieldControl : #ReadOnly;
};

annotate service.Items with {
    // currencyCode  @Common: {
    //     Text           : currencyCode.code,
    //     TextArrangement: #TextOnly,
    //     ValueList      : {
    //         $Type         : 'Common.ValueListType',
    //         CollectionPath: 'Currencies',
    //         Parameters    : [{
    //             $Type            : 'Common.ValueListParameterInOut',
    //             LocalDataProperty: currencyCode_ID,
    //             ValueListProperty: 'ID'
    //         }]
    //     },
    // };

    // unitOfMeasure @Common: {
    //     Text           : unitOfMeasure.code,
    //     TextArrangement: #TextOnly,
    //     ValueList      : {
    //         $Type         : 'Common.ValueListType',
    //         CollectionPath: 'UnitOfMeasures',
    //         Parameters    : [{
    //             $Type            : 'Common.ValueListParameterInOut',
    //             LocalDataProperty: unitOfMeasure_ID,
    //             ValueListProperty: 'ID'
    //         }]
    //     },
    // };

    unitOfMeasure @Common: {
        Text           : unitOfMeasure.text,
        TextArrangement: #TextOnly,
        ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'UnitsOfMeasures',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: unitOfMeasure_code,
                ValueListProperty: 'code'
            }]
        },
    };
};

annotate service.Items with @(
    // UI.HeaderInfo       : {
    //     $Type         : 'UI.HeaderInfoType',
    //     TypeName      : 'Item',
    //     TypeNamePlural: 'Items',
    //     Title         : {
    //         $Type: 'UI.DataField',
    //         Value: itemPos
    //     },
    //     Description   : {
    //         $Type: 'UI.DataField',
    //         Value: description,

    //     }
    // },
    UI.FieldGroup #Items: {
        $Type: 'UI.FieldGroupType',
        Data : [
            // {
            //     $Type: 'UI.DataField',
            //     Value: ID
            // },
            {
                $Type: 'UI.DataField',
                Value: itemPos,
                Label: '{i18n>ItemPosition}'
            },
            {
                $Type: 'UI.DataField',
                Value: name,
                Label: '{i18n>Name}'
            },
            {
                $Type: 'UI.DataField',
                Value: description,
                Label: '{i18n>Description}'
            },
            {
                $Type: 'UI.DataField',
                Value: price,
                Label: '{i18n>Price}'
            },
            // {
            //     $Type: 'UI.DataField',
            //     Value: currency_code, //currencyCode_ID,
            //     Label: '{i18n>CurrencyCode}'
            // },
            {
                $Type: 'UI.DataField',
                Value: quantity,
                Label: '{i18n>Quantity}'
            },
            {
                $Type: 'UI.DataField',
                Value: releaseDate,
                Label: '{i18n>ReleaseDate}'
            },
            {
                $Type: 'UI.DataField',
                Value: discontinuedDate,
                Label: '{i18n>DiscontinuedDate}'
            },
            {
                $Type: 'UI.DataField',
                Value: height,
                Label: '{i18n>Height}'
            },
            {
                $Type: 'UI.DataField',
                Value: width,
                Label: '{i18n>Width}'
            },
            {
                $Type: 'UI.DataField',
                Value: depth,
                Label: '{i18n>Depth}'
            },
            // {
            //     $Type: 'UI.DataField',
            //     Value: unitOfMeasure_ID,
            //     Label: '{i18n>UnitOfMeasure}'
            // },
            {
                $Type: 'UI.DataField',
                Value: unitOfMeasure_code,
                Label: '{i18n>UnitOfMeasure}'
            },
        ],
        Label: '{i18n>ItemDetail}'
    },
    UI.LineItem         : [
        {
            $Type: 'UI.DataField',
            Value: itemPos,
            Label: '{i18n>ItemPosition}'
        },
        {
            $Type: 'UI.DataField',
            Value: name,
            Label: '{i18n>Name}'
        },
        {
            $Type: 'UI.DataField',
            Value: description,
            Label: '{i18n>Description}'
        },
        {
            $Type: 'UI.DataField',
            Value: releaseDate,
            Label: '{i18n>ReleaseDate}'
        },
        {
            $Type: 'UI.DataField',
            Value: price,
            Label: '{i18n>Price}'
        },
    ],
    UI.Facets           : [{
        $Type : 'UI.ReferenceFacet',
        Target: '@UI.FieldGroup#Items',
        Label : '{i18n>OrderItem}',
        ID    : 'ItemPos'
    }]
);
