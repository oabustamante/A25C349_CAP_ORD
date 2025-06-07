const { parse } = require("@sap/cds");
const { rawListeners } = require("@sap/cds");
const cds = require("@sap/cds");
const { init } = require("@sap/cds/lib/ql/cds.ql-Query");

module.exports = class ManageSalesOrders extends cds.ApplicationService {
    //
    init () {
        // ->
        const {Orders, Items} = this.entities;
        //

        this.after('READ', Orders, async (orders) => {
            for(let order of orders) {
                if (order.totalPrice > 0) {
                    order.priceWithVat = order.totalPrice + (order.totalPrice * (1/100) );
                }
            }
        });

        this.before('NEW', Orders.drafts, async (req) => {
            //let today = new Date(Date.now());
            let today = new Date();

            //req.data.country_ID = 'MX';
            req.data.createdOn = today.toISOString().split('T')[0];
            req.data.status_code = 'neww';
            req.data.totalPrice = 0;
            //req.data.currencyCode = 'MXN';
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
            // -> Next OrderID
            let result = await SELECT.one.from(Orders).columns('max(orderID) as maxOrderID');

            result.maxOrderID ??= 0;
            let maxOrdID = parseInt(result.maxOrderID) + 1;
            // console.log("maxOrdID", maxOrdID);
            req.data.orderID = maxOrdID;
            // <- Next OrderID
            // -> TotalPrice
            let totalPrice = 0;
            req.data.Items.forEach((item) => {
                totalPrice = totalPrice + (item.price * item.quantity);
            });
            req.data.totalPrice = totalPrice;
            // <- TotalPrice
        });

        this.before('UPDATE', Orders, async (req) => {
            if (req.data.createdOn >= req.data.deliveryDate ) {
                return req.reject(400, `Delivery date ${req.data.deliveryDate} must be greater than create date!`);
                //return;
            }
            if (req.data.totalPrice < 1 && req.data.status_code != 'neww' ) {
                return req.reject(400, `At least 1 item with price and quantity to change Order status`);
                //return;
            }
        });

        this.before('DELETE', async (req) => {
            if (req.data.status_code == 'delivered' || req.data.status_code == 'cancelled') {
                return req.reject(400, `Order status delivered or cancelled are not deletable!`);
                //return;
            }
        });

        this.on('cancelOrder', Orders, async (req) => {
            //console.log('Req.Data: ', req.params[0].ID);
            let order = await cds
                .tx(req)
                .read(Orders)
                 .where({ID: req.params[0].ID});
            if (order[0].status_code !== 'delivered' && order[0].status_code !== 'cancelled') {
                let result = await cds
                    .tx(req)
                    .update(Orders, {ID: req.params[0].ID})
                    .with({
                        status_code: 'cancelled'
                    });
            } else {
                req.error(409, 'No es posible cancelar');
            }
            // req.info()
        });

        // <-
        return super.init();
    }
}

