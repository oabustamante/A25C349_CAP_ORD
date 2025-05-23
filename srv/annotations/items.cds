using {SalesOrders as service} from '../service';

annotate service.Items with {
    itemPos          @title: 'Position';
    name             @title: 'Name';
    description      @title: 'Description';
    releaseDate      @title: 'Released Date';
    discontinuedDate @title: 'Discontinued Date';
    price            @title: 'Price';
    currencyCode     @title: 'Currency';
height           @title: 'Height';  //  @Measures.Unit: unitOfMeasure;
    width            @title: 'Width';   // @Measures.Unit: unitOfMeasure;
    depth            @title: 'Depth';    // @Measures.Unit: unitOfMeasure;
    quantity         @title: 'Quantity';
    unitOfMeasure    @title: 'Base unit' @Common.IsUnit;    //@Common.FieldControl : #ReadOnly;
};

annotate service.Items with {
    currencyCode @Common:{
        Text : currencyCode.code,
        TextArrangement: #TextOnly,
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Currencies',
            Parameters:[{
                $Type:'Common.ValueListParameterInOut',
                LocalDataProperty: currencyCode_ID,
                ValueListProperty: 'ID'
            }]
        },
    };
    unitOfMeasure @Common: {
        Text : unitOfMeasure.code,
        TextArrangement: #TextOnly,
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'UnitOfMeasures',
            Parameters:[{
                $Type:'Common.ValueListParameterInOut',
                LocalDataProperty: unitOfMeasure_ID,
                ValueListProperty: 'ID'
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
                Value: itemPos
            },
            {
                $Type: 'UI.DataField',
                Value: name
            },
            {
                $Type: 'UI.DataField',
                Value: description
            },
                        {
                $Type: 'UI.DataField',
                Value: releaseDate
            },
            {
                $Type: 'UI.DataField',
                Value: discontinuedDate
            },
            {
                $Type: 'UI.DataField',
                Value: price
            },
            {
                $Type: 'UI.DataField',
                Value: currencyCode_ID
            },
            {
                $Type: 'UI.DataField',
                Value: height
            },
            {
                $Type: 'UI.DataField',
                Value: width
            },
            {
                $Type: 'UI.DataField',
                Value: depth
            },
            {
                $Type: 'UI.DataField',
                Value: unitOfMeasure_ID
            },
            {
                $Type: 'UI.DataField',
                Value: quantity
            },
        ],
        Label: 'Item detail'
    },
    UI.LineItem         : [
        {
            $Type: 'UI.DataField',
            Value: itemPos
        },
        {
            $Type: 'UI.DataField',
            Value: name
        },
        {
            $Type: 'UI.DataField',
            Value: description
        },
        {
            $Type: 'UI.DataField',
            Value: releaseDate
        },
        {
            $Type: 'UI.DataField',
            Value: price
        },
    ],
    UI.Facets         : [{
        $Type : 'UI.ReferenceFacet',
        Target: '@UI.FieldGroup#Items',
        Label : 'Order Item',
        ID    : 'ItemPos'
    }]
);
