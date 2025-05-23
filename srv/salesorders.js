// Descartar


const cds = require("@sap/cds");

const { Orders } = cds.entities("com.logali");

module.exports = (srv) => {
    // == READ ==
    srv.on("READ", "GetSalesOrders", async (req) => {
        // ->
        // <-
        return await SELECT.from(Orders);
    });
}