const { parse } = require("@sap/cds");
const cds = require("@sap/cds");
const { init } = require("@sap/cds/lib/ql/cds.ql-Query");

module.exports = class ManageSalesOrders extends cds.ApplicationService {
    //
    async init () {
        // ->
        const {Orders, Items} = this.entities;
        //
        this.before('NEW', Orders.drafts, async (req) => {
            //let today = new Date(Date.now());
            let today = new Date();


            req.data.country_ID = 'MX';
            req.data.createdOn = today.toISOString().split('T')[0];
            req.data.status_code = 'neww';
            req.data.totalPrice = 0;
            req.data.currencyCode = 'MXN';
        });

        this.before('NEW', Items.drafts, async (req) => {
            let result = await SELECT.one.from(Items).columns('max(itemPos) as maxPos');
            let result_d = await SELECT.one.from(Items.drafts).columns('max(itemPos) as maxPos').where({parentUUID_ID: req.data.parentUUID_ID});
            let maxPos = 0, maxPos_d = 0, itemPos = 0;

            result.maxPos ??= 0;
            result_d.maxPos ??= 0;

            maxPos = parseInt(result.maxPos);
            maxPos_d = parseInt(result_d.maxPos);

            if (maxPos < maxPos_d) {
                itemPos = maxPos_d + 1;
            } else {
                itemPos = maxPos + 1;
            }

            req.data.itemPos = itemPos;
        });

        this.before('CREATE', Orders, async (req) => {
            let result = await SELECT.one.from(Orders).columns('max(orderID) as maxOrderID');
            //let result_d = await SELECT.one.from()

            result.maxOrderID ??= 0;
            let maxOrdID = parseInt(result.maxOrderID) + 1;
            console.log("maxOrdID", maxOrdID);
            req.data.orderID = maxOrdID;
        });

        // <-
        return await super.init();
    }
}

// module.exports = (srv) => {
//     // // == READ ==
//     // srv.on("READ", "GetSalesOrders", async (req) => {
//     //     // ->
//     //     // <-
//     //     return await SELECT.from(Orders);
//     // });

//     init() {
//         // const {Orders} = this.entities;

//         // this.before("NEW", Orders.drafts, async (req) => {
//         //     console.log("== BEFORE ==", req.data);
//         // });

//         return super.init();
//     }
// }