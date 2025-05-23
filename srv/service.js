const { parse } = require("@sap/cds");
const cds = require("@sap/cds");
const { init } = require("@sap/cds/lib/ql/cds.ql-Query");

module.exports = class ManageSalesOrders extends cds.ApplicationService {
    //
    init () {
        // ->
        const {Orders, Items} = this.entities;
        //
        // this.before("NEW", Orders.drafts, async (req) => {
        //     console.log("== BEFORE ==", req.data);
        //     //
        //     console.log("== Order.Status ==", req.data.Status);
        //     console.log("== Order.status_code ==", req.data.status_code);

        //     req.data ??= {
        //         orderID : 1,
        //         status_code: 'neww',
        //         currencyCode: 'MXN'
        //     }

        //     if (req.data === null || req.data === 'undefined') {
        //         req.data.firstName = 'Juan';
        //         req.data.currencyCode = 'MXN';
        //         req.data.country_ID = 'MX';
        //     }
        //     console.log("== Order.Status ==", req.data.Status);
        //     console.log("== Order.status_code ==", req.data.status_code);
        //     console.log("== Order.currencyCode ==", req.data.currencyCode);
        //     console.log("== BEFORE ==", req.data);
        // });

        this.before('NEW', Items.drafts, async (req) => {
            let result = await SELECT.one.from(Items).columns('max(itemPos) as maxPos');
            let result_d = await SELECT.one.from(Items.drafts).columns('max(itemPos) as maxPos').where({parentUUID_ID: req.data.parentUUID_ID});
            
            let maxPos = parseInt(result.maxPos);
            let maxPos_d = parseInt(result_d.maxPos);

            let maxPosition = 0;

            if(isNaN(maxPos_d)) {
                maxPosition = maxPos + 1;
            } else if (maxPos < maxPos_d) {
                maxPosition = maxPos_d + 1;
            } else {
                maxPosition = maxPos + 1;
            }

            //console.log("data", req.data);
            
            // if (result.maxPos === 'undefined' || result.maxPos === 0) {
            //     result.maxPos = 1;
            // } else {
            //     result.maxPos += 1;
            // }
            //req.data.itemPos = result.maxPos;
            //console.log("result", result);
            req.data.itemPos = maxPosition;
        });

        // <-
        return super.init();
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